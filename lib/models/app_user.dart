class AppUser {
  final int id;
  final String username;
  final String role; // 'PETUGAS' | 'ANGGOTA'

  AppUser({required this.id, required this.username, required this.role});

  factory AppUser.fromMap(Map<String, Object?> m) => AppUser(
        id: (m['id'] as int),
        username: (m['username'] as String),
        role: (m['role'] as String),
      );
}
