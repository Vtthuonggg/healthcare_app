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
      primaryColor: const Color(0xFF6FCF97),
      secondaryColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      toastAlignment: Alignment.topCenter,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: false,
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
      primaryColor: const Color(0xFFEB5758),
      secondaryColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      toastAlignment: Alignment.topCenter,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: false,
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
      primaryColor: const Color(0xFFF2C94C),
      secondaryColor: Colors.white,

      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      toastAlignment: Alignment.topCenter,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: false,
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
      primaryColor: const Color(0xFF3081ED),
      secondaryColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 8,
      ),
      description: Text(message, style: const TextStyle(color: Colors.white)),
      toastAlignment: Alignment.topCenter,
      animationType: AnimationType.slideInFromTop,
      toastDuration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      width: 350,
      height: 80,
      dismissable: true,
      displaySideBar: false,
      borderRadius: 12,
    ).show(context);
  }
}
