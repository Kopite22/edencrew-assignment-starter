import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    required Widget icon,
  }) {
    final colors = context.colors;
    final dimens = context.dimens;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.symmetric(
            horizontal: dimens.space4,
            vertical: dimens.space3,
          ),
          padding: EdgeInsets.zero,
          duration: const Duration(seconds: 2),
          content: Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimens.space4,
              vertical: dimens.space3,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceOverlay,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: dimens.space2,
              children: [
                icon,
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 13,
                      height: 18 / 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
