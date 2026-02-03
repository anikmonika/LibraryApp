import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';
import 'member_home_page.dart';
import 'staff_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final _u = TextEditingController(text: 'anggota');
  final _p = TextEditingController(text: '123');
  bool _loading = false;
  String? _error;

  Future<void> _doLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final AppUser? user = await _auth.login(_u.text, _p.text);
      if (!mounted) return;
      if (user == null) {
        setState(() => _error = 'Username / password salah.');
      } else {
        final next = user.role == 'PETUGAS'
            ? StaffHomePage(user: user)
            : MemberHomePage(user: user);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => next));
      }
    } catch (e) {
      setState(() => _error = 'Gagal login: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _u,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _p,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _doLogin,
                child: Text(_loading ? 'Loading...' : 'Masuk'),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Akun default:\n- petugas / 123\n- anggota / 123'),
          ],
        ),
      ),
    );
  }
}
