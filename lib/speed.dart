
// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:speed_test/view/network_evaluation.dart';
// import 'package:speed_test/view/network_information.dart';
// import 'package:speed_test/view/ping.dart';
// import 'package:speed_test/view/daily_usage.dart';
// import 'package:gauge_indicator/gauge_indicator.dart';
// import 'package:dart_ping/dart_ping.dart';
// import 'package:network_info_plus/network_info_plus.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SpeedTestScreen extends StatefulWidget {
//   final bool isDarkMode;
//   final VoidCallback onToggleTheme;

//   const SpeedTestScreen({
//     super.key,
//     required this.isDarkMode,
//     required this.onToggleTheme,
//   });

//   @override
//   _SpeedTestScreenState createState() => _SpeedTestScreenState();
// }

// class _SpeedTestScreenState extends State<SpeedTestScreen> with TickerProviderStateMixin {
//   bool _testingDownload = false;
//   bool _testingUpload = false;
//   double _downloadSpeed = 0;
//   double _uploadSpeed = 0;
//   bool _downloadTested = false;
//   bool _uploadTested = false;
//   bool _downloadSuccess = false;
//   bool _uploadSuccess = false;

//   // Ping and network info state
//   String _pingResult = 'Loading...';
//   String _wifiIP = '';
//   String _wifiProvider = '';

//   // Animation controllers
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimations();
//     _checkInitialConnection();
//     _initializeNotifications();
//     _fetchNetworkAndCarrierInfo();
//     _runPing();
//     _requestPermissions();

//     // Ensure initial speed values are 0
//     _downloadSpeed = 0;
//     _uploadSpeed = 0;
//   }

//   void _initializeAnimations() {
//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _pulseAnimation = Tween<double>(
//       begin: 1.0,
//       end: 1.2,
//     ).animate(CurvedAnimation(
//       parent: _pulseController,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     super.dispose();
//   }

//   Future<void> _initializeNotifications() async {
//     const androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const iosInitSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const initializationSettings = InitializationSettings(
//       android: androidInitSettings,
//       iOS: iosInitSettings,
//     );

//     try {
//       final initialized = await _notificationsPlugin.initialize(initializationSettings);
//       if (initialized != true) {
//         print('Failed to initialize notifications');
//         return;
//       }

//       if (Platform.isAndroid) {
//         final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//         final granted = await androidPlugin?.requestNotificationsPermission();
//         if (granted != true) {
//           print('Notification permission denied');
//         }
//       }

//       if (Platform.isIOS) {
//         final iosPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>();
//         final granted = await iosPlugin?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//         if (granted != true) {
//           print('iOS notification permission denied');
//         }
//       }
//     } catch (e) {
//       print('Error initializing notifications: $e');
//     }
//   }

//   Future<void> _showSpeedTestNotification() async {
//     const androidDetails = AndroidNotificationDetails(
//       'speed_test_channel',
//       'Speed Test Results',
//       channelDescription: 'Notifications for speed test results',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: true,
//     );
//     const iosDetails = DarwinNotificationDetails();
//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _notificationsPlugin.show(
//       0,
//       'Speed Test Completed',
//       'Download: ${_downloadSpeed.toStringAsFixed(2)} Mbps | Upload: ${_uploadSpeed.toStringAsFixed(2)} Mbps',
//       notificationDetails,
//     );
//   }

//   Future<void> _fetchNetworkAndCarrierInfo() async {
//     final info = NetworkInfo();
//     String? wifiIP;
//     String wifiProvider = '';

//     try {
//       wifiIP = await info.getWifiIP();
//     } catch (e) {
//       wifiIP = 'Unavailable';
//     }

//     try {
//       final ipResp = await http.get(Uri.parse('https://api.ipify.org?format=json'));
//       if (ipResp.statusCode == 200) {
//         final ip = json.decode(ipResp.body)['ip'];
//         final ispResp = await http.get(Uri.parse('https://ipinfo.io/$ip/json'));
//         if (ispResp.statusCode == 200) {
//           final ispData = json.decode(ispResp.body);
//           wifiProvider = ispData['org'] ?? ispData['isp'] ?? 'Unknown';
//           // Remove ASN prefix if present
//           wifiProvider = wifiProvider.replaceFirst(RegExp(r'^AS\d+\s+'), '');
//         } else {
//           wifiProvider = 'Unknown';
//         }
//       } else {
//         wifiProvider = 'Unknown';
//       }
//     } catch (e) {
//       wifiProvider = 'Unknown';
//     }

