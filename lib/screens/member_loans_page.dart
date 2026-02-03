import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../models/member.dart';
import '../models/loan_item.dart';
import '../services/library_service.dart';

class MemberLoansPage extends StatefulWidget {
  const MemberLoansPage({super.key});

  @override
  State<MemberLoansPage> createState() => _MemberLoansPageState();
}

class _MemberLoansPageState extends State<MemberLoansPage> {
  final _svc = LibraryService();

  List<Member> _members = const [];
  Member? _selected;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final m = await _svc.listMembers();
    if (!mounted) return;
    setState(() {
      _members = m;
      _selected = (m.isNotEmpty) ? m.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sel = _selected;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 10),
              const Text('Anggota:', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<Member>(
                  value: sel,
                  isExpanded: true,
                  items: _members
                      .map((m) => DropdownMenuItem(value: m, child: Text(m.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _selected = v),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: sel == null
              ? const Center(child: Text('Belum ada data anggota.'))
              : FutureBuilder<List<Loan>>(
                  future: _svc.listLoansByMember(sel.id),
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snap.hasError) {
                      return Center(child: Text('Gagal memuat peminjaman: ${snap.error}'));
                    }
                    final loans = snap.data ?? const [];
                    if (loans.isEmpty) {
                      return const Center(child: Text('Belum ada peminjaman untuk anggota ini.'));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: loans.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _LoanCard(loan: loans[i], svc: _svc),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _LoanCard extends StatelessWidget {
  final Loan loan;
  final LibraryService svc;

  const _LoanCard({required this.loan, required this.svc});

  String _fmt(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$day-$m-$y';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final overdue = loan.isOverdue(now);
    final daysLeft = loan.dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    String statusText;
    if (loan.status == 'KEMBALI') {
      statusText = 'Sudah dikembalikan';
    } else if (overdue) {
      statusText = 'Terlambat ${daysLeft.abs()} hari';
    } else {
      statusText = 'Sisa $daysLeft hari';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_note),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Peminjaman #${loan.id}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                _StatusChip(status: loan.status, overdue: overdue),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                _Meta(label: 'Tgl pinjam', value: _fmt(loan.borrowDate)),
                _Meta(label: 'Batas kembali', value: _fmt(loan.dueDate)),
                _Meta(label: 'Info', value: statusText),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<LoanItem>>(
              future: svc.listLoanItems(loan.id),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: LinearProgressIndicator(),
                  );
                }
                final items = snap.data ?? const [];
                if (items.isEmpty) return const Text('Buku: -');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Buku dipinjam:', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    ...items.map((it) => Text('• ${it.bookTitle}')),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final String label;
  final String value;
  const _Meta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(color: Colors.black54)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  final bool overdue;
  const _StatusChip({required this.status, required this.overdue});

  @override
  Widget build(BuildContext context) {
    final label = (status == 'KEMBALI')
        ? 'KEMBALI'
        : overdue
            ? 'OVERDUE'
            : 'PINJAM';

    final bg = (status == 'KEMBALI')
        ? Colors.green.shade100
        : overdue
            ? Colors.red.shade100
            : Colors.orange.shade100;

    final fg = (status == 'KEMBALI')
        ? Colors.green.shade800
        : overdue
            ? Colors.red.shade800
            : Colors.orange.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
    );
  }
}
