import 'package:flutter/material.dart';

class CardioImageUtils {
  static ImageProvider getImageProvider(
    String? path, {
    String fallback = 'images/patient_placeholder.png',
    bool bustCache = false,
  }) {
    if (path == null || path.isEmpty) {
      return AssetImage(fallback);
    }

    if (path.startsWith('http') || path.startsWith('https')) {
      final uri = Uri.parse(path);
      if (bustCache) {
        final busted = uri.replace(
          queryParameters: {
            ...uri.queryParameters,
            '_cb': DateTime.now().millisecondsSinceEpoch.toString(),
          },
        );
        return NetworkImage(busted.toString());
      }
      return NetworkImage(path);
    }

    return AssetImage(path);
  }

  static ImageProvider getCacheBustedImageProvider(
    String? path, {
    String fallback = 'images/patient_placeholder.png',
  }) {
    return getImageProvider(path, fallback: fallback, bustCache: true);
  }
}