//     setState(() {
//       _wifiIP = wifiIP ?? '';
//       _wifiProvider = wifiProvider;
//     });
//   }

//   Future<void> _runPing() async {
//     try {
//       final ping = Ping('8.8.8.8', count: 3);
//       final results = <double>[];

//       await for (final PingData data in ping.stream) {
//         if (data.response != null && data.response!.time != null) {
//           results.add(data.response!.time!.inMilliseconds.toDouble());
//         }
//       }

//       if (results.isNotEmpty) {
//         final avg = results.reduce((a, b) => a + b) / results.length;
//         setState(() {
//           _pingResult = '${avg.toStringAsFixed(0)}';
//         });
//       } else {
//         setState(() {
//           _pingResult = 'Failed';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _pingResult = 'Error';
//       });
//     }
//   }

//   Future<void> _requestPermissions() async {
//     await Permission.location.request();
//     await Permission.locationWhenInUse.request();
//   }

//   Future<void> _checkInitialConnection() async {
//     if (!await _isNetworkAvailable()) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _showNoInternetDialog();
//       });
//     }
//   }

//   Future<void> _testDownload() async {
//     if (!await _isNetworkAvailable()) {
//       _showNoInternetDialog();
//       return;
//     }

//     const downloadUrl = 'https://speed.cloudflare.com/__down?bytes=25000000';
//     setState(() {
//       _testingDownload = true;
//       _downloadSpeed = 0;
//       _downloadSuccess = false;
//     });

//     final stopwatch = Stopwatch()..start();
//     int totalBytes = 0;

//     try {
//       final httpClient = HttpClient()
//         ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//       final request = await httpClient.getUrl(Uri.parse(downloadUrl));
//       request.headers.set(HttpHeaders.userAgentHeader, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36');
//       request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
//       final response = await request.close();

//       if (response.statusCode != 200) {
//         throw Exception('HTTP ${response.statusCode}');
//       }

//       await for (var chunk in response) {
//         totalBytes += chunk.length;
//         final elapsed = stopwatch.elapsedMilliseconds / 1000;
//         if (elapsed > 0) {
//           final currentSpeed = (totalBytes * 8) / (elapsed * 1000000);
//           setState(() {
//             _downloadSpeed = currentSpeed;
//           });

//         }
//       }

//       stopwatch.stop();
//       final elapsedMs = stopwatch.elapsedMilliseconds > 0 ? stopwatch.elapsedMilliseconds : 1;
//       final seconds = elapsedMs / 1000;
//       final speedMbps = (totalBytes * 8) / (seconds * 1000000);

//       setState(() {
//         _downloadSuccess = true;
//         _downloadSpeed = speedMbps;
//       });

//       // Start pulse animation on success
//       _pulseController.repeat(reverse: true);

//     } catch (e) {
//       print('Download error: $e');
//       setState(() {
//         _downloadSuccess = false;
//       });
//     } finally {
//       setState(() {
//         _testingDownload = false;
//         _downloadTested = true;
//       });

//       if (_downloadTested && _uploadTested && _downloadSuccess && _uploadSuccess) {
//         _showSpeedTestNotification();
//       }
//     }
//   }

//   Future<void> _testUpload() async {
//     if (!await _isNetworkAvailable()) {
//       _showNoInternetDialog();
//       return;
//     }

//     const uploadUrl = 'https://speed.cloudflare.com/__up';
//     final uploadBytes = _generateTestData(5 * 1024 * 1024);

//     setState(() {
//       _testingUpload = true;
//       _uploadSpeed = 0;
//       _uploadSuccess = false;
//     });

//     final stopwatch = Stopwatch()..start();
//     final client = HttpClient();
//     bool uploadSuccess = false;

