import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:dart_ping/dart_ping.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/speed_test_model.dart';
import '../model/test_history_model.dart';
import '../utils/history_service.dart';
import '../utils/notification_service.dart';

class SpeedTestController {
  final SpeedTestModel _model = SpeedTestModel();
  final NetworkInfo _networkInfo = NetworkInfo();

  // Getters for the model
  SpeedTestModel get model => _model;

  // Stream controller for model updates
  final StreamController<SpeedTestModel> _modelController =
      StreamController<SpeedTestModel>.broadcast();

  Stream<SpeedTestModel> get modelStream => _modelController.stream;

  // Network connectivity stream subscription
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void _notifyModelUpdate() {
    _modelController.add(_model);
  }

  Future<void> initialize() async {
    await _requestPermissions();
    await NotificationService.initialize();
    await _checkInitialConnection();
    await _fetchNetworkAndCarrierInfo();
    await _runPing();

    // Start listening for network connectivity changes
    _startNetworkMonitoring();
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
    await Permission.locationWhenInUse.request();
    await Permission.notification.request();
  }

  Future<void> _checkInitialConnection() async {
    if (!await _isNetworkAvailable()) {
      throw Exception('No internet connection available');
    }
  }

  Future<bool> _isNetworkAvailable() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    if (connectivityResults.isEmpty ||
        connectivityResults.contains(ConnectivityResult.none)) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _fetchNetworkAndCarrierInfo() async {
    String deviceIP = 'Unavailable';
    String wifiProvider = '';

    print('Starting network info fetch...');

    // Check current connectivity
    final connectivityResults = await Connectivity().checkConnectivity();
    print('Current connectivity: $connectivityResults');

    // Try multiple methods to get device IP based on connectivity type
    if (connectivityResults.contains(ConnectivityResult.wifi)) {
      // For WiFi, try to get local IP first
      try {
        deviceIP = await _networkInfo.getWifiIP() ?? 'Unavailable';
        print('WiFi IP obtained: $deviceIP');
      } catch (e) {
        print('WiFi IP failed: $e');
        deviceIP = 'Unavailable';
      }
    } else if (connectivityResults.contains(ConnectivityResult.mobile)) {
      // For mobile, skip the WiFi IP method and go straight to network interfaces
      print('Mobile connection detected, will use network interfaces');
      deviceIP = 'Unavailable';
    }

    // If still no IP, try to get local IP from network interfaces
    if (deviceIP == 'Unavailable' || deviceIP.isEmpty) {
      try {
        final interfaces = await NetworkInterface.list();
        String? localIP;

        for (final interface in interfaces) {
          for (final addr in interface.addresses) {
            if (addr.type == InternetAddressType.IPv4 &&
                !addr.address.startsWith('127.') &&
                !addr.address.startsWith('169.254.')) {
              // Prefer WiFi/Ethernet interfaces over others
              if (interface.name.toLowerCase().contains('wi-fi') ||
                  interface.name.toLowerCase().contains('wifi') ||
                  interface.name.toLowerCase().contains('ethernet') ||
                  interface.name.toLowerCase().contains('en0') ||
                  interface.name.toLowerCase().contains('wlan')) {
                deviceIP = addr.address;
                print(
                  'Found preferred interface IP: $deviceIP on ${interface.name}',
                );
                break;
              } else if (localIP == null) {
                // Keep first valid IP as fallback
                localIP = addr.address;
              }
            }
          }
          if (deviceIP != 'Unavailable') break;
        }

        // Use fallback IP if no preferred interface found
        if (deviceIP == 'Unavailable' && localIP != null) {
          deviceIP = localIP;
          print('Using fallback IP: $deviceIP');
        }
      } catch (e) {
        print('Network interface IP failed: $e');
      }
    }

    // Only try to get public IP if we have no IP at all
    if (deviceIP == 'Unavailable' || deviceIP.isEmpty) {
      try {
        final ipResp = await http
            .get(
              Uri.parse('https://api.ipify.org?format=json'),
              headers: {'User-Agent': 'Mozilla/5.0'},
            )
            .timeout(Duration(seconds: 10));

        if (ipResp.statusCode == 200) {
          final ipData = json.decode(ipResp.body);
          deviceIP = ipData['ip'] ?? 'Unavailable';
          print('Public IP from external service: $deviceIP');
        }
      } catch (e) {
        print('Public IP failed: $e');
      }
    }

    // Get ISP/Provider information
    try {
      final ipResp = await http
          .get(
            Uri.parse('https://api.ipify.org?format=json'),
            headers: {'User-Agent': 'Mozilla/5.0'},
          )
          .timeout(Duration(seconds: 10));

      if (ipResp.statusCode == 200) {
        final ip = json.decode(ipResp.body)['ip'];
        final ispResp = await http
            .get(
              Uri.parse('https://ipinfo.io/$ip/json'),
              headers: {'User-Agent': 'Mozilla/5.0'},
            )
            .timeout(Duration(seconds: 10));

        if (ispResp.statusCode == 200) {
          final ispData = json.decode(ispResp.body);
          wifiProvider = ispData['org'] ?? ispData['isp'] ?? 'Unknown';
          wifiProvider = wifiProvider.replaceFirst(RegExp(r'^AS\d+\s+'), '');
        } else {
          wifiProvider = 'Unknown';
        }
      } else {
        wifiProvider = 'Unknown';
      }
    } catch (e) {
      print('ISP info failed: $e');
      wifiProvider = 'Unknown';
    }

    print('Final IP: $deviceIP, Provider: $wifiProvider');
    _model.setNetworkInfo(deviceIP, wifiProvider);
    print(
      'Model updated with IP: ${_model.wifiIP}, Provider: ${_model.wifiProvider}',
    );
    _notifyModelUpdate();
  }

