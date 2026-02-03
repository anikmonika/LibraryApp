import '../db/db.dart';
import '../models/app_user.dart';

class AuthService {
  Future<AppUser?> login(String username, String password) async {
    final db = await Db.instance.database;
    final rows = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username.trim(), password],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return AppUser.fromMap(rows.first);
  }
}
