
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NetworkEvaluationScreen extends StatelessWidget {
  final double downloadSpeed;
  final double uploadSpeed;

  const NetworkEvaluationScreen({
    super.key,
    required this.downloadSpeed,
    required this.uploadSpeed,
  });

  String _evaluateGaming() {
    if (downloadSpeed >= 6 && uploadSpeed >= 1.5) {
      return "✅ Good for Gaming";
    } else {
      return "❌ Lag Risk in Gaming";
    }
  }

  String _evaluateStreaming() {
    if (downloadSpeed >= 8 && uploadSpeed >= 5) {
      return "✅ HD Live Streaming Possible";
    } else if (downloadSpeed >= 4 && uploadSpeed >= 2) {
      return "🟡 Only 480p–720p Streaming";
    } else {
      return "❌ Poor Streaming Quality";
    }
  }

  String _evaluateVideoCalls() {
    if (downloadSpeed >= 2 && uploadSpeed >= 2) {
      return "✅ Stable for HD Video Calls";
    } else if (downloadSpeed >= 1 && uploadSpeed >= 1) {
      return "🟡 May Lag Sometimes";
    } else {
      return "❌ Not Good for Video Calls";
    }
  }

  Color _getSpeedColor(double speed) {
    if (speed < 10) return Colors.red;
    if (speed < 25) return Colors.orange;
    if (speed < 50) return Colors.yellow;
    if (speed < 100) return Colors.green;
    if (speed < 500) return Colors.blue;
    return Colors.purple;
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
                  Expanded(
                    child: Text(
                      'Network Performance',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCardContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
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
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(5, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          
          // Header
          Text(
            "Network Performance Analysis",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            "Based on your speed test results",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 30),
          
          // Speed Indicators
          Row(
            children: [
              Expanded(
                child: _buildSpeedIndicator(context, "Download", downloadSpeed, _getSpeedColor(downloadSpeed)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildSpeedIndicator(context, "Upload", uploadSpeed, _getSpeedColor(uploadSpeed)),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Evaluation Results
          Text(
            "Performance Evaluation",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildEvaluationRow("🎮 Gaming", _evaluateGaming()),
          _buildEvaluationRow("📺 Streaming", _evaluateStreaming()),
          _buildEvaluationRow("📞 Video Calls", _evaluateVideoCalls()),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSpeedIndicator(
      BuildContext context, String title, double speed, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            percent: (speed / 100).clamp(0.0, 1.0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${speed.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Mbps",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            progressColor: color,
            backgroundColor: Colors.white.withOpacity(0.2),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 1000,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationRow(String title, String result) {
    Color resultColor = Colors.white;
    if (result.contains("✅")) {
      resultColor = Colors.green;
    } else if (result.contains("🟡")) {
      resultColor = Colors.orange;
    } else if (result.contains("❌")) {
      resultColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            resultColor.withOpacity(0.1),
            resultColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: resultColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconForTitle(title),
              color: resultColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: resultColor,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case "🎮 Gaming":
        return Icons.sports_esports;
      case "📺 Streaming":
        return Icons.live_tv;
      case "📞 Video Calls":
        return Icons.video_call;
      default:
        return Icons.info;
    }
  }
}
