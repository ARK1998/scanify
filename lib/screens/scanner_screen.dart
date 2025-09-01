// // screens/scanner_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import '../widgets/camera_preview.dart';
// import '../services/image_processor.dart';
// import '../widgets/filter_controls.dart';
// import '../models/filter_type.dart';

// class ScannerScreen extends StatefulWidget {
//   const ScannerScreen({super.key});

//   @override
//   _ScannerScreenState createState() => _ScannerScreenState();
// }

// class _ScannerScreenState extends State<ScannerScreen> {
//   File? _capturedImage;
//   bool _isCaptured = false;
//   FilterType _selectedFilter = FilterType.original;
//   bool _isProcessing = false;
//   bool _showCamera = true;

//   void _handleImageCaptured(XFile image) async {
//     setState(() {
//       _capturedImage = File(image.path);
//       _isCaptured = true;
//       _showCamera = false;
//     });
//   }

//   Future<void> _retakePhoto() async {
//     setState(() {
//       _capturedImage = null;
//       _isCaptured = false;
//       _showCamera = true;
//     });
//   }

//   Future<void> _processDocument() async {
//     if (_capturedImage == null) return;

//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       final processedImage = await ImageProcessor.applyFilter(
//         _capturedImage!.path,
//         _selectedFilter,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Document processed successfully!'),
//           backgroundColor: Colors.green[600],
//         ),
//       );

//       print('Document processed: ${processedImage.path}');
      
//       // Navigate back or to document details
//       Navigator.pop(context, processedImage.path);
      
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red[600],
//         ),
//       );
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan Document'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           if (_isCaptured)
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: _retakePhoto,
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 3,
//             child: _showCamera
//                 ? CameraPreviewWidget(onImageCaptured: _handleImageCaptured)
//                 : _buildImagePreview(),
//           ),
//           if (_isCaptured)
//             FilterControls(
//               onFilterChanged: (filter) {
//                 setState(() {
//                   _selectedFilter = filter;
//                 });
//               },
//               initialFilter: _selectedFilter,
//             ),
//         ],
//       ),
//       floatingActionButton: _isCaptured
//           ? FloatingActionButton.extended(
//               onPressed: _isProcessing ? null : _processDocument,
//               backgroundColor: const Color(0xFF10B981),
//               icon: _isProcessing
//                   ? const CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     )
//                   : const Icon(Icons.check),
//               label: Text(_isProcessing ? 'Processing...' : 'Process'),
//             )
//           : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   Widget _buildImagePreview() {
//     return Stack(
//       children: [
//         Container(
//           margin: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Image.file(_capturedImage!, fit: BoxFit.cover),
//           ),
//         ),
//         if (_isProcessing)
//           Container(
//             color: Colors.black.withOpacity(0.5),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

////////////////////

// screens/scanner_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/image_processor.dart';
// import '../widgets/filter_controls.dart';
// import '../widgets/document_adjuster.dart';
// import '../models/filter_type.dart';

// class ScannerScreen extends StatefulWidget {
//   const ScannerScreen({super.key});

//   @override
//   _ScannerScreenState createState() => _ScannerScreenState();
// }

// class _ScannerScreenState extends State<ScannerScreen> {
//   File? _capturedImage;
//   bool _isCaptured = false;
//   FilterType _selectedFilter = FilterType.original;
//   bool _isProcessing = false;
//   bool _showAdjuster = false;

//   Future<void> _captureImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
//     if (image != null) {
//       setState(() {
//         _capturedImage = File(image.path);
//         _isCaptured = true;
//         _showAdjuster = true; // Show adjuster after capture
//       });
//     }
//   }

//   void _toggleAdjuster() {
//     setState(() {
//       _showAdjuster = !_showAdjuster;
//     });
//   }

//   Future<void> _processDocument() async {
//     if (_capturedImage == null) return;

//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       final processedImage = await ImageProcessor.applyFilter(
//         _capturedImage!.path,
//         _selectedFilter,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Document processed successfully!'),
//           backgroundColor: Colors.green[600],
//         ),
//       );

//       print('Document processed: ${processedImage.path}');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red[600],
//         ),
//       );
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }

