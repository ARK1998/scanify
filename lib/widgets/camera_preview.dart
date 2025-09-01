// // widgets/camera_preview.dart
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

// class CameraPreviewWidget extends StatefulWidget {
//   final Function(XFile) onImageCaptured;

//   const CameraPreviewWidget({super.key, required this.onImageCaptured});

//   @override
//   _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
// }

// class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   bool _isLoading = true;
//   bool _isBackCamera = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _cameras = await availableCameras();
//       if (_cameras != null && _cameras!.isNotEmpty) {
//         await _setupCamera(0); // Start with back camera
//       }
//     } catch (e) {
//       print('Camera initialization error: $e');
//     }
//     setState(() => _isLoading = false);
//   }

//   Future<void> _setupCamera(int cameraIndex) async {
//     if (_cameras == null || cameraIndex >= _cameras!.length) return;

//     _controller = CameraController(
//       _cameras![cameraIndex],
//       ResolutionPreset.high,
//     );

//     try {
//       await _controller!.initialize();
//       setState(() {});
//     } catch (e) {
//       print('Camera setup error: $e');
//     }
//   }

//   Future<void> _switchCamera() async {
//     if (_cameras == null || _cameras!.length < 2) return;
    
//     setState(() => _isLoading = true);
//     await _controller!.dispose();
    
//     _isBackCamera = !_isBackCamera;
//     final newIndex = _isBackCamera ? 0 : 1;
//     await _setupCamera(newIndex);
//     setState(() => _isLoading = false);
//   }

//   Future<void> _captureImage() async {
//     if (_controller == null || !_controller!.value.isInitialized) return;

//     try {
//       final XFile image = await _controller!.takePicture();
//       widget.onImageCaptured(image);
//     } catch (e) {
//       print('Capture error: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_controller == null || !_controller!.value.isInitialized) {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.camera_alt, size: 64, color: Colors.grey), // FIXED: Changed from camera_off to camera_alt
//             SizedBox(height: 16),
//             Text('Camera not available'),
//           ],
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         CameraPreview(_controller!),
//         Positioned(
//           bottom: 20,
//           left: 0,
//           right: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               FloatingActionButton(
//                 onPressed: _switchCamera,
//                 child: const Icon(Icons.flip_camera_android),
//               ),
//               const SizedBox(width: 20),
//               FloatingActionButton(
//                 onPressed: _captureImage,
//                 backgroundColor: Colors.red,
//                 child: const Icon(Icons.camera),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

/////////////

// widgets/camera_preview.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewWidget extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const CameraPreviewWidget({super.key, required this.onImageCaptured});

  @override
  _CameraPreviewWidgetState createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isLoading = true;
  bool _isBackCamera = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        await _setupCamera(0); // Start with back camera
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_cameras == null || cameraIndex >= _cameras!.length) return;

    _controller = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.high,
    );

    try {
      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      print('Camera setup error: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    
    setState(() => _isLoading = true);
    await _controller!.dispose();
    
    _isBackCamera = !_isBackCamera;
    final newIndex = _isBackCamera ? 0 : 1;
    await _setupCamera(newIndex);
    setState(() => _isLoading = false);
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile image = await _controller!.takePicture();
      widget.onImageCaptured(image);
    } catch (e) {
      print('Capture error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Camera not available'),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Camera preview centered
        Center(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: CameraPreview(_controller!),
          ),
        ),
        
        // Document adjustment overlay (CamScanner style)
        _buildDocumentOverlay(),
        
        // Camera controls
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _switchCamera,
                mini: true,
                child: const Icon(Icons.flip_camera_android),
              ),
              const SizedBox(width: 30),
              FloatingActionButton(
                onPressed: _captureImage,
                backgroundColor: Colors.red,
                child: const Icon(Icons.camera, size: 30),
              ),
              const SizedBox(width: 30),
              FloatingActionButton(
                onPressed: () {
                  // Flash toggle functionality
                },
                mini: true,
                child: const Icon(Icons.flash_on),
              ),
            ],
          ),
        ),
        
        // Guidance text
        const Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Align document within the frame',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    blurRadius: 4.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentOverlay() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Corner markers (like CamScanner)
            // Top left corner
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 3),
                    left: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ),
            // Top right corner
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white, width: 3),
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ),
            // Bottom left corner
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 3),
                    left: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ),
            // Bottom right corner
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 3),
                    right: BorderSide(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ),
            
            // Grid lines (optional)
            ..._buildGridLines(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGridLines() {
    return [
      // Vertical center line
      Positioned(
        left: MediaQuery.of(context).size.width * 0.4,
        top: 0,
        bottom: 0,
        child: Container(
          width: 1,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      // Horizontal center line
      Positioned(
        top: MediaQuery.of(context).size.height * 0.3,
        left: 0,
        right: 0,
        child: Container(
          height: 1,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    ];
  }
}