  Future<void> _runPing() async {
    try {
      // Set initial state
      _model.setPingResult('Testing...');
      _notifyModelUpdate();

      // Try multiple ping targets for better reliability
      final pingTargets = ['8.8.8.8', '1.1.1.1', '208.67.222.222'];
      final allResults = <double>[];

      for (final target in pingTargets) {
        try {
          print('Trying ping to $target...');
          final ping = Ping(
            target,
            count: 5,
            timeout: 3000,
          ); // Increased count for jitter calculation
          final targetResults = <double>[];

          await for (final PingData data in ping.stream) {
            if (data.response != null && data.response!.time != null) {
              final pingTime = data.response!.time!.inMilliseconds.toDouble();
              print('Successful ping to $target: ${pingTime}ms');
              targetResults.add(pingTime);
            } else if (data.error != null) {
              print('Ping error for $target: ${data.error}');
            }
          }

          // If we got multiple successful pings, calculate jitter
          if (targetResults.length >= 3) {
            allResults.addAll(targetResults);
            break; // Use this target's results for jitter calculation
          } else if (targetResults.isNotEmpty) {
            // If we got some results but not enough for jitter, use them for basic ping
            allResults.addAll(targetResults);
          }
        } catch (e) {
          print('Ping failed for $target: $e');
          continue;
        }
      }

      if (allResults.isNotEmpty) {
        if (allResults.length >= 3) {
          // Calculate jitter (standard deviation of ping times)
          final avg = allResults.reduce((a, b) => a + b) / allResults.length;
          final variance =
              allResults
                  .map((x) => (x - avg) * (x - avg))
                  .reduce((a, b) => a + b) /
              allResults.length;
          final jitter = sqrt(variance);

          print(
            'Average ping: ${avg.toStringAsFixed(0)}ms, Jitter: ${jitter.toStringAsFixed(1)}ms',
          );
          _model.setPingResult('${avg.toStringAsFixed(0)}');
          _model.setJitter(jitter);
          _notifyModelUpdate();
        } else {
          // Fallback to simple average if not enough data for jitter
          final avg = allResults.reduce((a, b) => a + b) / allResults.length;
          print(
            'Average ping: ${avg.toStringAsFixed(0)}ms (insufficient data for jitter)',
          );
          _model.setPingResult('${avg.toStringAsFixed(0)}');
          _model.setJitter(0.0); // No jitter data available
          _notifyModelUpdate();
        }
      } else {
        print('All ICMP pings failed, trying HTTP ping...');
        // Try alternative ping method using HTTP
        await _runHttpPing();
      }
    } catch (e) {
      print('Ping error: $e');
      _model.setPingResult('Failed');
      _model.setJitter(0.0);
      _notifyModelUpdate();
    }
  }

