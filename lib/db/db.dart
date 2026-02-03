import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  Db._();
  static final Db instance = Db._();
  Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null) return existing;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'simple_library.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createSchema(db);
        await _seed(db);
      },
    );
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE members(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE books(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        stock INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE loans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_id INTEGER NOT NULL,
        borrow_date TEXT NOT NULL,
        due_date TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'PINJAM',
        FOREIGN KEY(member_id) REFERENCES members(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE loan_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        loan_id INTEGER NOT NULL,
        book_id INTEGER NOT NULL,
        FOREIGN KEY(loan_id) REFERENCES loans(id) ON DELETE CASCADE,
        FOREIGN KEY(book_id) REFERENCES books(id),
        UNIQUE(loan_id, book_id)
      )
    ''');
  }

  Future<void> _seed(Database db) async {
    // Default users (simple password for demo)
    await db.insert('users', {'username': 'petugas', 'password': '123', 'role': 'PETUGAS'});
    await db.insert('users', {'username': 'anggota', 'password': '123', 'role': 'ANGGOTA'});

    // Members
    await db.insert('members', {'name': 'Andi', 'phone': '08123456789'});
    await db.insert('members', {'name': 'Budi', 'phone': '08129876543'});
    await db.insert('members', {'name': 'Siti', 'phone': '081200011122'});

    // Books
    final books = [
      {'title': 'Belajar Java Dasar', 'author': 'Anonim', 'stock': 3},
      {'title': 'Flutter untuk Pemula', 'author': 'Anonim', 'stock': 2},
      {'title': 'Algoritma & Struktur Data', 'author': 'Anonim', 'stock': 1},
      {'title': 'Basis Data MySQL', 'author': 'Anonim', 'stock': 4},
      {'title': 'Clean Code', 'author': 'Robert C. Martin', 'stock': 2},
      {'title': 'Design Patterns', 'author': 'GoF', 'stock': 1},
    ];
    for (final b in books) {
      await db.insert('books', b);
    }
  }
}
