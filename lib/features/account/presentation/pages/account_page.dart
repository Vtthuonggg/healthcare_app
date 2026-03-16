import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/core/utils/constant.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../auth/domain/models/user.dart';
import '../../../../core/theme/app_theme.dart';

class AccountPage extends ConsumerStatefulWidget {
  static const path = '/account';
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _isChangeBackground = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 450 && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (_scrollController.offset <= 450 && _isCollapsed) {
        setState(() => _isCollapsed = false);
      }
      if (_scrollController.offset > 50 && !_isChangeBackground) {
        setState(() => _isChangeBackground = true);
      } else if (_scrollController.offset <= 50 && _isChangeBackground) {
        setState(() => _isChangeBackground = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    final AuthState authState = ref.watch(authProvider);
    final user = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: _AccountHeader(user: user)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (user == null) ...[
                    _LoginPromptCard(
                      onLogin: () => context.push(LoginPage.path),
                    ),
                    16.verticalSpace,
                  ],
                  ..._buildSections(context, isLoggedIn: user != null),
                  28.verticalSpace,
                  const _AccountFooter(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(
    BuildContext context, {
    required bool isLoggedIn,
  }) {
    final sections = <_AccountSection>[
      _AccountSection(
        title: 'Quản lý yêu cầu và ưu đãi',
        items: const [
          _AccountItem(
            icon: IconsaxPlusLinear.box,
            iconBg: Color(0xFFFFF1DF),
            iconColor: Color(0xFFF7A534),
            title: 'Yêu cầu giao thuốc',
          ),
          _AccountItem(
            icon: IconsaxPlusLinear.support,
            iconBg: Color(0xFFE8F7F5),
            iconColor: Color(0xFF26A69A),
            title: 'Yêu cầu hỗ trợ CSKH',
          ),
          _AccountItem(
            icon: IconsaxPlusLinear.ticket,
            iconBg: Color(0xFFFFEEE8),
            iconColor: Color(0xFFFF7043),
            title: 'Ưu đãi của tôi',
          ),
        ],
      ),
      _AccountSection(
        title: 'Cài đặt',
        items: const [
          _AccountItem(
            icon: IconsaxPlusLinear.lock,
            iconBg: Color(0xFFE8F7F5),
            iconColor: Color(0xFF26A69A),
            title: 'Đổi mật khẩu',
          ),
          _AccountItem(
            icon: IconsaxPlusLinear.global,
            iconBg: Color(0xFFFFEDEE),
            iconColor: Color(0xFFEF5350),
            title: 'Ngôn ngữ',
            trailingText: 'Tiếng Việt',
          ),
          _AccountItem(
            icon: IconsaxPlusLinear.shield_tick,
            iconBg: Color(0xFFEAF2FF),
            iconColor: Color(0xFF3B82F6),
            title: 'Bảo mật',
            trailingText: 'Chưa thiết lập',
          ),
        ],
      ),
      _AccountSection(
        title: 'Điều khoản & quy định',
        items: const [
          _AccountItem(
            icon: IconsaxPlusLinear.document_text,
            iconBg: Color(0xFFEAF2FF),
            iconColor: Color(0xFF3B82F6),
            title: 'Quy định sử dụng',
          ),
          _AccountItem(
            icon: IconsaxPlusLinear.warning_2,
            iconBg: Color(0xFFE6F7FF),
            iconColor: Color(0xFF38BDF8),
            title: 'Chính sách giải quyết khiếu nại, tranh chấp',
          ),
          _AccountItem(
            icon: IconsaxPlusLinear.security_safe,
            iconBg: Color(0xFFFFEDEE),
            iconColor: Color(0xFFEF4444),
            title: 'Chính sách bảo vệ dữ liệu cá nhân',
          ),
        ],
      ),
      _AccountSection(
        title: '',
        items: const [
          _AccountItem(
            icon: IconsaxPlusLinear.info_circle,
            iconBg: Color(0xFFF1F5F9),
            iconColor: Color(0xFF64748B),
            title: 'Hỏi đáp về ứng dụng',
          ),
          _AccountItem(
            icon: IconsaxPlusLinear.share,
            iconBg: Color(0xFFFFF1DF),
            iconColor: Color(0xFFF59E0B),
            title: 'Chia sẻ ứng dụng',
          ),
        ],
      ),
      if (isLoggedIn)
        _AccountSection(
          title: '',
          items: const [
            _AccountItem(
              icon: IconsaxPlusLinear.logout_1,
              iconBg: Color(0xFFFFEDEE),
              iconColor: Color(0xFFEF4444),
              title: 'Đăng xuất',
            ),
          ],
        ),
    ];

    return sections
        .expand(
          (section) => [
            if (section.title.isNotEmpty) ...[
              Text(
                section.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              12.verticalSpace,
            ] else ...[
              8.verticalSpace,
            ],
            _AccountSectionCard(section: section),
            18.verticalSpace,
          ],
        )
        .toList();
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    final fullName = user?.fullName ?? '';
    final name = fullName.trim().isEmpty ? 'Khách' : fullName;
    final subtitle = user?.department?.name ?? user?.role?.roleName ?? ' ';

    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          ClipPath(
            clipper: _HeaderClipper(),
            child: SizedBox(height: 230, width: double.infinity),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 34),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.grey[200],
                          child: Icon(
                            IconsaxPlusLinear.profile_circle,
                            size: 54,
                            color: AppTheme.primaryColor.withValues(alpha: 0.9),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              IconsaxPlusLinear.camera,
                              size: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    6.verticalSpace,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 70);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height,
      size.width,
      size.height - 70,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LoginPromptCard extends StatelessWidget {
  const _LoginPromptCard({required this.onLogin});
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Bạn đang ở chế độ Khách.\nĐăng nhập để sử dụng đầy đủ tính năng.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.35,
                color: Colors.grey[800],
              ),
            ),
          ),
          12.horizontalSpace,
          ElevatedButton(onPressed: onLogin, child: const Text('Đăng nhập')),
        ],
      ),
    );
  }
}

