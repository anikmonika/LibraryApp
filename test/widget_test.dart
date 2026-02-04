import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:library_app/main.dart';

void main() {
  testWidgets('App starts and shows login page', (WidgetTester tester) async {
    // Jalankan app utama
    await tester.pumpWidget(const SimpleLibraryApp());

    // Tunggu semua build selesai
    await tester.pumpAndSettle();

    // Pastikan halaman login tampil
    expect(find.text('Login'), findsOneWidget);
  });
}