//   void _onCornersChanged(List<Offset> corners) {
//     print('Corners updated: $corners');
//     // Here you would typically process the image with the new corners
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan Document'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           if (_isCaptured && !_showAdjuster)
//             IconButton(
//               icon: const Icon(Icons.crop),
//               onPressed: _toggleAdjuster,
//               tooltip: 'Adjust Document',
//             ),
//           if (_isCaptured && _showAdjuster)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: _toggleAdjuster,
//               tooltip: 'Apply Adjustment',
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _isCaptured && _capturedImage != null
//                 ? _showAdjuster
//                     ? DocumentAdjuster(
//                         image: _capturedImage!,
//                         onCornersChanged: _onCornersChanged,
//                       )
//                     : _buildImagePreview()
//                 : _buildCameraPlaceholder(),
//           ),
//           if (_isCaptured && !_showAdjuster)
//             FilterControls(
//               onFilterChanged: (filter) {
//                 setState(() {
//                   _selectedFilter = filter;
//                 });
//               },
//               initialFilter: _selectedFilter,
//             ),
//         ],
//       ),
//       floatingActionButton: _isCaptured && !_showAdjuster
//           ? FloatingActionButton.extended(
//               onPressed: _isProcessing ? null : _processDocument,
//               backgroundColor: const Color(0xFF10B981),
//               icon: _isProcessing
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : const Icon(Icons.check),
//               label: Text(_isProcessing ? 'Processing...' : 'Process Document'),
//             )
//           : !_isCaptured
//               ? FloatingActionButton.extended(
//                   onPressed: _captureImage,
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Capture Document'),
//                 )
//               : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   Widget _buildCameraPlaceholder() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               color: const Color(0xFFEFF6FF),
//               borderRadius: BorderRadius.circular(60),
//             ),
//             child: const Icon(
//               Icons.document_scanner,
//               size: 60,
//               color: Color(0xFF2563EB),
//             ),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'Ready to scan',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Capture a document to get started',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImagePreview() {
//     return Stack(
//       children: [
//         Container(
//           margin: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Image.file(_capturedImage!, fit: BoxFit.contain),
//           ),
//         ),
//         if (_isProcessing)
//           Container(
//             color: Colors.black.withOpacity(0.5),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

//////////////

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/image_processor.dart';
// import '../widgets/filter_controls.dart';
// import '../widgets/document_adjuster.dart';
// import '../models/filter_type.dart';

// class ScannerScreen extends StatefulWidget {
//   const ScannerScreen({super.key});

//   @override
//   _ScannerScreenState createState() => _ScannerScreenState();
// }

// class _ScannerScreenState extends State<ScannerScreen> {
//   File? _capturedImage;
//   bool _isCaptured = false;
//   FilterType _selectedFilter = FilterType.original;
//   bool _isProcessing = false;
//   bool _showAdjuster = false;

//   Future<void> _captureImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
//     if (image != null) {
//       setState(() {
//         _capturedImage = File(image.path);
//         _isCaptured = true;
//         _showAdjuster = true; // Show adjuster after capture
//       });
//     }
//   }

//   void _toggleAdjuster() {
//     setState(() {
//       _showAdjuster = !_showAdjuster;
//     });
//   }

//   Future<void> _processDocument() async {
//     if (_capturedImage == null) return;

//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       final processedImage = await ImageProcessor.applyFilter(
//         _capturedImage!.path,
//         _selectedFilter,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Document processed successfully!'),
//           backgroundColor: Colors.green[600],
//         ),
//       );

//       print('Document processed: ${processedImage.path}');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red[600],
//         ),
//       );
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }

