import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class FavoriteRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const FavoriteRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return RefreshIndicator(
      color: colors.textSecondary,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
