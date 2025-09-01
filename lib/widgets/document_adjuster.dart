// widgets/document_adjuster.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class DocumentAdjuster extends StatefulWidget {
  final File image;
  final Function(List<Offset>) onCornersChanged;

  const DocumentAdjuster({
    super.key,
    required this.image,
    required this.onCornersChanged,
  });

  @override
  _DocumentAdjusterState createState() => _DocumentAdjusterState();
}

class _DocumentAdjusterState extends State<DocumentAdjuster> {
  late List<Offset> corners;
  int? selectedCornerIndex;
  late img.Image decodedImage;
  late double imageWidth;
  late double imageHeight;

  @override
  void initState() {
    super.initState();
    _initializeImage();
  }

  void _initializeImage() async {
    final bytes = await widget.image.readAsBytes();
    decodedImage = img.decodeImage(bytes)!;
    imageWidth = decodedImage.width.toDouble();
    imageHeight = decodedImage.height.toDouble();

    // Initialize corners (default to image bounds)
    setState(() {
      corners = [
        Offset(0.2 * imageWidth, 0.2 * imageHeight), // Top-left
        Offset(0.8 * imageWidth, 0.2 * imageHeight), // Top-right
        Offset(0.8 * imageWidth, 0.8 * imageHeight), // Bottom-right
        Offset(0.2 * imageWidth, 0.8 * imageHeight), // Bottom-left
      ];
    });

    widget.onCornersChanged(corners);
  }

  void _updateCorner(int index, Offset newPosition) {
    setState(() {
      corners[index] = newPosition;
    });
    widget.onCornersChanged(corners);
  }

  @override
  Widget build(BuildContext context) {
    if (corners.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.1,
      maxScale: 5.0,
      child: Stack(
        children: [
          // Display the image
          Center(
            child: Image.file(widget.image, fit: BoxFit.contain),
          ),

          // Document boundary with draggable corners
          CustomPaint(
            painter: DocumentBoundaryPainter(corners),
            child: Container(),
          ),

          // Draggable corner points
          for (int i = 0; i < corners.length; i++)
            Positioned(
              left: corners[i].dx - 20,
              top: corners[i].dy - 20,
              child: GestureDetector(
                onPanUpdate: (details) {
                  final newPosition = corners[i] + details.delta;
                  _updateCorner(i, newPosition);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.open_with,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DocumentBoundaryPainter extends CustomPainter {
  final List<Offset> corners;

  DocumentBoundaryPainter(this.corners);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (corners.length >= 4) {
      path.moveTo(corners[0].dx, corners[0].dy);
      for (int i = 1; i < corners.length; i++) {
        path.lineTo(corners[i].dx, corners[i].dy);
      }
      path.close();
    }

    canvas.drawPath(path, paint);

    // Draw grid lines inside the document
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    if (corners.length >= 4) {
      // Horizontal lines
      for (double t = 0.25; t < 1.0; t += 0.25) {
        final p1 = Offset.lerp(corners[0], corners[3], t)!;
        final p2 = Offset.lerp(corners[1], corners[2], t)!;
        canvas.drawLine(p1, p2, gridPaint);
      }

      // Vertical lines
      for (double t = 0.25; t < 1.0; t += 0.25) {
        final p1 = Offset.lerp(corners[0], corners[1], t)!;
        final p2 = Offset.lerp(corners[3], corners[2], t)!;
        canvas.drawLine(p1, p2, gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}