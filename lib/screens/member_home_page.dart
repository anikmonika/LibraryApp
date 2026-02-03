import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'catalog_page.dart';
import 'login_page.dart';
import 'member_loans_page.dart';

class MemberHomePage extends StatefulWidget {
  final AppUser user;
  const MemberHomePage({super.key, required this.user});

  @override
  State<MemberHomePage> createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CatalogPage(readOnly: true),
      const MemberLoansPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Anggota - ${widget.user.username}'),
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
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Katalog'),
          NavigationDestination(icon: Icon(Icons.event_available), label: 'Peminjaman Saya'),
        ],
      ),
    );
  }
}
