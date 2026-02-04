import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/book.dart';
import '../models/member.dart';
import '../services/library_service.dart';

class CreateLoanPage extends StatefulWidget {
  final int? preselectedBookId;
  const CreateLoanPage({super.key, this.preselectedBookId});

  @override
  State<CreateLoanPage> createState() => _CreateLoanPageState();
}

class _CreateLoanPageState extends State<CreateLoanPage> {
  final _svc = LibraryService();
  Member? _member;
  final Set<int> _selectedBookIds = {};
  bool _loading = true;
  List<Member> _members = [];
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final members = await _svc.listMembers();
      final books = await _svc.listBooks();
      setState(() {
        _members = members;
        _books = books;
        _member = members.isNotEmpty ? members.first : null;
        final pre = widget.preselectedBookId;
        if (pre != null) {
          final b = books.where((x) => x.id == pre).toList();
          if (b.isNotEmpty && b.first.stock > 0) {
            _selectedBookIds.add(pre);
          }
        }
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final m = _member;
    if (m == null) {
      _snack('Tidak ada anggota.');
      return;
    }
    final ids = _selectedBookIds.toList();
    try {
      final loanId = await _svc.createLoan(memberId: m.id, bookIds: ids);
      if (!mounted) return;
      final now = DateTime.now();
      final borrow = DateTime(now.year, now.month, now.day);
      final due = borrow.add(const Duration(days: 7));
      final f = DateFormat('dd MMM yyyy');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Peminjaman dibuat'),
          content: Text('Loan ID: $loanId\nPinjam: ${f.format(borrow)}\nHarus kembali: ${f.format(due)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _selectedBookIds.clear();
                _load(); // refresh stok
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    } catch (e) {
      _snack('Gagal: $e');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Buat Peminjaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          DropdownButtonFormField<Member>(
            value: _member,
            items: _members
                .map((m) => DropdownMenuItem(value: m, child: Text('${m.name} (${m.phone})')))
                .toList(),
            onChanged: (v) => setState(() => _member = v),
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Pilih Anggota'),
          ),
          const SizedBox(height: 12),
          const Text('Pilih Buku (multi)'),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _books.length,
              itemBuilder: (_, i) {
                final b = _books[i];
                final disabled = b.stock <= 0;
                final checked = _selectedBookIds.contains(b.id);
                return CheckboxListTile(
                  value: checked,
                  onChanged: disabled
                      ? null
                      : (v) {
                          setState(() {
                            if (v == true) {
                              _selectedBookIds.add(b.id);
                            } else {
                              _selectedBookIds.remove(b.id);
                            }
                          });
                        },
                  title: Text(b.title),
                  subtitle: Text('${b.author} • Stok: ${b.stock}${disabled ? " (habis)" : ""}'),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Peminjaman'),
            ),
          ),
        ],
      ),
    );
  }
}
