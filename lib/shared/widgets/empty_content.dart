import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final Widget icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: dimens.space3,
        children: [
          icon,
          Text(
            title,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 19,
              fontWeight: AppTypography.bold,
            ),
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
