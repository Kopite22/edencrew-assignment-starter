import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:edencrew_assignment_starter/core/widgets/app_toast.dart';
import 'package:edencrew_assignment_starter/core/widgets/stock_name_info.dart';
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
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                context.push('/stock/${stock.code}');
              },
              child: Row(
                spacing: dimens.space3,
                children: [
                  Expanded(
                    child: StockNameInfo(
                      stock: stock,
                      keyword: keyword,
                      highlightKeyword: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              final notifier = ref.read(favoriteStocksProvider.notifier);

              if (isInterested) {
                notifier.remove(stock.code);

                AppToast.show(
                  context,
                  message: '관심이 해제되었습니다.',
                  icon: SvgPicture.asset(
                    'assets/icons/ico_star.svg',
                    width: 18,
                    height: 18,
                  ),
                );
              } else {
                notifier.add(
                  FavoriteStock(
                    code: stock.code,
                    name: stock.name,
                    typeName: stock.typeName,
                  ),
                );

                AppToast.show(
                  context,
                  message: '관심이 등록되었습니다.',
                  icon: SvgPicture.asset(
                    'assets/icons/ico_starFill.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      colors.favoriteActive,
                      BlendMode.srcIn,
                    ),
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
}
