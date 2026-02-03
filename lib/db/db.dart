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
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await _createSchema(db);
        await _seed(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _seedMoreBooks(db);
        }
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
      {'title': 'Java OOP Lanjutan', 'author': 'Anonim', 'stock': 2},
      {'title': 'Struktur Data dengan Java', 'author': 'Anonim', 'stock': 2},
      {'title': 'Flutter untuk Pemula', 'author': 'Anonim', 'stock': 2},
      {'title': 'Flutter State Management', 'author': 'Anonim', 'stock': 1},
      {'title': 'Dart Cookbook', 'author': 'Anonim', 'stock': 2},
      {'title': 'Algoritma & Struktur Data', 'author': 'Anonim', 'stock': 1},
      {'title': 'Pemrograman Berorientasi Objek', 'author': 'Anonim', 'stock': 2},
      {'title': 'Basis Data MySQL', 'author': 'Anonim', 'stock': 4},
      {'title': 'SQL untuk Semua', 'author': 'Anonim', 'stock': 3},
      {'title': 'Normalisasi Database', 'author': 'Anonim', 'stock': 2},
      {'title': 'Clean Code', 'author': 'Robert C. Martin', 'stock': 2},
      {'title': 'The Clean Coder', 'author': 'Robert C. Martin', 'stock': 1},
      {'title': 'Refactoring', 'author': 'Martin Fowler', 'stock': 1},
      {'title': 'Design Patterns', 'author': 'GoF', 'stock': 1},
      {'title': 'Head First Design Patterns', 'author': 'Eric Freeman', 'stock': 2},
      {'title': 'Software Engineering', 'author': 'Ian Sommerville', 'stock': 1},
      {'title': 'Testing Java', 'author': 'Anonim', 'stock': 2},
      {'title': 'Unit Testing with JUnit', 'author': 'Anonim', 'stock': 2},
      {'title': 'Git & GitHub Praktis', 'author': 'Anonim', 'stock': 3},
      {'title': 'Android Studio Tips', 'author': 'Anonim', 'stock': 2},
      {'title': 'Jaringan Komputer Dasar', 'author': 'Anonim', 'stock': 2},
      {'title': 'Keamanan Aplikasi Web', 'author': 'Anonim', 'stock': 1},
      {'title': 'Sistem Informasi Perpustakaan', 'author': 'Anonim', 'stock': 2},
    ];
    for (final b in books) {
      await db.insert('books', b);
    }
  }

  Future<void> _seedMoreBooks(Database db) async {
    // Add more books for existing installations (version upgrade).
    final moreBooks = [
      {'title': 'Pemrograman Mobile Modern', 'author': 'Anonim', 'stock': 2},
      {'title': 'Dasar-dasar UI/UX', 'author': 'Anonim', 'stock': 2},
      {'title': 'Kotlin untuk Android', 'author': 'Anonim', 'stock': 2},
      {'title': 'REST API untuk Pemula', 'author': 'Anonim', 'stock': 3},
      {'title': 'Spring Boot Dasar', 'author': 'Anonim', 'stock': 2},
      {'title': 'Analisis & Perancangan Sistem', 'author': 'Anonim', 'stock': 2},
      {'title': 'Manajemen Proyek TI', 'author': 'Anonim', 'stock': 1},
      {'title': 'Jaringan Komputer Lanjutan', 'author': 'Anonim', 'stock': 1},
      {'title': 'Keamanan Aplikasi Mobile', 'author': 'Anonim', 'stock': 1},
      {'title': 'Pemodelan UML Praktis', 'author': 'Anonim', 'stock': 2},
    ];

    for (final b in moreBooks) {
      final exists = await _bookExists(db, b['title'] as String);
      if (!exists) {
        await db.insert('books', b);
      }
    }
  }

  Future<bool> _bookExists(Database db, String title) async {
    final rows = await db.query(
      'books',
      columns: ['id'],
      where: 'title = ?',
      whereArgs: [title],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

}
