// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
// ...existing code...

class AccountPage extends ConsumerStatefulWidget {
  static const path = '/account';
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async {
            try {
              await ref.read(authProvider.notifier).logout();
            } catch (_) {
              context.go(LoginPage.path);
            }
          },
          child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
