import 'package:flutter/material.dart';

class CardioImageUtils {
  static ImageProvider getImageProvider(String? path, {String fallback = 'images/patient_placeholder.png'}) {
    if (path == null || path.isEmpty) {
      return AssetImage(fallback);
    }
    
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    }
    
    return AssetImage(path);
  }
}
