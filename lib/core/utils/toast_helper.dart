import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class ToastHelper {
  static void success(
    BuildContext context, {
    required String message,
    String title = 'Thành công',
  }) {
    MotionToast(
      icon: IconsaxPlusLinear.tick_circle,
      primaryColor: const Color(0xFFE2F5EA),
      secondaryColor: const Color(0xFF6FCF97),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      description: Text(message, style: const TextStyle(color: Colors.black54)),
      toastAlignment: Alignment.topCenter,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: true,
      borderRadius: 12,
    ).show(context);
  }

  static void error(
    BuildContext context, {
    required String message,
    String title = 'Lỗi',
  }) {
    MotionToast(
      icon: IconsaxPlusLinear.info_circle,
      primaryColor: const Color(0xFFFBDDDD),
      secondaryColor: const Color(0xFFEB5758),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      description: Text(message, style: const TextStyle(color: Colors.black54)),
      toastAlignment: Alignment.topCenter,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: true,
      borderRadius: 12,
    ).show(context);
  }

  static void warning(
    BuildContext context, {
    required String message,
    String title = 'Cảnh báo',
  }) {
    MotionToast(
      icon: IconsaxPlusLinear.warning_2,
      primaryColor: const Color(0xFFFCF5DB),
      secondaryColor: const Color(0xFFF2C94C),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      description: Text(message, style: const TextStyle(color: Colors.black54)),
      toastAlignment: Alignment.topCenter,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: true,
      borderRadius: 12,
    ).show(context);
  }

  static void info(
    BuildContext context, {
    required String message,
    String title = 'Thông tin',
  }) {
    MotionToast(
      icon: IconsaxPlusLinear.info_circle,
      primaryColor: const Color(0xFFD4E6FB),
      secondaryColor: const Color(0xFF3081ED),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      description: Text(message, style: const TextStyle(color: Colors.black54)),
      toastAlignment: Alignment.topLeft,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 500),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: true,
      borderRadius: 12,
    ).show(context);
  }
}