//   void _onCornersChanged(List<Offset> corners) {
//     print('Corners updated: $corners');
//     // Here you would typically process the image with the new corners
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan Document'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           if (_isCaptured && !_showAdjuster)
//             IconButton(
//               icon: const Icon(Icons.crop),
//               onPressed: _toggleAdjuster,
//               tooltip: 'Adjust Document',
//             ),
//           if (_isCaptured && _showAdjuster)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: _toggleAdjuster,
//               tooltip: 'Apply Adjustment',
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _isCaptured && _capturedImage != null
//                 ? _showAdjuster
//                     ? DocumentAdjuster(
//                         image: _capturedImage!,
//                         onCornersChanged: _onCornersChanged,
//                       )
//                     : _buildImagePreview()
//                 : _buildCameraPlaceholder(),
//           ),
//           if (_isCaptured && !_showAdjuster)
//             FilterControls(
//               onFilterChanged: (filter) {
//                 setState(() {
//                   _selectedFilter = filter;
//                 });
//               },
//               initialFilter: _selectedFilter,
//             ),
//         ],
//       ),
//       floatingActionButton: _isCaptured && !_showAdjuster
//           ? FloatingActionButton.extended(
//               onPressed: _isProcessing ? null : _processDocument,
//               backgroundColor: const Color(0xFF10B981),
//               icon: _isProcessing
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : const Icon(Icons.check),
//               label: Text(_isProcessing ? 'Processing...' : 'Process Document'),
//             )
//           : !_isCaptured
//               ? FloatingActionButton.extended(
//                   onPressed: _captureImage,
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Capture Document'),
//                 )
//               : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   Widget _buildCameraPlaceholder() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               color: const Color(0xFFEFF6FF),
//               borderRadius: BorderRadius.circular(60),
//             ),
//             child: const Icon(
//               Icons.document_scanner,
//               size: 60,
//               color: Color(0xFF2563EB),
//             ),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'Ready to scan',
//             style: Theme.of(context).textTheme.headlineMedium,
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Capture a document to get started',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImagePreview() {
//     return Stack(
//       children: [
//         Container(
//           margin: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Image.file(_capturedImage!, fit: BoxFit.contain),
//           ),
//         ),
//         if (_isProcessing)
//           Container(
//             color: Colors.black.withOpacity(0.5),
//             child: const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }


/////////////////


// // screens/scanner_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/document_processor.dart';
// import '../services/image_processor.dart';
// import '../widgets/filter_controls.dart';
// import '../widgets/document_adjuster.dart';
// import '../models/filter_type.dart';

// class ScannerScreen extends StatefulWidget {
//   const ScannerScreen({super.key});

//   @override
//   _ScannerScreenState createState() => _ScannerScreenState();
// }

// class _ScannerScreenState extends State<ScannerScreen> {
//   File? _capturedImage;
//   bool _isCaptured = false;
//   FilterType _selectedFilter = FilterType.original;
//   bool _isProcessing = false;
//   bool _showAdjuster = false;
//   List<Offset> _detectedCorners = [];

//   Future<void> _captureImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
//     if (image != null) {
//       setState(() {
//         _capturedImage = File(image.path);
//         _isCaptured = true;
//       });
      
//       // Automatically detect document and show adjuster
//       _autoDetectDocument();
//     }
//   }

//   Future<void> _autoDetectDocument() async {
//     setState(() {
//       _isProcessing = true;
//     });
    
//     try {
//       // Process the image to detect document
//       final processedImage = await DocumentProcessor.detectAndCorrectDocument(
//         _capturedImage!.path,
//       );
      
//       // For now, we'll just show the adjuster
//       // In a real app, you'd get the detected corners from the processor
//       setState(() {
//         _showAdjuster = true;
//         _isProcessing = false;
        
//         // Simulate detected corners (in real app, these would come from OpenCV)
//         _detectedCorners = [
//           Offset(50, 50),
//           Offset(250, 50),
//           Offset(250, 350),
//           Offset(50, 350),
//         ];
//       });
//     } catch (e) {
//       print('Auto-detection failed: $e');
//       setState(() {
//         _showAdjuster = true;
//         _isProcessing = false;
//       });
//     }
//   }

//   Future<void> _processDocument() async {
//     if (_capturedImage == null) return;

//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       File imageToProcess = _capturedImage!;
      
//       // If we have manual adjustments, apply them first
//       if (_showAdjuster && _detectedCorners.isNotEmpty) {
//         // Convert Offset to Point for OpenCV
//         List<Point> points = _detectedCorners.map((offset) => 
//           Point(offset.dx.toDouble(), offset.dy.toDouble())).toList();
        
//         // Apply perspective correction
//         imageToProcess = await DocumentProcessor.detectAndCorrectDocument(
//           _capturedImage!.path,
//         );
//       }
      
//       // Apply selected filter
//       final ImageProcessor processor = ImageProcessor();
//       final processedImage = await processor.applyFilter(
//         imageToProcess.path,
//         _selectedFilter,
//       );

