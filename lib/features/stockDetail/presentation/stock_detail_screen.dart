import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';
import 'package:edencrew_assignment_starter/core/network/dio_client.dart';
import 'package:edencrew_assignment_starter/data/stock/stock_metadata_api.dart';
import 'package:edencrew_assignment_starter/data/stock/models/stock_metadata.dart';
import 'package:edencrew_assignment_starter/features/favorite/providers/favorite_stocks_provider.dart';

class StockDetailScreen extends ConsumerWidget {
  const StockDetailScreen({super.key, required this.stockCode});

  final String stockCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColors colors = context.colors;
    final AppDimens dimens = context.dimens;

    final interests = ref.watch(favoriteStocksProvider);

    final isInterested =
        interests.value?.any((stock) => stock.code == stockCode) ?? false;

    final api = StockMetadataApi(DioClient.instance.dio);

    return Scaffold(
      appBar: AppBar(
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
        title: FutureBuilder<StockMetadata>(
          future: api.getStockMetadata(stockCode),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox.shrink();
            }

            if (!snapshot.hasData) {
              return const SizedBox(width: 80, height: 32);
            }

            final metadata = snapshot.data!;

            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    metadata.stockName,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: AppTypography.medium,
                      height: 20 / 15,
                    ),
                  ),
                  Text(
                    '${metadata.symbolCode} · ${metadata.stockExchangeNameKor}',
                    style: TextStyle(color: colors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            );
          },
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
      ),
      // ...
    );
  }
}
