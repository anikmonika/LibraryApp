import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'catalog_page.dart';
import 'login_page.dart';

class MemberHomePage extends StatelessWidget {
  final AppUser user;
  const MemberHomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anggota - ${user.username}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: const CatalogPage(readOnly: true),
    );
  }
}
