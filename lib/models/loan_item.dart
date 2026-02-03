class LoanItem {
  final int id;
  final int loanId;
  final int bookId;
  final String bookTitle;

  LoanItem({
    required this.id,
    required this.loanId,
    required this.bookId,
    required this.bookTitle,
  });

  factory LoanItem.fromMap(Map<String, Object?> m) => LoanItem(
        id: (m['id'] as int),
        loanId: (m['loan_id'] as int),
        bookId: (m['book_id'] as int),
        bookTitle: (m['book_title'] as String),
      );
}
