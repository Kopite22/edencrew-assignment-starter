import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/features/favorite/models/sort_type.dart';

class FavoriteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SortType sortType;
  final VoidCallback onSortTap;
  final VoidCallback onRefreshTap;
  final bool isRefreshing;

  const FavoriteAppBar({
    super.key,
    required this.sortType,
    required this.onSortTap,
    required this.onRefreshTap,
    required this.isRefreshing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        '관심',
        style: TextStyle(
          color: colors.textPrimary,
          fontSize: 22,
          fontWeight: AppTypography.bold,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onSortTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 0,
              vertical: dimens.space1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sortType.label,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontWeight: AppTypography.bold,
                  fontSize: 13,
                ),
              ),
              SvgPicture.asset('assets/icons/ico_align.svg'),
            ],
          ),
        ),

        IconButton(
          onPressed: isRefreshing ? null : onRefreshTap,
          icon: isRefreshing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : SvgPicture.asset(
                  'assets/icons/ico_refresh.svg',
                  width: 20,
                  height: 20,
                ),
        ),
      ],
    );
  }
}
