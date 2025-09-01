// // services/document_processor.dart
// import 'dart:io';
// import 'package:opencv_4/opencv_4.dart';
// import 'package:image/image.dart' as img;

// class DocumentProcessor {
//   // Detect document edges and apply perspective correction
//   static Future<File> detectAndCorrectDocument(String imagePath) async {
//     try {
//       // Convert image to Mat for OpenCV processing
//       Mat src = await ImgProc.imread(imagePath);
      
//       // Preprocess the image
//       Mat processed = await _preprocessImage(src);
      
//       // Find document contours
//       List<Point> documentCorners = await _findDocumentCorners(processed);
      
//       if (documentCorners.length == 4) {
//         // Apply perspective correction
//         Mat corrected = await _applyPerspectiveCorrection(src, documentCorners);
        
//         // Save the corrected image
//         String outputPath = '${imagePath}_corrected.jpg';
//         await ImgProc.imwrite(outputPath, corrected);
        
//         return File(outputPath);
//       } else {
//         // If no document detected, return original image
//         print('No document detected, returning original image');
//         return File(imagePath);
//       }
//     } catch (e) {
//       print('Error in document processing: $e');
//       return File(imagePath); // Fallback to original image
//     }
//   }

//   static Future<Mat> _preprocessImage(Mat src) async {
//     // Convert to grayscale
//     Mat gray = await ImgProc.cvtColor(src, ImgProc.COLOR_BGR2GRAY);
    
//     // Apply Gaussian blur to reduce noise
//     Mat blurred = await ImgProc.GaussianBlur(gray, [5, 5], 0);
    
//     // Apply edge detection
//     Mat edges = await ImgProc.Canny(blurred, 50, 150);
    
//     return edges;
//   }

//   static Future<List<Point>> _findDocumentCorners(Mat edges) async {
//     // Find contours
//     List<MatOfPoint> contours = await ImgProc.findContours(
//       edges,
//       ImgProc.RETR_EXTERNAL,
//       ImgProc.CHAIN_APPROX_SIMPLE,
//     );
    
//     // Sort contours by area (descending)
//     contours.sort((a, b) => b.area.compareTo(a.area));
    
//     if (contours.isEmpty) return [];
    
//     // Get the largest contour (potential document)
//     MatOfPoint largestContour = contours[0];
    
//     // Approximate the contour to reduce points
//     double epsilon = 0.02 * await ImgProc.arcLength(largestContour, true);
//     MatOfPoint approx = await ImgProc.approxPolyDP(largestContour, epsilon, true);
    
//     // If we have 4 points, we found a document
//     if (approx.area > 1000 && approx.total == 4) {
//       List<Point> points = await approx.toList();
//       return _orderPoints(points);
//     }
    
//     return [];
//   }

//   static List<Point> _orderPoints(List<Point> points) {
//     // Sort points in the order: top-left, top-right, bottom-right, bottom-left
//     points.sort((a, b) => a.x.compareTo(b.x));
    
//     List<Point> leftMost = points.sublist(0, 2);
//     List<Point> rightMost = points.sublist(2, 4);
    
//     leftMost.sort((a, b) => a.y.compareTo(b.y));
//     rightMost.sort((a, b) => a.y.compareTo(b.y));
    
//     return [
//       leftMost[0],  // top-left
//       rightMost[0], // top-right
//       rightMost[1], // bottom-right
//       leftMost[1],  // bottom-left
//     ];
//   }

//   static Future<Mat> _applyPerspectiveCorrection(Mat src, List<Point> corners) async {
//     // Define destination points for the perspective transform
//     Point tl = corners[0];
//     Point tr = corners[1];
//     Point br = corners[2];
//     Point bl = corners[3];
    
//     // Calculate width and height of the new image
//     double widthA = _distance(br, bl);
//     double widthB = _distance(tr, tl);
//     double maxWidth = widthA > widthB ? widthA : widthB;
    
//     double heightA = _distance(tr, br);
//     double heightB = _distance(tl, bl);
//     double maxHeight = heightA > heightB ? heightA : heightB;
    
//     // Destination points for the perspective transform
//     List<Point> dstPoints = [
//       Point(0, 0),
//       Point(maxWidth - 1, 0),
//       Point(maxWidth - 1, maxHeight - 1),
//       Point(0, maxHeight - 1),
//     ];
    
//     // Apply perspective transform
//     Mat transform = await ImgProc.getPerspectiveTransform(corners, dstPoints);
//     Mat warped = await ImgProc.warpPerspective(
//       src,
//       transform,
//       [maxWidth.toInt(), maxHeight.toInt()],
//     );
    
//     return warped;
//   }

//   static double _distance(Point a, Point b) {
//     return Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2));
//   }

//   // Enhance document after perspective correction
//   static Future<File> enhanceDocument(String imagePath) async {
//     Mat src = await ImgProc.imread(imagePath);
    
//     // Convert to grayscale
//     Mat gray = await ImgProc.cvtColor(src, ImgProc.COLOR_BGR2GRAY);
    
//     // Apply adaptive threshold for better contrast
//     Mat thresholded = await ImgProc.adaptiveThreshold(
//       gray,
//       255,
//       ImgProc.ADAPTIVE_THRESH_GAUSSIAN_C,
//       ImgProc.THRESH_BINARY,
//       11,
//       2,
//     );
    
//     String outputPath = '${imagePath}_enhanced.jpg';
//     await ImgProc.imwrite(outputPath, thresholded);
    
//     return File(outputPath);
//   }
// }

//////////

// services/document_processor.dart (simplified)
import 'dart:io';
import 'dart:ui';
import 'package:image/image.dart' as img;

class DocumentProcessor {
  // Simple document enhancement
  static Future<File> enhanceDocument(String imagePath) async {
    try {
      final originalImage = img.decodeImage(File(imagePath).readAsBytesSync())!;
      
      // Apply basic enhancements
      img.Image enhancedImage = _applyEnhancements(originalImage);
      
      // Save the enhanced image
      String outputPath = '${imagePath}_enhanced.jpg';
      File(outputPath).writeAsBytesSync(img.encodeJpg(enhancedImage));
      
      return File(outputPath);
    } catch (e) {
      print('Error enhancing document: $e');
      return File(imagePath);
    }
  }

  static img.Image _applyEnhancements(img.Image image) {
    // Convert to grayscale
    img.Image processed = img.grayscale(image);
    
    // Increase contrast
    processed = img.adjustColor(processed, contrast: 1.5);
    
    // Apply brightness adjustment
    processed = img.adjustColor(processed, brightness: 0.1);
    
    return processed;
  }

  // Simple perspective correction simulation
  static Future<File> applyPerspectiveCorrection(
    String imagePath, 
    List<Offset> corners
  ) async {
    // For now, just enhance the document
    return enhanceDocument(imagePath);
  }

  // Basic edge detection - returns default corners
  static Future<List<Offset>> detectEdges(String imagePath) async {
    try {
      final image = img.decodeImage(File(imagePath).readAsBytesSync())!;
      
      // Return default corners (25% from edges)
      final marginW = image.width * 0.25;
      final marginH = image.height * 0.25;
      
      return [
        Offset(marginW, marginH),
        Offset(image.width - marginW, marginH),
        Offset(image.width - marginW, image.height - marginH),
        Offset(marginW, image.height - marginH),
      ];
    } catch (e) {
      print('Edge detection failed: $e');
      return [];
    }
  }
}