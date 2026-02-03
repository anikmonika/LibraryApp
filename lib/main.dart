import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SimpleLibraryApp());
}

class SimpleLibraryApp extends StatelessWidget {
  const SimpleLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleLibrary Offline',
      theme: ThemeData(useMaterial3: true),
      home: const LoginPage(),
    );
  }
}
