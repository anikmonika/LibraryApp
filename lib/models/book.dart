class Book {
  final int id;
  final String title;
  final String author;
  final int stock;

  Book({required this.id, required this.title, required this.author, required this.stock});

  factory Book.fromMap(Map<String, Object?> m) => Book(
        id: (m['id'] as int),
        title: (m['title'] as String),
        author: (m['author'] as String),
        stock: (m['stock'] as int),
      );
}