  Future<void> _runHttpPing() async {
    try {
      print('Starting HTTP ping to Google...');
      final httpResults = <double>[];

      // Perform multiple HTTP pings to calculate jitter
      for (int i = 0; i < 3; i++) {
        try {
          final stopwatch = Stopwatch()..start();
          final response = await http
              .get(
                Uri.parse('https://www.google.com'),
                headers: {
                  'Connection': 'close',
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                },
              )
              .timeout(Duration(seconds: 10));

          stopwatch.stop();

          if (response.statusCode == 200) {
            final pingTime = stopwatch.elapsedMilliseconds.toDouble();
            print('HTTP ping ${i + 1} successful: ${pingTime}ms');
            httpResults.add(pingTime);
          } else {
            print(
              'HTTP ping ${i + 1} failed with status: ${response.statusCode}',
            );
          }
        } catch (e) {
          print('HTTP ping ${i + 1} error: $e');
        }

        // Small delay between pings
        if (i < 2) await Future.delayed(Duration(milliseconds: 500));
      }

      if (httpResults.isNotEmpty) {
        if (httpResults.length >= 2) {
          // Calculate jitter for HTTP pings
          final avg = httpResults.reduce((a, b) => a + b) / httpResults.length;
          final variance =
              httpResults
                  .map((x) => (x - avg) * (x - avg))
                  .reduce((a, b) => a + b) /
              httpResults.length;
          final jitter = sqrt(variance);

          print(
            'HTTP ping average: ${avg.toStringAsFixed(0)}ms, Jitter: ${jitter.toStringAsFixed(1)}ms',
          );
          _model.setPingResult('${avg.toStringAsFixed(0)}');
          _model.setJitter(jitter);
        } else {
          // Single result
          final pingTime = httpResults.first;
          print('HTTP ping successful: ${pingTime}ms (single result)');
          _model.setPingResult('${pingTime.toStringAsFixed(0)}');
          _model.setJitter(0.0); // No jitter data available
        }
        _notifyModelUpdate();
      } else {
        print('All HTTP pings failed');
        _model.setPingResult('Failed');
        _model.setJitter(0.0);
        _notifyModelUpdate();
      }
    } catch (e) {
      print('HTTP ping error: $e');
      _model.setPingResult('Failed');
      _model.setJitter(0.0);
      _notifyModelUpdate();
    }
  }

  Future<void> startSequentialTest() async {
    // Preserve jitter value before reset
    final preservedJitter = _model.jitter;
    final preservedPingResult = _model.pingResult;

    print(
      'Before reset - Jitter: $preservedJitter, Ping: $preservedPingResult',
    );

    _model.reset();

    // Restore jitter and ping values
    _model.setJitter(preservedJitter);
    _model.setPingResult(preservedPingResult);

    print(
      'After restore - Jitter: ${_model.jitter}, Ping: ${_model.pingResult}',
    );
    _notifyModelUpdate();

    // First run download test
    await _testDownload();

    // Wait a moment, then run upload test
    await Future.delayed(Duration(seconds: 2));
    await _testUpload();

    print(
      'After speed tests - Jitter: ${_model.jitter}, Ping: ${_model.pingResult}',
    );

    // Save test results to history
    await _saveTestResults();
  }

  Future<void> _saveTestResults() async {
    try {
      // Parse ping result to get numeric value
      double pingValue = 0.0;
      final pingMatch = RegExp(
        r'(\d+(?:\.\d+)?)',
      ).firstMatch(_model.pingResult);
      if (pingMatch != null) {
        pingValue = double.tryParse(pingMatch.group(1)!) ?? 0.0;
      }

      final entry = TestHistoryEntry(
        dateTime: DateTime.now(),
        downloadSpeed: _model.downloadSpeed,
        uploadSpeed: _model.uploadSpeed,
        ping: pingValue,
        jitter: _model.jitter, // Add jitter to history
        downloadSuccess: _model.downloadSuccess,
        uploadSuccess: _model.uploadSuccess,
      );

      await HistoryService.addTestEntry(entry);

      // Show complete speed test notification
      try {
        await NotificationService.showSpeedTestCompleteNotification(
          downloadSpeed: _model.downloadSpeed,
          uploadSpeed: _model.uploadSpeed,
          ping: pingValue,
          jitter: _model.jitter, // Add jitter to notification
        );
      } catch (e) {
        // Silently handle notification errors
        print('Error showing complete test notification: $e');
      }
    } catch (e) {
      // Silently handle errors when saving history
      print('Error saving test history: $e');
    }
  }

