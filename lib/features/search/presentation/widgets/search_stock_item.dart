import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:edencrew_assignment_starter/features/favorite/models/favorite_stock.dart';
import 'package:edencrew_assignment_starter/features/favorite/providers/favorite_stocks_provider.dart';
import 'package:edencrew_assignment_starter/features/search/models/stock.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class SearchStockItem extends ConsumerWidget {
  final Stock stock;
  final String keyword;

  const SearchStockItem({super.key, required this.stock, this.keyword = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final interests = ref.watch(favoriteStocksProvider);

    final isInterested = interests.maybeWhen(
      data: (stocks) {
        return stocks.any((favorite) => favorite.code == stock.code);
      },
      orElse: () => false,
    );

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: dimens.space3,
        children: [
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHighlightedTitle(colors),
                Text(
                  '${stock.code} · ${stock.typeName}',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 11,
                    height: 14 / 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              final notifier = ref.read(favoriteStocksProvider.notifier);

              if (isInterested) {
                // 관심 해제
                notifier.remove(stock.code);
              } else {
                // 관심 등록
                notifier.add(
                  FavoriteStock(
                    code: stock.code,
                    name: stock.name,
                    typeName: stock.typeName,
                  ),
                );
              }
            },
            icon: SvgPicture.asset(
              isInterested
                  ? 'assets/icons/ico_starFill.svg'
                  : 'assets/icons/ico_star.svg',
              width: 22,
              height: 22,
              colorFilter: isInterested
                  ? ColorFilter.mode(colors.favoriteActive, BlendMode.srcIn)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedTitle(AppColors colors) {
    final style = TextStyle(
      color: colors.textPrimary,
      fontSize: 15,
      fontWeight: AppTypography.medium,
      height: 20 / 15,
      letterSpacing: -0.1,
    );

    if (keyword.isEmpty) {
      return Text(stock.name, style: style);
    }

    final index = stock.name.toLowerCase().indexOf(keyword.toLowerCase());

    if (index == -1) {
      return Text(stock.name, style: style);
    }

    final matchedEnd = index + keyword.length;

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: stock.name.substring(0, index)),
          TextSpan(
            text: stock.name.substring(index, matchedEnd),
            style: style.copyWith(color: colors.accentDefault),
          ),
          TextSpan(text: stock.name.substring(matchedEnd)),
        ],
      ),
    );
  }
}
