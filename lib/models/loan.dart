class Loan {
  final int id;
  final int memberId;
  final String memberName;
  final DateTime borrowDate;
  final DateTime dueDate;
  final String status; // 'PINJAM' | 'KEMBALI'

  Loan({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.borrowDate,
    required this.dueDate,
    required this.status,
  });

  factory Loan.fromMap(Map<String, Object?> m) => Loan(
        id: (m['id'] as int),
        memberId: (m['member_id'] as int),
        memberName: (m['member_name'] as String),
        borrowDate: DateTime.parse(m['borrow_date'] as String),
        dueDate: DateTime.parse(m['due_date'] as String),
        status: (m['status'] as String),
      );

  bool isOverdue(DateTime now) => status != 'KEMBALI' && now.isAfter(dueDate);
}
