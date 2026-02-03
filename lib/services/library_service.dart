import 'package:sqflite/sqflite.dart';
import '../db/db.dart';
import '../models/book.dart';
import '../models/member.dart';
import '../models/loan.dart';
import '../models/loan_item.dart';

class LibraryService {
  Future<List<Book>> listBooks({String? query}) async {
    final db = await Db.instance.database;
    final q = (query ?? '').trim();
    final rows = q.isEmpty
        ? await db.query('books', orderBy: 'title COLLATE NOCASE ASC')
        : await db.query(
            'books',
            where: 'title LIKE ? OR author LIKE ?',
            whereArgs: ['%$q%', '%$q%'],
            orderBy: 'title COLLATE NOCASE ASC',
          );
    return rows.map(Book.fromMap).toList();
  }

  Future<List<Member>> listMembers() async {
    final db = await Db.instance.database;
    final rows = await db.query('members', orderBy: 'name COLLATE NOCASE ASC');
    return rows.map(Member.fromMap).toList();
  }

  Future<List<Loan>> listLoans() async {
    final db = await Db.instance.database;
    final rows = await db.rawQuery('''
      SELECT l.id, l.member_id, m.name AS member_name, l.borrow_date, l.due_date, l.status
      FROM loans l
      JOIN members m ON m.id = l.member_id
      ORDER BY l.id DESC
    ''');
    return rows.map((m) => Loan.fromMap(m)).toList();
  }

  Future<List<LoanItem>> listLoanItems(int loanId) async {
    final db = await Db.instance.database;
    final rows = await db.rawQuery('''
      SELECT li.id, li.loan_id, li.book_id, b.title AS book_title
      FROM loan_items li
      JOIN books b ON b.id = li.book_id
      WHERE li.loan_id = ?
      ORDER BY b.title COLLATE NOCASE ASC
    ''', [loanId]);
    return rows.map((m) => LoanItem.fromMap(m)).toList();
  }

  Future<int> createLoan({
    required int memberId,
    required List<int> bookIds,
    DateTime? borrowDate,
  }) async {
    if (bookIds.isEmpty) {
      throw Exception('Pilih minimal 1 buku.');
    }

    final db = await Db.instance.database;
    final bDate = (borrowDate ?? DateTime.now());
    final borrow = DateTime(bDate.year, bDate.month, bDate.day);
    final due = borrow.add(const Duration(days: 7));

    return db.transaction<int>((txn) async {
      // Validate stock
      for (final bookId in bookIds) {
        final rows = await txn.query('books', where: 'id = ?', whereArgs: [bookId], limit: 1);
        if (rows.isEmpty) throw Exception('Buku tidak ditemukan (id=$bookId).');
        final stock = rows.first['stock'] as int;
        if (stock <= 0) throw Exception('Stok buku habis: ${rows.first['title']}');
      }

      final loanId = await txn.insert('loans', {
        'member_id': memberId,
        'borrow_date': borrow.toIso8601String(),
        'due_date': due.toIso8601String(),
        'status': 'PINJAM',
      });

      for (final bookId in bookIds.toSet()) {
        await txn.insert('loan_items', {'loan_id': loanId, 'book_id': bookId});
        await txn.rawUpdate('UPDATE books SET stock = stock - 1 WHERE id = ?', [bookId]);
      }

      return loanId;
    });
  }

  Future<void> returnLoan(int loanId) async {
    final db = await Db.instance.database;
    await db.transaction((txn) async {
      final items = await txn.query('loan_items', where: 'loan_id = ?', whereArgs: [loanId]);
      for (final it in items) {
        final bookId = it['book_id'] as int;
        await txn.rawUpdate('UPDATE books SET stock = stock + 1 WHERE id = ?', [bookId]);
      }
      await txn.update('loans', {'status': 'KEMBALI'}, where: 'id = ?', whereArgs: [loanId]);
    });
  }
}
