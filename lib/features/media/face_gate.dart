import 'dart:io';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceGate {
  FaceGate()
      : _detector = FaceDetector(
          options: FaceDetectorOptions(
            performanceMode: FaceDetectorMode.accurate,
            enableContours: false,
            enableLandmarks: false,
          ),
        );

  final FaceDetector _detector;

  /// Returns true if the image is allowed (no faces detected).
  Future<bool> allowsImage(String path) async {
    final input = InputImage.fromFilePath(path);
    final faces = await _detector.processImage(input);
    return faces.isEmpty;
  }

  Future<void> dispose() => _detector.close();
}

bool isLikelyImageFile(File file) {
  final lower = file.path.toLowerCase();
  return lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.png') ||
      lower.endsWith('.webp') ||
      lower.endsWith('.heic');
}