//       // Enhance the document
//       final enhancedImage = await DocumentProcessor.enhanceDocument(
//         processedImage.path,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Document processed successfully!'),
//           backgroundColor: Colors.green[600],
//         ),
//       );

//       print('Final document: ${enhancedImage.path}');
      
//       // Navigate back or to results screen
//       // Navigator.pop(context, enhancedImage.path);
      
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error processing document: $e'),
//           backgroundColor: Colors.red[600],
//         ),
//       );
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }

//   void _onCornersChanged(List<Offset> corners) {
//     setState(() {
//       _detectedCorners = corners;
//     });
//   }

//   // ... rest of your existing code (toggleAdjuster, build methods, etc.)
// }

/////////////


// screens/scanner_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/document_processor.dart';
import '../services/image_processor.dart';
import '../widgets/filter_controls.dart';
import '../widgets/document_adjuster.dart';
import '../models/filter_type.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File? _capturedImage;
  bool _isCaptured = false;
  FilterType _selectedFilter = FilterType.original;
  bool _isProcessing = false;
  bool _showAdjuster = false;
  List<Offset> _detectedCorners = [];

  Future<void> _captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        _capturedImage = File(image.path);
        _isCaptured = true;
      });
      
      // Automatically detect document and show adjuster
      _autoDetectDocument();
    }
  }

  Future<void> _autoDetectDocument() async {
    setState(() {
      _isProcessing = true;
    });
    
    try {
      final detectedCorners = await DocumentProcessor.detectEdges(
        _capturedImage!.path,
      );
      
      setState(() {
        _showAdjuster = true;
        _isProcessing = false;
        _detectedCorners = detectedCorners.isNotEmpty 
            ? detectedCorners 
            : [
                const Offset(50, 50),
                const Offset(250, 50),
                const Offset(250, 350),
                const Offset(50, 350),
              ];
      });
    } catch (e) {
      print('Auto-detection failed: $e');
      setState(() {
        _showAdjuster = true;
        _isProcessing = false;
      });
    }
  }

  void _toggleAdjuster() {
    setState(() {
      _showAdjuster = !_showAdjuster;
    });
  }

  Future<void> _processDocument() async {
    if (_capturedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      File imageToProcess = _capturedImage!;
      
      // If we have manual adjustments, apply them first
      if (_showAdjuster && _detectedCorners.isNotEmpty) {
        imageToProcess = await DocumentProcessor.applyPerspectiveCorrection(
          _capturedImage!.path,
          _detectedCorners,
        );
      }
      
      // Apply selected filter
      final ImageProcessor processor = ImageProcessor();
      final processedImage = await processor.applyFilter(
        imageToProcess.path,
        _selectedFilter,
      );

      // Enhance the document
      final enhancedImage = await DocumentProcessor.enhanceDocument(
        processedImage.path,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document processed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      print('Final document: ${enhancedImage.path}');
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error processing document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _onCornersChanged(List<Offset> corners) {
    setState(() {
      _detectedCorners = corners;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Document'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isCaptured && !_showAdjuster)
            IconButton(
              icon: const Icon(Icons.crop),
              onPressed: _toggleAdjuster,
              tooltip: 'Adjust Document',
            ),
          if (_isCaptured && _showAdjuster)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _toggleAdjuster,
              tooltip: 'Apply Adjustment',
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCaptured && _capturedImage != null
                ? _showAdjuster
                    ? DocumentAdjuster(
                        image: _capturedImage!,
                        onCornersChanged: _onCornersChanged,
                      )
                    : _buildImagePreview()
                : _buildCameraPlaceholder(),
          ),
          if (_isCaptured && !_showAdjuster)
            FilterControls(
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              initialFilter: _selectedFilter,
            ),
        ],
      ),
      floatingActionButton: _isCaptured && !_showAdjuster
          ? FloatingActionButton.extended(
              onPressed: _isProcessing ? null : _processDocument,
              backgroundColor: const Color(0xFF10B981),
              icon: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.check),
              label: Text(_isProcessing ? 'Processing...' : 'Process Document'),
            )
          : !_isCaptured
              ? FloatingActionButton.extended(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capture Document'),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCameraPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.document_scanner,
              size: 60,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Ready to scan',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Capture a document to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(_capturedImage!, fit: BoxFit.contain),
          ),
        ),
        if (_isProcessing)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}