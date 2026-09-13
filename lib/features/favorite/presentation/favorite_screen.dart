import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

import 'package:edencrew_assignment_starter/features/favorite/models/favorite_stock.dart';
import 'package:edencrew_assignment_starter/features/favorite/models/sort_type.dart';
import 'package:edencrew_assignment_starter/features/favorite/models/stock_price.dart';
import 'package:edencrew_assignment_starter/features/favorite/presentation/widgets/favorite_app_bar.dart';
import 'package:edencrew_assignment_starter/features/favorite/presentation/widgets/favorite_stock_item.dart';
import 'package:edencrew_assignment_starter/features/favorite/providers/favorite_stocks_provider.dart';
import 'package:edencrew_assignment_starter/core/widgets/empty_content.dart';

import 'widgets/favorite_refresh_indicator.dart';
import 'widgets/sort_bottom_sheet.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  SortType _sortType = SortType.name;

  Future<void> _showSortBottomSheet() async {
    final colors = context.colors;

    final result = await showModalBottomSheet<SortType>(
      context: context,
      useRootNavigator: true,
      backgroundColor: colors.surfaceOverlay,
      builder: (_) {
        return SortBottomSheet(selectedSort: _sortType);
      },
    );

    if (result == null) return;

    setState(() {
      _sortType = result;
    });
  }

  Future<void> _refreshPrices() async {
    ref.invalidate(stockPricesProvider);

    await ref.read(stockPricesProvider.future);
  }

  List<FavoriteStock> _sortStocks(
    List<FavoriteStock> stocks,
    Map<String, StockPrice> priceMap,
  ) {
    final sorted = [...stocks];

    switch (_sortType) {
      case SortType.currentPrice:
        sorted.sort((a, b) {
          final priceA = priceMap[a.code]?.nv ?? 0;
          final priceB = priceMap[b.code]?.nv ?? 0;

          return priceB.compareTo(priceA);
        });

      case SortType.changeRate:
        sorted.sort((a, b) {
          final rateA = priceMap[a.code]?.changeRate ?? 0;
          final rateB = priceMap[b.code]?.changeRate ?? 0;

          return rateB.compareTo(rateA);
        });

      case SortType.name:
        sorted.sort((a, b) {
          return a.name.compareTo(b.name);
        });
    }

    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    final favorites = ref.watch(favoriteStocksProvider);
    final prices = ref.watch(stockPricesProvider);

    return Scaffold(
      appBar: FavoriteAppBar(
        sortType: _sortType,
        onSortTap: _showSortBottomSheet,
        onRefreshTap: _refreshPrices,
        isRefreshing: prices.isLoading,
      ),
      body: SafeArea(
        child: favorites.when(
          loading: () {
            return Center(
              child: CircularProgressIndicator(color: colors.textSecondary),
            );
          },

          error: (error, stack) {
            return const Center(child: Text('관심 종목을 불러오지 못했습니다.'));
          },

          data: (stocks) {
            if (stocks.isEmpty) {
              return EmptyContent(
                icon: SvgPicture.asset(
                  'assets/icons/ico_star.svg',
                  width: 40,
                  height: 40,
                ),
                title: '관심 종목이 없습니다',
                description: '검색 탭에서 종목을 찾아\n별 아이콘을 눌러 추가해 주세요.',
              );
            }

            return FavoriteRefreshIndicator(
              onRefresh: _refreshPrices,
              child: prices.when(
                loading: () {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      final favorite = stocks[index];

                      return FavoriteStockItem(
                        name: favorite.name,
                        code: favorite.code,
                        typeName: favorite.typeName,
                        stock: null,
                        isLoading: true,
                      );
                    },
                  );
                },

                error: (error, stack) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(
                        height: 300,
                        child: Center(child: Text('시세를 불러오지 못했습니다.')),
                      ),
                    ],
                  );
                },

                data: (priceMap) {
                  final sortedStocks = _sortStocks(stocks, priceMap);

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: sortedStocks.length,
                    itemBuilder: (context, index) {
                      final favorite = sortedStocks[index];

                      final price = priceMap[favorite.code];

                      return FavoriteStockItem(
                        name: favorite.name,
                        code: favorite.code,
                        stock: price,
                        isLoading: price == null,
                        typeName: favorite.typeName,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