  Future<void> _testDownload() async {
    if (!await _isNetworkAvailable()) {
      throw Exception('No internet connection available');
    }

    const downloadUrl = 'https://speed.cloudflare.com/__down?bytes=25000000';
    _model.setDownloadTesting(true);
    _model.setDownloadSpeed(0);
    _model.setDownloadSuccess(false);
    _notifyModelUpdate();

    final stopwatch = Stopwatch()..start();
    int totalBytes = 0;

    try {
      final httpClient = HttpClient()
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      final request = await httpClient.getUrl(Uri.parse(downloadUrl));
      request.headers.set(
        HttpHeaders.userAgentHeader,
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      );
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      await for (var chunk in response) {
        totalBytes += chunk.length;
        final elapsed = stopwatch.elapsedMilliseconds / 1000;
        if (elapsed > 0) {
          final currentSpeed = (totalBytes * 8) / (elapsed * 1000000);
          _model.setDownloadSpeed(currentSpeed);
          _notifyModelUpdate();
        }
      }

      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds > 0
          ? stopwatch.elapsedMilliseconds
          : 1;
      final seconds = elapsedMs / 1000;
      final speedMbps = (totalBytes * 8) / (seconds * 1000000);

      _model.setDownloadSuccess(true);
      _model.setDownloadSpeed(speedMbps);
      _notifyModelUpdate();

      // Show download completion notification
      try {
        await NotificationService.showDownloadCompleteNotification(
          downloadSpeed: speedMbps,
        );
      } catch (e) {
        // Silently handle notification errors
        print('Error showing download notification: $e');
      }
    } catch (e) {
      _model.setDownloadSuccess(false);
      throw e;
    } finally {
      _model.setDownloadTesting(false);
      _model.setDownloadTested(true);
      _notifyModelUpdate();
    }
  }

  Future<void> _testUpload() async {
    if (!await _isNetworkAvailable()) {
      throw Exception('No internet connection available');
    }

    const uploadUrl = 'https://speed.cloudflare.com/__up';
    final uploadBytes = _generateTestData(5 * 1024 * 1024);

    _model.setUploadTesting(true);
    _model.setUploadSpeed(0);
    _model.setUploadSuccess(false);
    _notifyModelUpdate();

    final stopwatch = Stopwatch()..start();
    final client = HttpClient();

    try {
      final req = await client.postUrl(Uri.parse(uploadUrl));
      req.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/octet-stream',
      );

      const chunkSize = 64 * 1024;
      int totalSent = 0;

      while (totalSent < uploadBytes.length) {
        final end = min(totalSent + chunkSize, uploadBytes.length);
        req.add(uploadBytes.sublist(totalSent, end));
        totalSent = end;

        final elapsed = stopwatch.elapsedMilliseconds / 1000;
        if (elapsed > 0) {
          final currentSpeed = (totalSent * 8) / (elapsed * 1000000);
          _model.setUploadSpeed(currentSpeed);
          _notifyModelUpdate();
        }

        await Future.delayed(Duration(milliseconds: 10));
      }

      final response = await req.close();
      await response.drain();

      stopwatch.stop();
      final sec = stopwatch.elapsedMilliseconds / 1000.0;
      final mbps = (uploadBytes.length * 8) / (sec * 1000000);

      _model.setUploadSpeed(mbps);
      _model.setUploadSuccess(true);
      _notifyModelUpdate();

      // Show upload completion notification
      try {
        await NotificationService.showUploadCompleteNotification(
          uploadSpeed: mbps,
        );
      } catch (e) {
        // Silently handle notification errors
        print('Error showing upload notification: $e');
      }
    } catch (e) {
      _model.setUploadSuccess(false);
      throw e;
    } finally {
      _model.setUploadTesting(false);
      _model.setUploadTested(true);
      _notifyModelUpdate();
    }
  }

  Uint8List _generateTestData(int byteCount) {
    final rand = Random();
    return Uint8List.fromList(
      List<int>.generate(byteCount, (_) => rand.nextInt(256)),
    );
  }

  void _startNetworkMonitoring() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      print('Network connectivity changed: $results');
      // Update network info when connectivity changes
      _fetchNetworkAndCarrierInfo();
    });
  }

  // Public method to manually refresh network information
  Future<void> refreshNetworkInfo() async {
    print('Manually refreshing network information...');
    await _fetchNetworkAndCarrierInfo();
  }

  // Public method to trigger model update
  void notifyModelUpdate() {
    _notifyModelUpdate();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _modelController.close();
  }
}
