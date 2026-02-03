import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'catalog_page.dart';
import 'create_loan_page.dart';
import 'loan_history_page.dart';
import 'login_page.dart';

class StaffHomePage extends StatefulWidget {
  final AppUser user;
  const StaffHomePage({super.key, required this.user});

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CatalogPage(readOnly: false),
      const CreateLoanPage(),
      const LoanHistoryPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Petugas - ${widget.user.username}'),
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
          NavigationDestination(icon: Icon(Icons.add_card), label: 'Pinjam'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Riwayat'),
        ],
      ),
    );
  }
}
