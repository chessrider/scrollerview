import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollerview/scrollerview.dart';

void main() {
  test('adds one to input values', () {
    final calculator = ScrollerView(
      child: Container(
        width: 1500,
        height: 1500,
        color: Colors.red,
      ),
    );
  });
}
