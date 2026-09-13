import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:edencrew_assignment_starter/shared/utils/number_formatter.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/features/favorite/models/stock_price.dart';
import 'package:edencrew_assignment_starter/shared/widgets/price_change.dart';

class FavoriteStockItem extends StatelessWidget {
  final String name;
  final String code;
  final String typeName;
  final StockPrice? stock;
  final bool isLoading;

  const FavoriteStockItem({
    super.key,
    required this.name,
    required this.code,
    required this.stock,
    required this.typeName,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    return InkWell(
      onTap: () {
        context.push('/stock/$code');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dimens.space4,
          vertical: dimens.space3,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colors.borderSubtle, width: 1),
          ),
        ),
        child: Row(
          spacing: dimens.space3,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                  Text(
                    '$code · $typeName',
                    style: TextStyle(color: colors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 2,
              children: isLoading || stock == null
                  ? [
                      Container(
                        width: 64,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors.feedbackSkeleton,
                          borderRadius: BorderRadius.circular(dimens.radiusSm),
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors.feedbackSkeleton,
                          borderRadius: BorderRadius.circular(dimens.radiusSm),
                        ),
                      ),
                    ]
                  : [
                      Text(
                        numberFormatter.format(stock!.nv),
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: AppTypography.medium,
                        ),
                      ),

                      PriceChange(
                        currentPrice: stock!.nv,
                        previousPrice: stock!.pcv,
                      ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
