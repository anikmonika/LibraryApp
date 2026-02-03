import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/library_service.dart';

class CatalogPage extends StatefulWidget {
  final bool readOnly;
  const CatalogPage({super.key, required this.readOnly});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _svc = LibraryService();
  final _q = TextEditingController();
  Future<List<Book>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _svc.listBooks();
    _q.addListener(() {
      setState(() {
        _future = _svc.listBooks(query: _q.text);
      });
    });
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _q,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search judul / penulis (A–Z otomatis)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                final items = snap.data ?? [];
                if (items.isEmpty) return const Center(child: Text('Tidak ada buku.'));
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final b = items[i];
                    return ListTile(
                      title: Text(b.title),
                      subtitle: Text(b.author),
                      trailing: Chip(label: Text('Stok: ${b.stock}')),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