//     try {
//       final req = await client.postUrl(Uri.parse(uploadUrl));
//       req.headers.set(HttpHeaders.contentTypeHeader, 'application/octet-stream');

//       const chunkSize = 64 * 1024;
//       int totalSent = 0;

//       while (totalSent < uploadBytes.length) {
//         final end = min(totalSent + chunkSize, uploadBytes.length);
//         req.add(uploadBytes.sublist(totalSent, end));
//         totalSent = end;

//         final elapsed = stopwatch.elapsedMilliseconds / 1000;
//         if (elapsed > 0) {
//           final currentSpeed = (totalSent * 8) / (elapsed * 1000000);
//           setState(() {
//             _uploadSpeed = currentSpeed;
//           });

//         }

//         await Future.delayed(Duration(milliseconds: 10));
//       }

//       final response = await req.close();
//       await response.drain();
//       uploadSuccess = true;

//       stopwatch.stop();
//       final sec = stopwatch.elapsedMilliseconds / 1000.0;
//       final mbps = (uploadBytes.length * 8) / (sec * 1000000);

//       setState(() {
//         _uploadSpeed = mbps;
//         _uploadSuccess = uploadSuccess;
//       });

//       // Start pulse animation on success
//       _pulseController.repeat(reverse: true);

//     } catch (e) {
//       print('Upload error: $e');
//       setState(() {
//         _uploadSuccess = false;
//       });
//     } finally {
//       setState(() {
//         _testingUpload = false;
//         _uploadTested = true;
//       });

//       if (_downloadTested && _uploadTested && _downloadSuccess && _uploadSuccess) {
//         _showSpeedTestNotification();
//       }
//     }
//   }

//   Future<void> _startSequentialTest() async {
//     // Reset speed values and animations
//     setState(() {
//       _downloadSpeed = 0;
//       _uploadSpeed = 0;
//       _downloadTested = false;
//       _uploadTested = false;
//       _downloadSuccess = false;
//       _uploadSuccess = false;
//     });

//     _pulseController.stop();

//     // First run download test
//     await _testDownload();

//     // Wait a moment, then run upload test
//     await Future.delayed(Duration(seconds: 2));
//     await _testUpload();
//   }

//   Uint8List _generateTestData(int byteCount) {
//     final rand = Random();
//     return Uint8List.fromList(List<int>.generate(byteCount, (_) => rand.nextInt(256)));
//   }

//   Future<bool> _isNetworkAvailable() async {
//     final connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       return false;
//     }

//     try {
//       final result = await InternetAddress.lookup('example.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         return true;
//       }
//     } catch (_) {
//       return false;
//     }

//     return false;
//   }

