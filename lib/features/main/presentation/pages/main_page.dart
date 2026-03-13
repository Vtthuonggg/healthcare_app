import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../account/presentation/pages/account_page.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../home/presentation/pages/home_page.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class MainPage extends ConsumerWidget {
  static const path = '/main';
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        unauthenticated: () {
          context.go(LoginPage.path);
        },
        orElse: () {},
      );
    });

    final currentIndex = ref.watch(currentIndexProvider);

    final List<Widget> pages = [
      const HomePage(),
      const BookingPage(),
      const LongTermPage(),
      const NotificationPage(),
      const AccountPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () {
                ref.read(currentIndexProvider.notifier).state = 2;
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0,
              child: const Icon(
                IconsaxPlusLinear.calendar,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Đặt lịch',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItem(
                  context,
                  ref,
                  IconsaxPlusLinear.home_2,
                  IconsaxPlusBold.home_2,
                  "Trang chủ",
                  0,
                ),
                _buildItem(
                  context,
                  ref,
                  IconsaxPlusLinear.profile_2user,
                  IconsaxPlusBold.profile_2user,
                  "Hồ sơ",
                  1,
                ),
                const SizedBox(width: 60),
                _buildItem(
                  context,
                  ref,
                  IconsaxPlusLinear.notification,
                  IconsaxPlusBold.notification,
                  "Thông báo",
                  3,
                ),
                _buildItem(
                  context,
                  ref,
                  IconsaxPlusLinear.user,
                  IconsaxPlusBold.user,
                  "Tài khoản",
                  4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    IconData activeIcon,
    String title,
    int index,
  ) {
    final currentIndex = ref.watch(currentIndexProvider);
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(currentIndexProvider.notifier).state = index;
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[400],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hồ sơ'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusLinear.profile_2user,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Hồ sơ',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class LongTermPage extends StatelessWidget {
  const LongTermPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lịch'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconsaxPlusLinear.calendar, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Đặt lịch',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusLinear.notification,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Thông báo',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
