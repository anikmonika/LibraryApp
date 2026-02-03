class Member {
  final int id;
  final String name;
  final String phone;

  Member({required this.id, required this.name, required this.phone});

  factory Member.fromMap(Map<String, Object?> m) => Member(
        id: (m['id'] as int),
        name: (m['name'] as String),
        phone: (m['phone'] as String),
      );
}
