// // services/image_processor.dart
// import 'dart:io';
// import 'package:image/image.dart' as img;
// import '../models/filter_type.dart'; // Import from common file
// import '../widgets/filter_controls.dart';

// class ImageProcessor {
//   static Future<File> applyFilter(String imagePath, FilterType filter) async {
//     final image = img.decodeImage(File(imagePath).readAsBytesSync())!;
//     img.Image processedImage;

//     switch (filter) {
//       case FilterType.grayscale:
//         processedImage = img.grayscale(image);
//         break;
//       case FilterType.binary:
//         processedImage = _applyBinaryFilter(image);
//         break;
//       case FilterType.enhanced:
//         processedImage = _enhanceContrast(image);
//         break;
//       case FilterType.sepia:
//         processedImage = _applySepiaFilter(image);
//         break;
//       case FilterType.magicColor:
//         processedImage = _applyMagicColorFilter(image);
//         break;
//       case FilterType.original:
//       default:
//         processedImage = image;
//     }

//     final outputPath = '${imagePath}_${filter.name}.jpg';
//     final file = File(outputPath);
    
//     await file.writeAsBytes(img.encodeJpg(processedImage));
    
//     return file;
//   }

//   static img.Image _applyBinaryFilter(img.Image image) {
//     final grayscale = img.grayscale(image);
//     return img.invert(grayscale);
//   }

//   static img.Image _enhanceContrast(img.Image image) {
//     return img.adjustColor(image, contrast: 1.5, saturation: 1.2);
//   }

//   static img.Image _applySepiaFilter(img.Image image) {
//     return img.sepia(image, amount: 0.8);
//   }

//   static img.Image _applyMagicColorFilter(img.Image image) {
//     return img.colorOffset(image, red: 20, green: -20, blue: 20);
//   }
// }

/////////////////////

// services/image_processor.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart'; // For Offset
import '../models/filter_type.dart';

class ImageProcessor {
  // Remove static from the main method
  Future<File> applyFilter(String imagePath, FilterType filter) async {
    final image = img.decodeImage(File(imagePath).readAsBytesSync())!;
    img.Image processedImage;

    switch (filter) {
      case FilterType.grayscale:
        processedImage = img.grayscale(image);
        break;
      case FilterType.binary:
        processedImage = _applyBinaryFilter(image);
        break;
      case FilterType.enhanced:
        processedImage = _enhanceContrast(image);
        break;
      case FilterType.sepia:
        processedImage = _applySepiaFilter(image);
        break;
      case FilterType.magicColor:
        processedImage = _applyMagicColorFilter(image);
        break;
      case FilterType.original:
      default:
        processedImage = image;
    }

    final outputPath = '${imagePath}_${filter.name}.jpg';
    final file = File(outputPath);
    
    await file.writeAsBytes(img.encodeJpg(processedImage));
    
    return file;
  }

  Future<File> applyPerspectiveCorrection(
    String imagePath, 
    List<Offset> corners
  ) async {
    final image = img.decodeImage(File(imagePath).readAsBytesSync())!;
    
    // For now, just return the original image since perspective correction
    // requires more advanced image processing
    // This is a placeholder implementation
    
    final outputPath = '${imagePath}_corrected.jpg';
    final file = File(outputPath);
    await file.writeAsBytes(File(imagePath).readAsBytesSync());
    
    return file;
  }

  // Keep helper methods as static since they don't use instance variables
  static img.Image _applyBinaryFilter(img.Image image) {
    final grayscale = img.grayscale(image);
    return img.invert(grayscale);
  }

  static img.Image _enhanceContrast(img.Image image) {
    return img.adjustColor(image, contrast: 1.5, saturation: 1.2);
  }

  static img.Image _applySepiaFilter(img.Image image) {
    return img.sepia(image, amount: 0.8);
  }

  static img.Image _applyMagicColorFilter(img.Image image) {
    return img.colorOffset(image, red: 20, green: -20, blue: 20);
  }
}