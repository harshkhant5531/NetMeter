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
  final StreamController<SpeedTestModel> _modelController = StreamController<SpeedTestModel>.broadcast();
  
  Stream<SpeedTestModel> get modelStream => _modelController.stream;
  
  void _notifyModelUpdate() {
    _modelController.add(_model);
  }

  Future<void> initialize() async {
    await _requestPermissions();
    await NotificationService.initialize();
    await _checkInitialConnection();
    await _fetchNetworkAndCarrierInfo();
    await _runPing();
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
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
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
    String? wifiIP;
    String wifiProvider = '';
    
    try {
      wifiIP = await _networkInfo.getWifiIP();
    } catch (e) {
      wifiIP = 'Unavailable';
    }
    
    try {
      final ipResp = await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if (ipResp.statusCode == 200) {
        final ip = json.decode(ipResp.body)['ip'];
        final ispResp = await http.get(Uri.parse('https://ipinfo.io/$ip/json'));
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
      wifiProvider = 'Unknown';
    }
    
    _model.setNetworkInfo(wifiIP ?? '', wifiProvider);
    _notifyModelUpdate();
  }

  Future<void> _runPing() async {
    try {
      final ping = Ping('8.8.8.8', count: 3);
      final results = <double>[];
      
      await for (final PingData data in ping.stream) {
        if (data.response != null && data.response!.time != null) {
          results.add(data.response!.time!.inMilliseconds.toDouble());
        }
      }
      
      if (results.isNotEmpty) {
        final avg = results.reduce((a, b) => a + b) / results.length;
        _model.setPingResult('${avg.toStringAsFixed(0)}');
        _notifyModelUpdate();
      } else {
        _model.setPingResult('Failed');
        _notifyModelUpdate();
      }
    } catch (e) {
      _model.setPingResult('Error');
      _notifyModelUpdate();
    }
  }

  Future<void> startSequentialTest() async {
    _model.reset();
    
    // First run download test
    await _testDownload();
    
    // Wait a moment, then run upload test
    await Future.delayed(Duration(seconds: 2));
    await _testUpload();
    
    // Save test results to history
    await _saveTestResults();
  }

  Future<void> _saveTestResults() async {
    try {
      // Parse ping result to get numeric value
      double pingValue = 0.0;
      final pingMatch = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(_model.pingResult);
      if (pingMatch != null) {
        pingValue = double.tryParse(pingMatch.group(1)!) ?? 0.0;
      }

      final entry = TestHistoryEntry(
        dateTime: DateTime.now(),
        downloadSpeed: _model.downloadSpeed,
        uploadSpeed: _model.uploadSpeed,
        ping: pingValue,
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
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final request = await httpClient.getUrl(Uri.parse(downloadUrl));
      request.headers.set(HttpHeaders.userAgentHeader, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
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
      final elapsedMs = stopwatch.elapsedMilliseconds > 0 ? stopwatch.elapsedMilliseconds : 1;
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
      req.headers.set(HttpHeaders.contentTypeHeader, 'application/octet-stream');

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
    return Uint8List.fromList(List<int>.generate(byteCount, (_) => rand.nextInt(256)));
  }

  void dispose() {
    _modelController.close();
  }
} 