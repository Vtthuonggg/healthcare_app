import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare_app/features/auth/domain/models/user.dart';
import 'package:healthcare_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:healthcare_app/features/auth/presentation/providers/auth_state.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/pages/contact_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenUtil.init(context);

    const bodyBg = Colors.white;
    final AuthState authState = ref.watch(authProvider);
    final user = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    return Scaffold(
      backgroundColor: bodyBg,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                backgroundColor: AppTheme.primaryColor,
                automaticallyImplyLeading: false,
                expandedHeight: 180,
                elevation: 0,
                scrolledUnderElevation: 0,
                stretch: true,
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(24),
                  child: _AppBarBottomCap(background: bodyBg),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _ProfileHeader(user),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 18),
                    _SectionTitle(title: 'Thông tin chung'),
                    const SizedBox(height: 8),
                    _MenuCard(
                      children: [
                        _MenuTile(
                          icon: IconsaxPlusLinear.user,
                          title: 'Thông tin cá nhân',
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _MenuTile(
                          icon: IconsaxPlusLinear.heart,
                          title: 'Thông tin sức khỏe',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _SectionTitle(title: 'Hồ sơ người thân'),
                    const SizedBox(height: 14),
                    _RelativeEmptyCard(onAdd: () {}),
                    const SizedBox(height: 36),
                    SizedBox(height: (kBottomNavigationBarHeight + 30).h),
                  ]),
                ),
              ),
            ],
          ),
          Positioned(
            right: 18,
            bottom: 18 + kBottomNavigationBarHeight,
            child: _MessengerButton(
              onTap: () => context.push(ContactPage.path),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarBottomCap extends StatelessWidget {
  const _AppBarBottomCap({required this.background});

  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: double.infinity,
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader(this.user);

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withValues(alpha: 0.90),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Positioned(
              left: -80,
              top: 20,
              child: _SoftCircle(size: 180, opacity: 0.10),
            ),
            const Positioned(
              right: -60,
              top: 60,
              child: _SoftCircle(size: 140, opacity: 0.08),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 20),
                    child: Row(
                      children: [
                        const _Avatar(radius: 44, onCameraTap: _noop),
                        const SizedBox(width: 12),
                        Text(
                          user?.fullName ?? 'Khách',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

void _noop() {}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.radius, required this.onCameraTap});

  final double radius;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    return SizedBox(
      width: size + 10,
      height: size + 10,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Container(
              width: size + 10,
              height: size + 10,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/placeholder.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 6,
              shadowColor: Colors.black.withValues(alpha: 0.18),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onCameraTap,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    IconsaxPlusLinear.camera,
                    size: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: Colors.grey[900],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(children: children),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.grey[900],
        ),
      ),
      trailing: Icon(IconsaxPlusLinear.arrow_right_3, color: Colors.grey[500]),
    );
  }
}

class _RelativeEmptyCard extends StatelessWidget {
  const _RelativeEmptyCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 140,
            height: 92,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              IconsaxPlusLinear.folder_add,
              size: 48,
              color: AppTheme.primaryColor.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: 170,
            child: ElevatedButton(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.90),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text('THÊM HỒ SƠ'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessengerButton extends StatelessWidget {
  const _MessengerButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Image.asset(
              'assets/images/ic_messenger.png',
              fit: BoxFit.contain,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
