import 'package:flutter/material.dart';
import 'package:health_icons/health_icons.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/theme/app_theme.dart';

class FeatureTable extends StatelessWidget {
  const FeatureTable({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureItem(
        icon: HealthIcons.iScheduleSchoolDateTimeFilled,
        label: 'Lịch hẹn',
        onTap: () {
          // TODO: Navigate to appointments
        },
      ),
      _FeatureItem(
        icon: IconsaxPlusLinear.call,
        label: 'Liên hệ',
        onTap: () {
          // TODO: Navigate to contact
        },
      ),
      _FeatureItem(
        icon: IconsaxPlusLinear.messages_2,
        label: 'Cộng đồng hỏi đáp',
        onTap: () {
          // TODO: Navigate to community
        },
      ),
      _FeatureItem(
        icon: HealthIcons.syringeOutline,
        label: 'Sổ tiêm',
        onTap: () {
          // TODO: Navigate to vaccination book
        },
      ),
      _FeatureItem(
        icon: HealthIcons.womanOutline,
        label: 'Cẩm nang làm mẹ',
        onTap: () {
          // TODO: Navigate to mother guide
        },
      ),
      _FeatureItem(
        icon: HealthIcons.healthVulnerabilityThroughSocialDeterminantsFilled,
        label: 'Tư vấn sức khoẻ từ xa',
        onTap: () {
          // TODO: Navigate to telemedicine
        },
      ),
      _FeatureItem(
        icon: HealthIcons.blisterPillsOvalX14Outline,
        label: 'Đơn thuốc',
        onTap: () {
          // TODO: Navigate to prescriptions
        },
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: feature.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    feature.icon,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: Text(
                    feature.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff262A37),
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _FeatureItem({required this.icon, required this.label, required this.onTap});
}
