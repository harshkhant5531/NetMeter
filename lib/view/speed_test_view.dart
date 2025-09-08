import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/speed_test_controller.dart';
import '../model/speed_test_model.dart';
import '../utils/ui_helpers.dart';
import 'about_us.dart';
import 'feedback_screen.dart';
import 'ping.dart';
import 'network_information.dart';
import 'network_evaluation.dart';
import 'daily_usage.dart';
import 'ip_to_location.dart';

class SpeedTestView extends StatefulWidget {
  const SpeedTestView({super.key});

  @override
  State<SpeedTestView> createState() => _SpeedTestViewState();
}

class _SpeedTestViewState extends State<SpeedTestView>
    with TickerProviderStateMixin {
  late SpeedTestController _controller;
  late AnimationController _pulseController;
  late AnimationController _buttonController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _buttonScale;

  // Speed history tracking
  final List<double> _downloadSpeedHistory = [];
  final List<double> _uploadSpeedHistory = [];
  final int _maxHistoryPoints = 20;

  @override
  void initState() {
    super.initState();
    _controller = SpeedTestController();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    // Listen to speed changes and track history
    _controller.modelStream.listen((model) {
      final currentSpeed = model.isTestingUpload
          ? model.uploadSpeed
          : model.downloadSpeed;
      if (currentSpeed > 0) {
        // Track speed history
        if (model.isTestingDownload) {
          _addToHistory(_downloadSpeedHistory, currentSpeed);
        } else if (model.isTestingUpload) {
          _addToHistory(_uploadSpeedHistory, currentSpeed);
        }
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      await _controller.initialize();
      setState(() {});
    } catch (e) {
      _showErrorDialog('Initialization Error', e.toString());
    }
  }

  void _addToHistory(List<double> history, double speed) {
    history.add(speed);
    if (history.length > _maxHistoryPoints) {
      history.removeAt(0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: GoogleFonts.poppins(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Future<void> _startSpeedTest() async {
    _buttonController.forward().then((_) => _buttonController.reverse());

    try {
      // Clear speed history for new test
      _downloadSpeedHistory.clear();
      _uploadSpeedHistory.clear();
      setState(() {});

      // Start pulse animation
      _pulseController.repeat();

      await _controller.startSequentialTest();

      // Stop pulse animation when test is complete
      _pulseController.stop();
    } catch (e) {
      _pulseController.stop();
      _showErrorDialog('Speed Test Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBody(),
          // Floating speed indicator
          _buildFloatingSpeedIndicator(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) => Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'NetMeter',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F0F23),
                const Color(0xFF1E1E3F),
                const Color(0xFF2D2D5F),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Column(
            children: [
              // Modern Header with New Theme
              Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1E3A8A).withOpacity(0.95),
                      const Color(0xFF3B82F6).withOpacity(0.9),
                      const Color(0xFF06B6D4).withOpacity(0.85),
                      const Color(0xFF10B981).withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Floating Geometric Shapes
                    Positioned(
                      top: 30,
                      left: 20,
                      child: Transform.rotate(
                        angle: 0.3,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      right: 25,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 35,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    // Main Content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Modern App Icon
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/speed_test_logo.jpg',
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: -3,
                                    top: -3,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(
                                              0.5,
                                            ),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // App Name with Modern Typography
                            Text(
                              "NetMeter",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.8,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Status Indicator with Animation
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.6),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Ready to Test",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Modern Menu Items
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    children: [
                      _buildModernDrawerItem(
                        icon: Icons.dashboard_rounded,
                        title: "Dashboard",
                        subtitle: "Main Control Center",
                        onTap: () => Navigator.pop(context),
                        isActive: true,
                        color: const Color(0xFF6366F1),
                      ),
                      const SizedBox(height: 8),
                      // _buildModernDrawerItem(
                      //   icon: Icons.radar_rounded,
                      //   title: " Ping Test",
                      //   subtitle: "Network Latency Analysis",
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const PingCheckerPage(),
                      //     ),
                      //   ),
                      //   color: const Color(0xFFEC4899),
                      // ),
                      const SizedBox(height: 8),
                      _buildModernDrawerItem(
                        icon: Icons.router_rounded,
                        title: "Network Info",
                        subtitle: "Connection Details",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NetworkInfoScreen(),
                          ),
                        ),
                        color: const Color(0xFF10B981),
                      ),

                      const SizedBox(height: 8),
                      _buildModernDrawerItem(
                        icon: Icons.analytics_rounded,
                        title: "Network Evaluation",
                        subtitle: "Performance Metrics",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NetworkEvaluationScreen(
                              downloadSpeed: _controller.model.downloadSpeed,
                              uploadSpeed: _controller.model.uploadSpeed,
                            ),
                          ),
                        ),
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(height: 8),
                      _buildModernDrawerItem(
                        icon: Icons.location_on_rounded,
                        title: "IP Location",
                        subtitle: "Geographic Details",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationInfoScreen(),
                          ),
                        ),
                        color: const Color(0xFF06B6D4),
                      ),
                      const SizedBox(height: 8),
                      _buildModernDrawerItem(
                        icon: Icons.timeline_rounded,
                        title: "Usage History",
                        subtitle: "Test Records",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DailyUsageScreen(),
                          ),
                        ),
                        color: const Color(0xFF8B5CF6),
                      ),
                      _buildModernDrawerItem(
                        icon: Icons.feedback,
                        title: "Feedback",
                        subtitle: "Share your feedback",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  FeedbackScreen(),
                          ),
                        ),
                        color: const Color(0xFF06B6D4),
                      ),
                      const SizedBox(height: 8),
                      _buildModernDrawerItem(
                        icon: Icons.location_on_rounded,
                        title: "About Us",
                        subtitle: "Information of Devloper",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  AboutUs(),
                          ),
                        ),
                        color: const Color(0xFF06B6D4),
                      ),
                    ],
                  ),
                ),
              ),

              // Modern Bottom Section
              Container(
                height: 80,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Expanded(
                    //   child: _buildModernDrawerItem(
                    //     icon: Icons.info_rounded,
                    //     title: "About App",
                    //     subtitle: null,
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //       showAboutDialog(
                    //         context: context,
                    //         applicationName: "NetMeter",
                    //         applicationVersion: "1.0.0",
                    //         applicationLegalese: "© 2025 Harsh Khant",
                    //       );
                    //     },
                    //     color: const Color(0xFF6B7280),
                    //   ),
                    // ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildModernDrawerItem(
                        icon: Icons.power_settings_new_rounded,
                        title: "Exit App",
                        subtitle: null,
                        onTap: () => SystemNavigator.pop(),
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernDrawerItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isActive = false,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: !isActive ? Colors.white.withOpacity(0.02) : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? color.withOpacity(0.4)
              : Colors.white.withOpacity(0.06),
          width: isActive ? 1.5 : 0.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                // Modern Icon Container
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              color.withOpacity(0.4),
                              color.withOpacity(0.2),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.03),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive
                          ? color.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ),

                const SizedBox(width: 8),

                // Text Content
                Expanded(
                  child: subtitle == null
                      ? Row(
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: GoogleFonts.poppins(
                                  color: isActive
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.white.withOpacity(0.5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ],
                          ],
                        ),
                ),

                // Modern Arrow Indicator - Only show for items with subtitles
                if (subtitle != null)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isActive
                          ? color.withOpacity(0.2)
                          : Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? color.withOpacity(0.3)
                            : Colors.white.withOpacity(0.08),
                        width: 0.5,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      size: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Metrics Cards
              _buildMetricsSection(),

              const SizedBox(height: 30),

              // Live Speed Meters
              _buildLiveSpeedMeters(),

              const SizedBox(height: 30),

              // Speed Gauge
              _buildSpeedGauge(),

              const SizedBox(height: 30),

              // Start Button
              _buildStartButton(),

              const SizedBox(height: 30),

              // Connection Info
              _buildConnectionInfo(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsSection() {
    return StreamBuilder<SpeedTestModel>(
      stream: _controller.modelStream,
      builder: (context, snapshot) {
        final model = snapshot.data ?? _controller.model;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMetricCard(
                icon: Icons.swap_horiz,
                label: 'Jitter',
                value:
                    model.pingResult == 'Loading...' ||
                        model.pingResult == 'Testing...'
                    ? '...'
                    : model.pingResult == 'Failed'
                    ? 'Failed'
                    : model.pingResult.isNotEmpty &&
                          model.pingResult != 'Loading...'
                    ? '${model.jitter.toStringAsFixed(1)}ms'
                    : '...',
                color: Colors.orange,
                isLoading:
                    model.pingResult == 'Loading...' ||
                    model.pingResult == 'Testing...',
              ),
              const SizedBox(height: 16),
              _buildMetricCard(
                icon: Icons.download,
                label: 'Download Speed',
                value: model.downloadSpeed > 0
                    ? '${model.downloadSpeed.toStringAsFixed(2)} Mbps'
                    : 'Waiting',
                color: Colors.green,
                isLoading: model.isTestingDownload,
              ),
              const SizedBox(height: 16),
              _buildMetricCard(
                icon: Icons.upload,
                label: 'Upload Speed',
                value: model.uploadSpeed > 0
                    ? '${model.uploadSpeed.toStringAsFixed(2)} Mbps'
                    : 'Waiting',
                color: Colors.blue,
                isLoading: model.isTestingUpload,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLoading ? '...' : value,
                  style: GoogleFonts.poppins(
                    color: isLoading ? Colors.grey : color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveSpeedMeters() {
    return StreamBuilder<SpeedTestModel>(
      stream: _controller.modelStream,
      builder: (context, snapshot) {
        final model = snapshot.data ?? _controller.model;

        // Calculate min and max speeds
        final downloadMin = _downloadSpeedHistory.isNotEmpty
            ? _downloadSpeedHistory.reduce((a, b) => a < b ? a : b)
            : 0.0;
        final downloadMax = _downloadSpeedHistory.isNotEmpty
            ? _downloadSpeedHistory.reduce((a, b) => a > b ? a : b)
            : 0.0;
        final uploadMin = _uploadSpeedHistory.isNotEmpty
            ? _uploadSpeedHistory.reduce((a, b) => a < b ? a : b)
            : 0.0;
        final uploadMax = _uploadSpeedHistory.isNotEmpty
            ? _uploadSpeedHistory.reduce((a, b) => a > b ? a : b)
            : 0.0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Live Speed Meters',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        UIHelpers.buildSpeedMeter(
                          speed: model.downloadSpeed,
                          maxSpeed: 100.0,
                          color: Colors.green,
                          isActive: model.isTestingDownload,
                          size: 120,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Download',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        UIHelpers.buildSpeedMeter(
                          speed: model.uploadSpeed,
                          maxSpeed: 100.0,
                          color: Colors.blue,
                          isActive: model.isTestingUpload,
                          size: 120,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Min/Max Speed Display Boxes
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.2),
                            Colors.green.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Download',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'MIN',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${downloadMin.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.green.withOpacity(0.3),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'MAX',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${downloadMax.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.2),
                            Colors.blue.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Upload',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'MIN',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${uploadMin.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.blue.withOpacity(0.3),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'MAX',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue.withOpacity(0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${uploadMax.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeedGauge() {
    return StreamBuilder<SpeedTestModel>(
      stream: _controller.modelStream,
      builder: (context, snapshot) {
        final model = snapshot.data ?? _controller.model;
        final mainSpeed = model.isTestingUpload
            ? model.uploadSpeed
            : model.downloadSpeed;
        final speedColor = _getSpeedColor(mainSpeed);
        final isActive = model.isTestingDownload || model.isTestingUpload;
        final maxSpeed = 100.0; // Adjust based on your needs

        return Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: speedColor.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: speedColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Speed Meter
              UIHelpers.buildAdvancedSpeedMeter(
                speed: mainSpeed,
                maxSpeed: maxSpeed,
                color: speedColor,
                isActive: isActive,
                size: 220,
              ),

              const SizedBox(height: 20),

              // Speed Category
              Text(
                _getSpeedCategory(mainSpeed),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: speedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              // Test Status
              if (isActive)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: speedColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      model.isTestingDownload
                          ? 'Testing Download...'
                          : 'Testing Upload...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: speedColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStartButton() {
    return StreamBuilder<SpeedTestModel>(
      stream: _controller.modelStream,
      builder: (context, snapshot) {
        final model = snapshot.data ?? _controller.model;

        return AnimatedBuilder(
          animation: _buttonScale,
          builder: (context, child) {
            return Transform.scale(
              scale: _buttonScale.value,
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: model.isAnyTestRunning
                        ? [
                            Colors.grey.withOpacity(0.3),
                            Colors.grey.withOpacity(0.2),
                          ]
                        : [
                            Colors.green.withOpacity(0.8),
                            Colors.green.withOpacity(0.6),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: model.isAnyTestRunning ? null : _startSpeedTest,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (model.isAnyTestRunning)
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          else
                            const Icon(
                              Icons.speed,
                              color: Colors.white,
                              size: 28,
                            ),
                          const SizedBox(width: 16),
                          Text(
                            model.isAnyTestRunning
                                ? 'TESTING...'
                                : 'START SPEED TEST',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingSpeedIndicator() {
    return StreamBuilder<SpeedTestModel>(
      stream: _controller.modelStream,
      builder: (context, snapshot) {
        final model = snapshot.data ?? _controller.model;
        final isActive = model.isTestingDownload || model.isTestingUpload;

        if (!isActive) return const SizedBox.shrink();

        final currentSpeed = model.isTestingUpload
            ? model.uploadSpeed
            : model.downloadSpeed;
        final speedColor = _getSpeedColor(currentSpeed);

        return Positioned(
          top: 120,
          right: 20,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        speedColor.withOpacity(0.9),
                        speedColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: speedColor.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${currentSpeed.toStringAsFixed(2)} Mbps',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildConnectionInfo() {
    return StreamBuilder<SpeedTestModel>(
      stream: _controller.modelStream,
      builder: (context, snapshot) {
        final model = snapshot.data ?? _controller.model;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Connection Info',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () async {
                        // Temporarily set IP to updating for immediate feedback
                        _controller.model.setNetworkInfo(
                          'Updating...',
                          _controller.model.wifiProvider,
                        );
                        _controller.notifyModelUpdate();
                        // Then refresh the actual network info
                        await _controller.refreshNetworkInfo();
                      },
                      tooltip: 'Refresh IP Address',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildConnectionCard(
                icon: Icons.business,
                label: 'Service Provider',
                value: model.wifiProvider == 'Loading...'
                    ? 'Fetching...'
                    : (model.wifiProvider.isNotEmpty
                          ? model.wifiProvider
                          : 'Unknown'),
                isLoading: model.wifiProvider == 'Loading...',
              ),
              const SizedBox(height: 16),
              _buildConnectionCard(
                icon: Icons.language,
                label: 'IP Address',
                value:
                    model.wifiIP == 'Loading...' ||
                        model.wifiIP == 'Unavailable' ||
                        model.wifiIP.isEmpty
                    ? 'Fetching...'
                    : model.wifiIP,
                isLoading:
                    model.wifiIP == 'Loading...' ||
                    model.wifiIP == 'Unavailable' ||
                    model.wifiIP == 'Updating...',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionCard({
    required IconData icon,
    required String label,
    required String value,
    bool isLoading = false,
  }) {
    // Different colors for different cards - more subtle
    final isServiceProvider = label == 'Service Provider';
    final cardColor = isServiceProvider
        ? Colors
              .blue // Purple for Service Provider
        : Colors.blue; // Light gray for IP Address

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardColor.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cardColor.withOpacity(0.4),
                  cardColor.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cardColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                isLoading
                    ? Row(
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Updating...',
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        value,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSpeedColor(double speed) {
    if (speed < 10) return Colors.red;
    if (speed < 25) return Colors.orange;
    if (speed < 50) return Colors.yellow;
    if (speed < 100) return Colors.green;
    if (speed < 500) return Colors.blue;
    return Colors.purple;
  }

  String _getSpeedCategory(double speed) {
    if (speed < 10) return 'Very Slow';
    if (speed < 25) return 'Slow';
    if (speed < 50) return 'Moderate';
    if (speed < 100) return 'Fast';
    if (speed < 500) return 'Very Fast';
    return 'Ultra Fast';
  }
}
