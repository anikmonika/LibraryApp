import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/library_service.dart';
import 'create_loan_page.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;
  final bool readOnly;
  const BookDetailPage({super.key, required this.book, required this.readOnly});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final _svc = LibraryService();
  late Future<Book?> _future;

  @override
  void initState() {
    super.initState();
    _future = _svc.getBookById(widget.book.id);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _svc.getBookById(widget.book.id);
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: FutureBuilder<Book?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final b = snap.data ?? widget.book;

          final available = b.stock > 0;
          final statusText = available ? 'Tersedia' : 'Habis';

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(b.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Penulis: ${b.author}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Chip(label: Text('Stok: ${b.stock}')),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(statusText),
                      avatar: Icon(available ? Icons.check_circle : Icons.cancel, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text('Deskripsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text(
                  'Halaman ini menampilkan detail buku yang dipilih dari katalog. '
                  'Anggota bisa melihat info buku sebelum meminjam. '
                  'Petugas bisa langsung mulai membuat transaksi peminjaman dengan buku ini.',
                  style: TextStyle(height: 1.35),
                ),
                const SizedBox(height: 20),
                if (!widget.readOnly) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: available
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CreateLoanPage(preselectedBookId: b.id),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.add_card),
                      label: const Text('Pinjamkan Buku Ini'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    available
                        ? 'Catatan: kamu tetap perlu memilih anggota di halaman berikutnya.'
                        : 'Stok habis. Buku tidak bisa dipinjam sampai ada pengembalian.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ] else ...[
                  Text(
                    'Catatan: untuk meminjam buku, silakan hubungi petugas perpustakaan.',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
