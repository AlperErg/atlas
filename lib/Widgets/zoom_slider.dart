import 'package:flutter/material.dart';

class ZoomSliderWidget extends StatefulWidget {
  final double currentZoom;
  final void Function(double) onZoomChanged;
  final String? label;

  const ZoomSliderWidget({
    super.key,
    required this.currentZoom,
    required this.onZoomChanged,
    this.label = 'Zoom',
  });

  @override
  State<ZoomSliderWidget> createState() => _ZoomSliderWidgetState();
}

class _ZoomSliderWidgetState extends State<ZoomSliderWidget> {
  bool isInteracting = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    final activeColor = ZoomSliderConfig.getTextColor(brightness).withOpacity(
              isInteracting ? 0.3 : 0.0,);
    final inactiveColor =
        ZoomSliderConfig.getTextColor(brightness).withOpacity(
              isInteracting ? 0.3 : 0.0, // 👈 invisible unless interacting
            );

    return SizedBox(
      height: 260,
      width: 48,
      child: RotatedBox(
        quarterTurns: 3,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const ScalingIconThumb(
              icon: Icons.zoom_in,
            ),
            overlayShape: SliderComponentShape.noOverlay,
            thumbColor: activeColor,
            activeTrackColor: activeColor,
            inactiveTrackColor: inactiveColor,
          ),
          child: Slider(
            value: widget.currentZoom,
            min: ZoomSliderConfig.minZoom,
            max: ZoomSliderConfig.maxZoom,
            onChangeStart: (_) {
              setState(() => isInteracting = true);
            },
            onChangeEnd: (_) {
              setState(() => isInteracting = false);
            },
            onChanged: widget.onZoomChanged,
          ),
        ),
      ),
    );
  }
}

class ScalingIconThumb extends SliderComponentShape {
  final IconData icon;
  final double minSize;
  final double maxSize;

  const ScalingIconThumb({
    required this.icon,
    this.minSize = 20,
    this.maxSize = 40,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(maxSize, maxSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value, // normalized 0–1
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final iconSize =
        minSize + (maxSize - minSize) * value;

    final painter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: sliderTheme.thumbColor,
        ),
      ),
      textDirection: textDirection,
    )..layout();

    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }
}


/// Configuration parameters for the zoom slider widget
class ZoomSliderConfig {
  /// Minimum zoom level
  static const double minZoom = 0.25;
  
  /// Maximum zoom level
  static const double maxZoom = 4.0;
  
  /// Initial zoom level
  static const double initialZoom = 1.0;
    
  /// Slider height
  static const double sliderHeight = 40.0;
  
  /// Slider width
  static const double sliderWidth = 400.0;
  
  /// Border radius for the slider container
  static const double borderRadius = 20.0;
  
  /// Padding inside the slider container
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
  
  /// Get background color based on brightness
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color.fromARGB(220, 40, 40, 40)
        : Colors.white.withOpacity(0.9);
  }
  
  /// Get text color based on brightness
  static Color getTextColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
  
  /// Get active slider color based on brightness
  static Color getActiveColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.blue[400]!
        : Colors.blue;
  }
  
  /// Format zoom value for display (e.g., "1.0x")
  static String formatZoomValue(double zoom) {
    return '${zoom.toStringAsFixed(2)}x';
  }
}