//   void _showNoInternetDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         backgroundColor: Theme.of(context).cardColor,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.wifi_off, size: 60, color: Colors.redAccent),
//               const SizedBox(height: 16),
//               Text(
//                 "No Internet Connection",
//                 style: GoogleFonts.poppins(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 "Please check your network settings and try again.",
//                 style: GoogleFonts.poppins(
//                   fontSize: 16,
//                   color: Colors.grey[600],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(Icons.refresh),
//                   label: const Text("Try Again"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMetricsSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.1),
//             Colors.white.withOpacity(0.05),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Flexible(
//             flex: 1,
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(minWidth: 100),
//               child: _buildMetricCard(
//                 icon: Icons.swap_horiz,
//                 label: 'Latency',
//                 value: _pingResult == 'Loading...' ? '...' : '${_pingResult}ms',
//                 color: Colors.orange,
//                 isLoading: _pingResult == 'Loading...',
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Flexible(
//             flex: 1,
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(minWidth: 100),
//               child: _buildMetricCard(
//                 icon: Icons.download,
//                 label: 'Download Speed',
//                 value: _downloadSpeed > 0 ? '${_downloadSpeed.toStringAsFixed(2)} Mbps' : 'Waiting',
//                 color: Colors.green,
//                 isLoading: _testingDownload,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Flexible(
//             flex: 1,
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(minWidth: 100),
//               child: _buildMetricCard(
//                 icon: Icons.upload,
//                 label: 'Upload Speed',
//                 value: _uploadSpeed > 0 ? '${_uploadSpeed.toStringAsFixed(2)} Mbps' : 'Waiting',
//                 color: Colors.blue,
//                 isLoading: _testingUpload,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//     required bool isLoading,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             isLoading ? '...' : value,
//             style: GoogleFonts.poppins(
//               color: isLoading ? Colors.grey : color,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMainSpeedGauge() {
//     double mainSpeed = _testingUpload ? _uploadSpeed : _downloadSpeed;
//     double displayValue = mainSpeed.clamp(0, 1000);

//     Color getSpeedColor(double speed) {
//       if (speed < 10) return Colors.red;
//       if (speed < 25) return Colors.orange;
//       if (speed < 50) return Colors.yellow;
//       if (speed < 100) return Colors.green;
//       if (speed < 500) return Colors.blue;
//       return Colors.purple;
//     }

//     Color speedColor = getSpeedColor(displayValue);

//     return Container(
//       padding: const EdgeInsets.all(32),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.white.withOpacity(0.15),
//             Colors.white.withOpacity(0.05),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(32),
//         border: Border.all(
//           color: speedColor.withOpacity(0.3),
//           width: 3,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: speedColor.withOpacity(0.2),
//             blurRadius: 20,
//             spreadRadius: 5,
//           ),
//           BoxShadow(
//             color: Colors.black.withOpacity(0.3),
//             blurRadius: 15,
//             spreadRadius: 2,
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const SizedBox(height: 24),

//           // Speedometer Container
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(32),
//             ),
//             child: SizedBox(
//               height: 250,
//               width: 400,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Speedometer Background
//                   Container(
//                     width: 300,
//                     height: 150,
//                     decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(150),
//                         topRight: Radius.circular(150),
//                       ),
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.grey[800]!,
//                           Colors.grey[900]!,
//                         ],
//                       ),
//                       border: Border.all(
//                         color: Colors.grey[600]!,
//                         width: 3,
//                       ),
//                     ),
//                   ),

//                   // Speedometer Face with markings
//                   Positioned(
//                     top: 10,
//                     child: Container(
//                       width: 280,
//                       height: 140,
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(140),
//                           topRight: Radius.circular(140),
//                         ),
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.grey[200]!,
//                             Colors.grey[300]!,
//                           ],
//                         ),
//                       ),
//                       child: CustomPaint(
//                         painter: SpeedometerPainter(
//                           currentSpeed: mainSpeed.clamp(0, 100),
//                           speedColor: speedColor,
//                         ),
//                       ),
//                     ),
//                   ),





//                   // Speed Value Display
//                   Positioned(
//                     bottom: 60,
//                     child: AnimatedBuilder(
//                       animation: _pulseAnimation,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: _pulseAnimation.value,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: speedColor.withOpacity(0.5),
//                                 width: 2,
//                               ),
//                             ),
//                             child: Text(
//                               '${mainSpeed.toStringAsFixed(2)}',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 32,
//                                 fontWeight: FontWeight.bold,
//                                 color: speedColor,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.black,
//                                     blurRadius: 2,
//                                     offset: const Offset(1, 1),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   // Unit Label
//                   Positioned(
//                     bottom: 30,
//                     child: Text(
//                       'Mbps',
//                       style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey[300],
//                         shadows: [
//                           Shadow(
//                             color: Colors.black,
//                             blurRadius: 1,
//                             offset: const Offset(1, 1),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Speed indicator bar
//           Container(
//             height: 12,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               color: Colors.white.withOpacity(0.1),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.2),
//                 width: 1,
//               ),
//             ),
//             child: FractionallySizedBox(
//               alignment: Alignment.centerLeft,
//               widthFactor: (mainSpeed / 100).clamp(0.0, 1.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(6),
//                   gradient: LinearGradient(
//                     colors: [
//                       speedColor,
//                       speedColor.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getSpeedCategory(double speed) {
//     if (speed < 10) return 'Very Slow';
//     if (speed < 25) return 'Slow';
//     if (speed < 50) return 'Moderate';
//     if (speed < 100) return 'Fast';
//     if (speed < 500) return 'Very Fast';
//     return 'Ultra Fast';
//   }



//   Widget _buildStartButton() {
//     final isAnyTestRunning = _testingDownload || _testingUpload;

//     return Container(
//       width: double.infinity,
//       height: 60,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isAnyTestRunning
//               ? [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)]
//               : [Colors.green.withOpacity(0.8), Colors.green.withOpacity(0.6)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.3),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: isAnyTestRunning ? null : _startSequentialTest,
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (isAnyTestRunning)
//                   const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     ),
//                   )
//                 else
//                   const Icon(Icons.speed, color: Colors.white, size: 24),
//                 const SizedBox(width: 12),
//                 Text(
//                   isAnyTestRunning ? 'TESTING...' : 'START SPEED TEST',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.2,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildConnectionDetails() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.white.withOpacity(0.1),
//             Colors.white.withOpacity(0.05),
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.2),
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: _buildConnectionCard(
//               icon: Icons.business,
//               label: 'Service',
//               value: _wifiProvider.isNotEmpty ? _wifiProvider : 'Unknown',
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: _buildConnectionCard(
//               icon: Icons.language,
//               label: 'Server',
//               value: _wifiIP.isNotEmpty ? _wifiIP : 'Local',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildConnectionCard({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.1),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: GoogleFonts.poppins(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       drawer: SafeArea(
//         bottom: true,
//         child: Drawer(
//           backgroundColor: const Color(0xFF1A1A2E),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               DrawerHeader(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF3EADCF), Color(0xFFABE9CD)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     const Icon(Icons.speed, size: 48, color: Colors.white),
//                     const SizedBox(height: 10),
//                     Text(
//                       "NetMeter",
//                       style: GoogleFonts.poppins(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.home, color: Colors.white),
//                 title: Text("Home", style: GoogleFonts.poppins(color: Colors.white)),
//                 onTap: () => Navigator.pop(context),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.wifi, color: Colors.white),
//                 title: Text("Ping Test", style: GoogleFonts.poppins(color: Colors.white)),
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PingCheckerPage())),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.router, color: Colors.white),
//                 title: Text("Network Info", style: GoogleFonts.poppins(color: Colors.white)),
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NetworkInfoScreen())),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.network_check, color: Colors.white),
//                 title: Text("Network Evaluation", style: GoogleFonts.poppins(color: Colors.white)),
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NetworkEvaluationScreen(downloadSpeed: _downloadSpeed, uploadSpeed: _uploadSpeed))),
//               ),
//               ListTile(
//                 leading: const Icon(Icons.history, color: Colors.white),
//                 title: Text("Usage History", style: GoogleFonts.poppins(color: Colors.white)),
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyUsageScreen())),
//               ),
//               const Spacer(),
//               ListTile(
//                 leading: const Icon(Icons.info_outline, color: Colors.white),
//                 title: Text("About", style: GoogleFonts.poppins(color: Colors.white)),
//                 onTap: () {
//                   showAboutDialog(
//                     context: context,
//                     applicationName: "NetMeter",
//                     applicationVersion: "1.0.0",
//                     applicationLegalese: "© 2025 Harsh Khant",
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.exit_to_app, color: Colors.white),
//                 title: Text("Exit", style: GoogleFonts.poppins(color: Colors.white)),
//                 onTap: () => exit(0),
//               ),
//             ],
//           ),
//         ),
//       ),
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 8,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Builder(
//                     builder: (context) => Row(
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.menu, color: Colors.white),
//                           onPressed: () => Scaffold.of(context).openDrawer(),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'NetMeter',
//                           style: GoogleFonts.poppins(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             letterSpacing: 1.2,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Icon(Icons.light_mode, color: Colors.white),
//                       Switch(
//                         value: widget.isDarkMode,
//                         onChanged: (_) => widget.onToggleTheme(),
//                         activeColor: Colors.white,
//                       ),
//                       const Icon(Icons.dark_mode, color: Colors.white),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
//             child: Column(
//               children: [
//                 // Metrics Section
//                 _buildMetricsSection(),
//                 const SizedBox(height: 30),

