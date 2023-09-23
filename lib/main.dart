import 'package:connie/pages/home_page.dart';
import 'package:connie/ui/local_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Connie',
      theme: LocalTheme.defaultTheme,
      home: const HomePage(),
    ),
  );
}
