import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/features/favorite/models/sort_type.dart';

class SortBottomSheet extends StatelessWidget {
  final SortType selectedSort;

  const SortBottomSheet({super.key, required this.selectedSort});

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dimens.space3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 0,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimens.space5,
                vertical: 10,
              ),
              child: Text(
                '정렬',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: AppTypography.bold,
                  fontSize: 19,
                ),
              ),
            ),
            ...SortType.values.map((sortType) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: dimens.space6),
                title: Text(
                  sortType.label,
                  style: TextStyle(
                    color: selectedSort == sortType
                        ? colors.textPrimary
                        : colors.textSecondary,
                    fontSize: 15,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                trailing: selectedSort == sortType ? Icon(Icons.check) : null,
                onTap: () {
                  Navigator.pop(context, sortType);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
