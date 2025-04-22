import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';

class AppToasts {
   void showSuccess({
    required BuildContext context,
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      displayDuration: displayDuration,
    );
  }

   void showError({
    required BuildContext context,
    required String message,
    Duration displayDuration = const Duration(seconds: 4),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.error,
      iconColor: Colors.red,
      displayDuration: displayDuration,
    );
  }

   void showInfo({
    required BuildContext context,
    required String message,
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.info,
      iconColor: Colors.blue,
      displayDuration: displayDuration,
    );
  }

   void showWarning({
    required BuildContext context,
    required String message,
    Duration displayDuration = const Duration(seconds: 4),
  }) {
    _showToast(
      context: context,
      message: message,
      icon: Icons.warning,
      iconColor: Colors.orange,
      displayDuration: displayDuration,
    );
  }

  static void _showToast({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color iconColor,
    Duration displayDuration = const Duration(seconds: 3),
    DelightSnackbarPosition position = DelightSnackbarPosition.top,
  }) {
    DelightToastBar(
      autoDismiss: true,
      position: position,
      builder: (context) => ToastCard(
        leading: Icon(icon, color: iconColor),
        title: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => DelightToastBar.removeAll(),
        ),
      ),
    ).show(
      context,
      // duration: displayDuration,
    );
  }

  static void hideAllToasts() {
    DelightToastBar.removeAll();
  }
}