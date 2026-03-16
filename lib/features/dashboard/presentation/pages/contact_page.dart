import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../../core/utils/constant.dart';
import '../../../../core/theme/app_theme.dart';

class ContactPage extends ConsumerStatefulWidget {
  static const path = '/contact';
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  bool _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) return;
    _opened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _showContactSheet(context);
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.shrink(),
    );
  }

  Future<void> _showContactSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withValues(alpha: 0.22),
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              14.verticalSpace,
              Text(
                'Liên hệ',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[900],
                ),
              ),
              16.verticalSpace,
              _ContactTile(
                icon: IconsaxPlusLinear.call,
                iconBg: AppTheme.primaryColor.withValues(alpha: 0.12),
                iconColor: AppTheme.primaryColor,
                title: _formatPhone(HOT_LINE_1),
                subtitle: 'Hotline 1',
                actionText: 'Gọi',
                onTap: () => _call(HOT_LINE_1),
              ),
              _ContactTile(
                icon: IconsaxPlusLinear.call,
                iconBg: AppTheme.primaryColor.withValues(alpha: 0.12),
                iconColor: AppTheme.primaryColor,
                title: _formatPhone(HOT_LINE_2),
                subtitle: 'Hotline 2',
                actionText: 'Gọi',
                onTap: () => _call(HOT_LINE_2),
              ),
              10.verticalSpace,
              _ContactTile(
                icon: IconsaxPlusLinear.messages_2,
                iconBg: const Color(0xFFEAF2FF),
                iconColor: const Color(0xFF1877F2),
                title: 'Messenger',
                subtitle: 'Hỗ trợ trực tuyến',
                actionText: 'Mở',
                onTap: _openMessenger,
              ),
              _ContactTile(
                icon: IconsaxPlusLinear.location,
                iconBg: const Color(0xFFE8F7F5),
                iconColor: const Color(0xFF26A69A),
                title: 'Bản đồ',
                subtitle:
                    '124 P. Nguyễn Đức Cảnh, Cát Dài, Lê Chân, Hải Phòng, Việt Nam',
                actionText: 'Chỉ đường',
                onTap: _openMaps,
              ),
              10.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  String _formatPhone(String digits) {
    if (digits.length == 11) {
      return '${digits.substring(0, 4)}-${digits.substring(4, 8)} ${digits.substring(8)}';
    }
    return digits;
  }

  Future<void> _call(String digits) async {
    final uri = Uri.parse('tel:$digits');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openMessenger() async {
    await launchUrl(
      Uri.parse(MESSENGER_SUPPORT_URL),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _openMaps() async {
    const query =
        '124 P. Nguyễn Đức Cảnh, Cát Dài, Lê Chân, Hải Phòng, Việt Nam';
    final encoded = Uri.encodeComponent(query);

    final geo = Uri.parse('geo:0,0?q=$encoded');
    if (await canLaunchUrl(geo)) {
      await launchUrl(geo, mode: LaunchMode.externalApplication);
      return;
    }

    await launchUrl(
      Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded'),
      mode: LaunchMode.externalApplication,
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        trailing: TextButton(onPressed: onTap, child: Text(actionText)),
      ),
    );
  }
}
