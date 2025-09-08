import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PingCheckerPage extends StatefulWidget {
  const PingCheckerPage({super.key});

  @override
  State<PingCheckerPage> createState() => _PingCheckerPageState();
}

class _PingCheckerPageState extends State<PingCheckerPage>
    with TickerProviderStateMixin {
  List<Widget> _pingWidgets = [];
  bool isPinging = false;
  String output = '';
  final String target = '8.8.8.8';

  // Animation controller for the ping button
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> startPing() async {
    setState(() {
      isPinging = true;
      _pingWidgets.clear();
    });

    // Try multiple ping targets for better reliability
    final pingTargets = ['8.8.8.8', '1.1.1.1', '208.67.222.222'];
    bool pingSuccessful = false;

    for (final target in pingTargets) {
      if (pingSuccessful) break;

      try {
        // Add a ping attempt indicator
        _pingWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.blue.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wifi, color: Colors.blue, size: 20),
              ),
              title: Text(
                "Testing $target",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "Attempting ping...",
                style: GoogleFonts.poppins(
                  color: Colors.blue[200],
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
        setState(() {});

        final ping = Ping(target, count: 2, timeout: 3000);
        int successfulPings = 0;
        int totalAttempts = 0;

        await for (final PingData data in ping.stream) {
          totalAttempts++;

          if (data.response != null && data.response!.time != null) {
            final pingTime = data.response!.time!.inMilliseconds;
            final ip = data.response!.ip;
            successfulPings++;

            // Replace the testing indicator with success
            if (_pingWidgets.isNotEmpty) {
              _pingWidgets.removeLast();
            }

            _pingWidgets.add(
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.2),
                      Colors.green.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    "Reply from $ip",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    "Time = ${pingTime}ms",
                    style: GoogleFonts.poppins(
                      color: Colors.green[200],
                      fontSize: 14,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "✓",
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );

            pingSuccessful = true;
            break;
          } else if (data.error != null) {
            print('Ping error for $target: ${data.error}');
          }

          setState(() {});
        }

        // If no successful pings from this target, show failure
        if (successfulPings == 0) {
          if (_pingWidgets.isNotEmpty) {
            _pingWidgets.removeLast();
          }

          _pingWidgets.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.2),
                    Colors.red.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.error, color: Colors.red, size: 20),
                ),
                title: Text(
                  "Failed to ping $target",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "No response received",
                  style: GoogleFonts.poppins(
                    color: Colors.red[200],
                    fontSize: 14,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "✗",
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        setState(() {});
      } catch (e) {
        print('Ping failed for $target: $e');

        // Remove testing indicator and add error
        if (_pingWidgets.isNotEmpty) {
          _pingWidgets.removeLast();
        }

        _pingWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.2),
                  Colors.red.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.error, color: Colors.red, size: 20),
              ),
              title: Text(
                "Error pinging $target",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                e.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.red[200],
                  fontSize: 14,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "✗",
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
        setState(() {});
        continue;
      }
    }

    // If all ping targets failed, try HTTP ping as fallback
    if (!pingSuccessful) {
      try {
        // Add HTTP ping attempt indicator
        _pingWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.2),
                  Colors.purple.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.http, color: Colors.purple, size: 20),
              ),
              title: Text(
                "Trying HTTP ping",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "Alternative method...",
                style: GoogleFonts.poppins(
                  color: Colors.purple[200],
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
        setState(() {});

        final stopwatch = Stopwatch()..start();
        final response = await http
            .get(
              Uri.parse('https://www.google.com'),
              headers: {'Connection': 'close'},
            )
            .timeout(Duration(seconds: 10));

        stopwatch.stop();

        if (response.statusCode == 200) {
          final pingTime = stopwatch.elapsedMilliseconds;

          // Remove HTTP ping indicator
          if (_pingWidgets.isNotEmpty) {
            _pingWidgets.removeLast();
          }

          _pingWidgets.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.2),
                    Colors.green.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                title: Text(
                  "HTTP ping successful",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Time = ${pingTime}ms (HTTP method)",
                  style: GoogleFonts.poppins(
                    color: Colors.green[200],
                    fontSize: 14,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "✓",
                    style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
          pingSuccessful = true;
        } else {
          // Remove HTTP ping indicator and show failure
          if (_pingWidgets.isNotEmpty) {
            _pingWidgets.removeLast();
          }

          _pingWidgets.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.withOpacity(0.2),
                    Colors.orange.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                title: Text(
                  "All ping methods failed",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  "Check your internet connection",
                  style: GoogleFonts.poppins(
                    color: Colors.orange[200],
                    fontSize: 14,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "!",
                    style: GoogleFonts.poppins(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      } catch (e) {
        print('HTTP ping failed: $e');

        // Remove HTTP ping indicator and show failure
        if (_pingWidgets.isNotEmpty) {
          _pingWidgets.removeLast();
        }

        _pingWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.2),
                  Colors.orange.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              title: Text(
                "All ping methods failed",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "Check your internet connection",
                style: GoogleFonts.poppins(
                  color: Colors.orange[200],
                  fontSize: 14,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "!",
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    setState(() {
      isPinging = false;
    });
  }

  Widget buildPingButton() {
    return AnimatedBuilder(
      animation: _buttonScale,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScale.value,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPinging
                    ? [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.2),
                      ]
                    : [
                        Colors.deepPurpleAccent.withOpacity(0.8),
                        Colors.deepPurpleAccent.withOpacity(0.6),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: isPinging
                    ? null
                    : () {
                        _buttonController.forward().then((_) {
                          _buttonController.reverse();
                        });
                        startPing();
                      },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isPinging
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.wifi,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isPinging ? "Pinging..." : "Start Ping Test",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
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
  }

  Widget buildPingResultCard() {
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: _pingWidgets.isEmpty
          ? Center(
              child: Text(
                "No results yet.",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
              ),
            )
          : Column(
              children: [
                Text(
                  "Ping Results",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._pingWidgets,
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3EADCF), Color(0xFFABE9CD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ping Test',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Info Card
                Container(
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.wifi,
                        size: 48,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Ping Test",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Test your network jitter by pinging",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Ping Button
                buildPingButton(),

                const SizedBox(height: 30),

                // Results Section
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.25,
                  ),
                  child: isPinging || _pingWidgets.isNotEmpty
                      ? buildPingResultCard()
                      : Center(
                          child: Text(
                            "Press the button to start ping test.",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