//                 // Main Speed Gauge
//                 _buildMainSpeedGauge(),
//                 const SizedBox(height: 30),

//                 // Start Button
//                 _buildStartButton(),
//                 const SizedBox(height: 30),

//                 // Connection Details
//                 _buildConnectionDetails(),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Custom Painter for Speedometer markings
// class SpeedometerPainter extends CustomPainter {
//   final double currentSpeed;
//   final Color speedColor;

//   SpeedometerPainter({
//     required this.currentSpeed,
//     required this.speedColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height);
//     final radius = size.width / 2;

//     _drawSpeedMarkings(canvas, center, radius);
//     _drawSpeedZones(canvas, center, radius);
//   }

//   void _drawSpeedMarkings(Canvas canvas, Offset center, double radius) {
//     const double startAngle = -135 * (3.14159 / 180); // 100 speed position (bottom)
//     const double endAngle = 135 * (3.14159 / 180);    // 0 speed position (top)
//     const double angleRange = endAngle - startAngle;

//     // Draw major ticks (0, 20, 40, 60, 80, 100) and minor ticks (0 at top 90°, 100 at bottom -90°)
//     for (int i = 0; i <= 10; i++) {
//       double angle = endAngle - (i / 10) * angleRange;
//       double tickLength = i % 2 == 0 ? 15 : 8; // Major ticks are longer

