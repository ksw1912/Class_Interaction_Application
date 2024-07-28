import 'package:flutter/material.dart';

class CircularProgress {
  static Widget build() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.grey,
        semanticsLabel: 'Circular progress indicator',
      ),
    );
  }
}
