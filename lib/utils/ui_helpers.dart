// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:math';
// import 'constants.dart';

import '../utils/import_export.dart';

class UIHelpers {
  static Widget buildGradientCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Color? borderColor,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isLoading ? '...' : value,
            style: GoogleFonts.poppins(
              color: isLoading ? Colors.grey : color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Widget buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    IconData? icon,
    Color? gradientStart,
    Color? gradientEnd,
    double? width,
    double? height,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLoading
              ? [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)]
              : [gradientStart ?? AppConstants.primaryColor, gradientEnd ?? AppConstants.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
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
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else if (icon != null)
                  Icon(icon, color: Colors.white, size: 24),
                if (!isLoading && icon != null) const SizedBox(width: 12),
                Text(
                  isLoading ? 'LOADING...' : text,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color getSpeedColor(double speed) {
    if (speed < 10) return Colors.red;
    if (speed < 25) return Colors.orange;
    if (speed < 50) return Colors.yellow;
    if (speed < 100) return Colors.green;
    if (speed < 500) return Colors.blue;
    return Colors.purple;
  }

  static String getSpeedCategory(double speed) {
    if (speed < 10) return 'Very Slow';
    if (speed < 25) return 'Slow';
    if (speed < 50) return 'Moderate';
    if (speed < 100) return 'Fast';
    if (speed < 500) return 'Very Fast';
    return 'Ultra Fast';
  }

  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.darkBackground,
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
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: AppConstants.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  static void showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.darkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: AppConstants.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSpeedMeter({
    required double speed,
    required double maxSpeed,
    required Color color,
    required bool isActive,
    double size = 200,
  }) {
    final progress = (speed / maxSpeed).clamp(0.0, 1.0);
    final angle = progress * 270; // 270 degrees for the arc
    
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
            ),
          ),
          
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: SpeedMeterPainter(
              progress: progress,
              color: color,
              isActive: isActive,
            ),
          ),
          
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Speed value
              Text(
                '${speed.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.bold,
                  color: color,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              
              // Unit
              Text(
                'Mbps',
                style: GoogleFonts.poppins(
                  fontSize: size * 0.06,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              // Status indicator
              if (isActive)
                Container(
                  margin: EdgeInsets.only(top: size * 0.02),
                  width: size * 0.08,
                  height: size * 0.08,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          // Speed markers
          ...List.generate(6, (index) {
            final markerAngle = (index * 45) * (3.14159 / 180); // Convert to radians
            final markerRadius = size * 0.45;
            final x = size * 0.5 + markerRadius * cos(markerAngle - 3.14159 / 2);
            final y = size * 0.5 + markerRadius * sin(markerAngle - 3.14159 / 2);
            
            return Positioned(
              left: x - 2,
              top: y - 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            );
          }),
          
          // Speed labels (REVERSED: 0 and maxSpeed are swapped)
          Positioned(
            bottom: size * 0.15,
            child: Text(
              '${maxSpeed.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: size * 0.04,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          Positioned(
            right: size * 0.15,
            top: size * 0.5 - size * 0.04,
            child: Text(
              '${(maxSpeed / 2).toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: size * 0.04,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          Positioned(
            top: size * 0.15,
            child: Text(
              '0',
              style: GoogleFonts.poppins(
                fontSize: size * 0.04,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildAdvancedSpeedMeter({
    required double speed,
    required double maxSpeed,
    required Color color,
    required bool isActive,
    double size = 200,
  }) {
    final progress = (speed / maxSpeed).clamp(0.0, 1.0);
    final angle = progress * 270; // 270 degrees for the arc
    
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
            ),
          ),
          
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: SpeedMeterPainter(
              progress: progress,
              color: color,
              isActive: isActive,
            ),
          ),
          

          

          
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Speed value
              Text(
                '${speed.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: size * 0.12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
              
              // Unit
              Text(
                'Mbps',
                style: GoogleFonts.poppins(
                  fontSize: size * 0.05,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          // Speed markers
          ...List.generate(6, (index) {
            final markerAngle = (index * 45) * (3.14159 / 180); // Convert to radians
            final markerRadius = size * 0.45;
            final x = size * 0.5 + markerRadius * cos(markerAngle - 3.14159 / 2);
            final y = size * 0.5 + markerRadius * sin(markerAngle - 3.14159 / 2);
            
            return Positioned(
              left: x - 2,
              top: y - 2,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            );
          }),
          
          // Speed labels (REVERSED: 0 and maxSpeed are swapped)
          Positioned(
            bottom: size * 0.15,
            child: Text(
              '${maxSpeed.toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: size * 0.04,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          Positioned(
            right: size * 0.15,
            top: size * 0.5 - size * 0.04,
            child: Text(
              '${(maxSpeed / 2).toStringAsFixed(0)}',
              style: GoogleFonts.poppins(
                fontSize: size * 0.04,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          Positioned(
            top: size * 0.15,
            child: Text(
              '0',
              style: GoogleFonts.poppins(
                fontSize: size * 0.04,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildSpeedHistoryChart({
    required List<double> speeds,
    required Color color,
    required double maxSpeed,
    double height = 70,
  }) {
    // Calculate minimum speed from the speeds list
    final minSpeed = speeds.isNotEmpty ? speeds.reduce((a, b) => a < b ? a : b) : 0.0;
    return Container(
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Min: ${minSpeed.toStringAsFixed(0)}M',
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: color.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  'Max: ${maxSpeed.toStringAsFixed(0)}M',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CustomPaint(
                painter: SpeedHistoryPainter(
                  speeds: speeds,
                  color: color,
                  maxSpeed: maxSpeed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the speed meter arc
class SpeedMeterPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isActive;
  
  SpeedMeterPainter({
    required this.progress,
    required this.color,
    required this.isActive,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      3.14159 * 1.5, // 270 degrees
      false,
      backgroundPaint,
    );
    
    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    
    if (isActive) {
      // Add glow effect for active state
      final glowPaint = Paint()
        ..color = color.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.14159 / 2,
        progress * 3.14159 * 1.5,
        false,
        glowPaint,
      );
    }
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      progress * 3.14159 * 1.5,
      false,
      progressPaint,
    );
  }
  
  @override
  bool shouldRepaint(SpeedMeterPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.isActive != isActive;
  }
}

// Custom painter for speed history chart
class SpeedHistoryPainter extends CustomPainter {
  final List<double> speeds;
  final Color color;
  final double maxSpeed;
  
  SpeedHistoryPainter({
    required this.speeds,
    required this.color,
    required this.maxSpeed,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (speeds.isEmpty) return;
    
    final width = size.width;
    final height = size.height;
    final padding = 4.0; // Much smaller padding
    final chartWidth = width - 2 * padding;
    final chartHeight = height - 2 * padding;
    
    // Draw subtle background
    _drawBackground(canvas, size);
    
    // Draw the main line with area
    _drawLineWithArea(canvas, size, padding, chartWidth, chartHeight);
    
    // Draw current value indicator
    _drawCurrentIndicator(canvas, size, padding, chartWidth, chartHeight);
  }
  
  void _drawBackground(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      bgPaint,
    );
  }
  
  void _drawLineWithArea(Canvas canvas, Size size, double padding, double chartWidth, double chartHeight) {
    if (speeds.isEmpty) return;
    
    final path = Path();
    final effectiveMaxSpeed = maxSpeed > 0 ? maxSpeed : 1.0;
    
    if (speeds.length == 1) {
      // Single point - draw a vertical line
      final x = padding + chartWidth / 2;
      final y = size.height - padding - (speeds[0] / effectiveMaxSpeed) * chartHeight;
      path.moveTo(x, y);
      path.lineTo(x, size.height - padding);
    } else {
      // Multiple points - draw connected line
      for (int i = 0; i < speeds.length; i++) {
        final x = padding + (i / (speeds.length - 1)) * chartWidth;
        final y = size.height - padding - (speeds[i] / effectiveMaxSpeed) * chartHeight;
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      // Close the path to create area
      path.lineTo(size.width - padding, size.height - padding);
      path.lineTo(padding, size.height - padding);
      path.close();
    }
    
    // Draw area with gradient
    final gradient = LinearGradient(
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.05),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final areaPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, areaPaint);
    
    // Draw the line
    final linePath = Path();
    if (speeds.length == 1) {
      final x = padding + chartWidth / 2;
      final y = size.height - padding - (speeds[0] / effectiveMaxSpeed) * chartHeight;
      linePath.moveTo(x, y);
      linePath.lineTo(x, y);
    } else {
      for (int i = 0; i < speeds.length; i++) {
        final x = padding + (i / (speeds.length - 1)) * chartWidth;
        final y = size.height - padding - (speeds[i] / effectiveMaxSpeed) * chartHeight;
        
        if (i == 0) {
          linePath.moveTo(x, y);
        } else {
          linePath.lineTo(x, y);
        }
      }
    }
    
    // Draw line with glow
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(linePath, glowPaint);
    
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(linePath, linePaint);
  }
  
  void _drawCurrentIndicator(Canvas canvas, Size size, double padding, double chartWidth, double chartHeight) {
    if (speeds.isEmpty) return;
    
    final currentSpeed = speeds.last;
    final effectiveMaxSpeed = maxSpeed > 0 ? maxSpeed : 1.0;
    final x = size.width - padding - 8;
    final y = size.height - padding - (currentSpeed / effectiveMaxSpeed) * chartHeight;
    
    // Draw indicator dot
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final glowPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    // Glow
    canvas.drawCircle(Offset(x, y), 6, glowPaint);
    // Dot
    canvas.drawCircle(Offset(x, y), 3, dotPaint);
  }
  
  @override
  bool shouldRepaint(SpeedHistoryPainter oldDelegate) {
    return oldDelegate.speeds != speeds ||
           oldDelegate.color != color ||
           oldDelegate.maxSpeed != maxSpeed;
  }
} 