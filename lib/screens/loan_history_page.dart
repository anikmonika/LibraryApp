import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/loan.dart';
import '../models/loan_item.dart';
import '../services/library_service.dart';

class LoanHistoryPage extends StatefulWidget {
  const LoanHistoryPage({super.key});

  @override
  State<LoanHistoryPage> createState() => _LoanHistoryPageState();
}

class _LoanHistoryPageState extends State<LoanHistoryPage> {
  final _svc = LibraryService();
  Future<List<Loan>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _svc.listLoans();
  }

  Future<void> _refresh() async {
    setState(() => _future = _svc.listLoans());
  }

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd MMM yyyy');
    final now = DateTime.now();

    return FutureBuilder<List<Loan>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        final loans = snap.data ?? [];
        if (loans.isEmpty) return const Center(child: Text('Belum ada peminjaman.'));
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            itemCount: loans.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final l = loans[i];
              final overdue = l.isOverdue(now);
              final title = '${overdue ? "OVERDUE • " : ""}${l.memberName}';
              final subtitle =
                  'Pinjam: ${f.format(l.borrowDate)}  •  Kembali: ${f.format(l.dueDate)}  •  Status: ${l.status}';
              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () async {
                  final items = await _svc.listLoanItems(l.id);
                  if (!context.mounted) return;
                  _showDetail(context, l, items);
                },
                trailing: l.status == 'KEMBALI'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : TextButton(
                        onPressed: () async {
                          await _svc.returnLoan(l.id);
                          if (!mounted) return;
                          await _refresh();
                        },
                        child: const Text('Kembalikan'),
                      ),
              );
            },
          ),
        );
      },
    );
  }

  void _showDetail(BuildContext context, Loan loan, List<LoanItem> items) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Peminjaman #${loan.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Anggota: ${loan.memberName}'),
            Text('Status: ${loan.status}'),
            const SizedBox(height: 12),
            const Text('Buku dipinjam:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => ListTile(
                  dense: true,
                  title: Text(items[i].bookTitle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