class _AccountSectionCard extends StatelessWidget {
  const _AccountSectionCard({required this.section});
  final _AccountSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < section.items.length; i++) ...[
            _AccountItemTile(item: section.items[i]),
            if (i != section.items.length - 1)
              Divider(height: 1, color: Colors.grey[100]),
          ],
        ],
      ),
    );
  }
}

class _AccountItemTile extends StatelessWidget {
  const _AccountItemTile({required this.item});
  final _AccountItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      onTap: () {},
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: item.iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(item.icon, color: item.iconColor),
      ),
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.grey[900],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.trailingText != null) ...[
            Text(
              item.trailingText!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
            6.horizontalSpace,
          ],
          Icon(IconsaxPlusLinear.arrow_right_3, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

class _AccountFooter extends StatefulWidget {
  const _AccountFooter();

  @override
  State<_AccountFooter> createState() => _AccountFooterState();
}

class _AccountFooterState extends State<_AccountFooter> {
  late final TapGestureRecognizer _phone1Recognizer;
  late final TapGestureRecognizer _phone2Recognizer;

  @override
  void initState() {
    super.initState();
    _phone1Recognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(Uri.parse('tel:$HOT_LINE_1'));
    _phone2Recognizer = TapGestureRecognizer()
      ..onTap = () => launchUrl(Uri.parse('tel:$HOT_LINE_2'));
  }

  @override
  void dispose() {
    _phone1Recognizer.dispose();
    _phone2Recognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500], height: 1.35);
    final linkStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: AppTheme.primaryColor,
      fontWeight: FontWeight.w600,
      height: 1.35,
    );

    return Column(
      children: [
        Text(
          'BỆNH VIỆN ĐA KHOA QUỐC TẾ HẢI PHÒNG\n124 Nguyễn Đức Cảnh, Cát Dài Q Lê Chân, Hải Phòng',
          style: baseStyle,
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Text(
          'dakhoaquocte.hih@gmail.com',
          style: baseStyle,
          textAlign: TextAlign.center,
        ),
        6.verticalSpace,
        Text.rich(
          TextSpan(
            style: baseStyle,
            children: [
              TextSpan(
                text: '0225-3955 888',
                style: linkStyle,
                recognizer: _phone1Recognizer,
              ),
              const TextSpan(text: '  |  '),
              TextSpan(
                text: '0225-3951 115',
                style: linkStyle,
                recognizer: _phone2Recognizer,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AccountSection {
  const _AccountSection({required this.title, required this.items});
  final String title;
  final List<_AccountItem> items;
}

class _AccountItem {
  const _AccountItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.trailingText,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? trailingText;
}