//       Offset startPoint = Offset(
//         center.dx + (radius - tickLength) * cos(angle),
//         center.dy - (radius - tickLength) * sin(angle),
//       );
//       Offset endPoint = Offset(
//         center.dx + radius * cos(angle),
//         center.dy - radius * sin(angle),
//       );

//       final paint = Paint()
//         ..color = Colors.black
//         ..strokeWidth = i % 2 == 0 ? 3 : 1.5
//         ..style = PaintingStyle.stroke;

//       canvas.drawLine(startPoint, endPoint, paint);

//       // Draw speed labels for major ticks (REVERSED: 0 now shows as 100, 100 now shows as 0)
//       if (i % 2 == 0) {
//         double speed = 100 - (i / 10) * 100; // Reverse the speed values
//         Offset textOffset = Offset(
//           center.dx + (radius - 35) * cos(angle),
//           center.dy - (radius - 35) * sin(angle),
//         );

//         final textPainter = TextPainter(
//           text: TextSpan(
//             text: speed.toInt().toString(),
//             style: const TextStyle(
//               color: Colors.black,
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           textDirection: TextDirection.ltr,
//         );
//         textPainter.layout();
//         textPainter.paint(
//           canvas,
//           Offset(
//             textOffset.dx - textPainter.width / 2,
//             textOffset.dy - textPainter.height / 2,
//           ),
//         );
//       }
//     }
//   }

//   void _drawSpeedZones(Canvas canvas, Offset center, double radius) {
//     const double startAngle = -135 * (3.14159 / 180); // 100 speed position (bottom)
//     const double endAngle = 135* (3.14159 / 180);    // 0 speed position (top)
//     const double angleRange = endAngle - startAngle;

//     final zones = [
//       {'start': 0.0, 'end': 20.0, 'color': Colors.red},
//       {'start': 20.0, 'end': 40.0, 'color': Colors.orange},
//       {'start': 40.0, 'end': 60.0, 'color': Colors.yellow},
//       {'start': 60.0, 'end': 80.0, 'color': Colors.green},
//       {'start': 80.0, 'end': 100.0, 'color': Colors.blue},
//     ];

//     for (var zone in zones) {
//       double startAngleZone = endAngle - ((zone['start'] as double) / 100) * angleRange;
//       double endAngleZone = endAngle - ((zone['end'] as double) / 100) * angleRange;

//       final paint = Paint()
//         ..color = (zone['color'] as Color).withOpacity(0.2)
//         ..style = PaintingStyle.fill;

//       final rect = Rect.fromCircle(center: center, radius: radius - 15);
//       canvas.drawArc(rect, startAngleZone, endAngleZone - startAngleZone, false, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
