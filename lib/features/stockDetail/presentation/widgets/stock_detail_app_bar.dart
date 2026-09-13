import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class StockDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StockDetailAppBar({
    super.key,
    required this.stockName,
    required this.symbolCode,
    required this.stockExchangeNameKor,
    required this.isInterested,
  });

  final String stockName;
  final String symbolCode;
  final String stockExchangeNameKor;
  final bool isInterested;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return AppBar(
      titleSpacing: 0,
      shape: Border(bottom: BorderSide(color: colors.borderSubtle, width: 1)),
      leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: SvgPicture.asset(
          'assets/icons/ico_back.svg',
          width: 20,
          height: 20,
        ),
      ),
      title: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              stockName,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
                fontWeight: AppTypography.medium,
                height: 20 / 15,
              ),
            ),
            Text(
              '$symbolCode · $stockExchangeNameKor',
              style: TextStyle(color: colors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: dimens.space4),
          child: SvgPicture.asset(
            isInterested
                ? 'assets/icons/ico_starFill.svg'
                : 'assets/icons/ico_star.svg',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              isInterested ? colors.favoriteActive : colors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}
