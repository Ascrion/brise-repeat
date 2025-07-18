import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/theme_data.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: customTheme,
      home: MainScaffold(),
    );
  }
}
