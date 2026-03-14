import 'dart:math' as math;
import 'view/speed_test_view.dart';
import 'utils/import_export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetMeter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3EADCF),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );

//     _scaleAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOutBack,
//     );

//     _controller.forward();

//     // Navigate to home screen after delay
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const SpeedTestView()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo Image
//               Container(
//                 padding: const EdgeInsets.all(30),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blueAccent.withOpacity(0.3),
//                       blurRadius: 15,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Image.asset(
//                   'assets/speed_test_logo.jpg',
//                   height: 80,
//                   width: 80,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Subtitle
//               Text(
//                 "Checking your connection…",
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _waveController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Pulse animation controller
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Rotate animation controller
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Wave animation controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    // Scale animation with professional easing
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeInOut),
      ),
    );

    // Slide animation
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Pulse animation
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotateController);

    // Start animations
    _mainController.forward();

    // Navigate to home screen after delay
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SpeedTestView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _pulseController,
          _rotateController,
          _waveController,
        ]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Background network patterns
                ...List.generate(8, (index) => _buildNetworkPattern(index)),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container matching the main app design
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.15),
                                        Colors.white.withOpacity(0.08),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Rotating outer ring
                                      AnimatedBuilder(
                                        animation: _rotationAnimation,
                                        builder: (context, child) {
                                          return Transform.rotate(
                                            angle:
                                                _rotationAnimation.value *
                                                2 *
                                                math.pi,
                                            child: Container(
                                              width: 140,
                                              height: 140,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.blue
                                                      .withOpacity(0.4),
                                                  width: 3,
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 5,
                                                    left: 65,
                                                    child: Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.green
                                                                .withOpacity(
                                                                  0.6,
                                                                ),
                                                            blurRadius: 8,
                                                            spreadRadius: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                      // Central logo
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue.withOpacity(0.3),
                                              Colors.green.withOpacity(0.2),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.4,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.speed,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      // App title matching the main app
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Column(
                            children: [
                              Text(
                                'NetMeter',
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Professional loading indicator
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
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
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _waveController,
                                      builder: (context, child) {
                                        return Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green.withOpacity(
                                              0.5 +
                                                  (math.sin(
                                                        _waveController.value *
                                                            2 *
                                                            math.pi,
                                                      ) *
                                                      0.5),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green.withOpacity(
                                                  0.6,
                                                ),
                                                blurRadius: 6,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Initializing Network Engine',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              // Progress indicator bar
                              Container(
                                width: 200,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: AnimatedBuilder(
                                  animation: _mainController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 200 * _mainController.value,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        gradient: const LinearGradient(
                                          colors: [Colors.blue, Colors.green],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Corner network indicators matching the main app style
                Positioned(
                  top: 80,
                  left: 30,
                  child: _buildNetworkIndicator(0, Icons.wifi),
                ),
                Positioned(
                  top: 80,
                  right: 30,
                  child: _buildNetworkIndicator(1, Icons.signal_cellular_4_bar),
                ),
                Positioned(
                  bottom: 150,
                  left: 30,
                  child: _buildNetworkIndicator(2, Icons.router),
                ),
                Positioned(
                  bottom: 150,
                  right: 30,
                  child: _buildNetworkIndicator(3, Icons.network_check),
                ),

                // ...existing code...

                // Bottom logos for Darshan University and ASWDC with background container
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/du_white.png',
                            height: 66,
                            width: 166,
                            fit: BoxFit.contain,
                            color: Colors.white,
                            colorBlendMode: BlendMode.modulate,
                          ),
                          const SizedBox(width: 24),
                          Image.asset(
                            'assets/aswdc_white.png',
                            height: 66,
                            fit: BoxFit.contain,
                            color: Colors.white,
                            colorBlendMode: BlendMode.modulate,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNetworkPattern(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final initialX = random.nextDouble() * MediaQuery.of(context).size.width;
    final initialY = random.nextDouble() * MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        final progress = (_waveController.value + (index * 0.15)) % 1.0;
        final x = initialX + math.sin(progress * 2 * math.pi + index) * 20;
        final y = initialY + math.cos(progress * 2 * math.pi + index) * 15;
        final opacity = 0.3 * (1 - progress);

        return Positioned(
          left: x,
          top: y,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(opacity),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(opacity * 0.5),
                  blurRadius: size * 2,
                  spreadRadius: size,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNetworkIndicator(int index, IconData icon) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulseValue =
              math.sin((_pulseController.value * 2 * math.pi) + (index * 0.5)) *
                  0.1 +
              1.0;
          return Transform.scale(
            scale: pulseValue,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: [
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                ][index].withOpacity(0.8),
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
