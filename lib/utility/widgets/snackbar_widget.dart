import 'package:echo_note/utility/constants.dart';
import 'package:flutter/material.dart';

class SnackBarWidget {
  final BuildContext context;
  final String label;
  final Color color;
  const SnackBarWidget({
    required this.context,
    required this.label,
    required this.color,
  });
  void show() {
    final hide = ScaffoldMessenger.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Okay!',
          textColor: AppColors.primary,
          onPressed: () {
            hide.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
