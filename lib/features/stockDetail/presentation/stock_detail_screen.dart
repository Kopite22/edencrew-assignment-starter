import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:edencrew_assignment_starter/core/network/dio_client.dart';
import 'package:edencrew_assignment_starter/data/stock/models/stock_metadata.dart';
import 'package:edencrew_assignment_starter/data/stock/stock_metadata_api.dart';
import 'package:edencrew_assignment_starter/features/favorite/providers/favorite_stocks_provider.dart';
import 'package:edencrew_assignment_starter/features/stockDetail/presentation/widgets/stock_detail_app_bar.dart';

class StockDetailScreen extends ConsumerWidget {
  const StockDetailScreen({super.key, required this.stockCode});

  final String stockCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interests = ref.watch(favoriteStocksProvider);

    final isInterested =
        interests.value?.any((stock) => stock.code == stockCode) ?? false;

    final api = StockMetadataApi(DioClient.instance.dio);

    return FutureBuilder<StockMetadata>(
      future: api.getStockMetadata(stockCode),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('종목 정보를 불러오지 못했습니다.')),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final metadata = snapshot.data!;

        return Scaffold(
          appBar: StockDetailAppBar(
            stockName: metadata.stockName,
            symbolCode: metadata.symbolCode,
            stockExchangeNameKor: metadata.stockExchangeNameKor,
            isInterested: isInterested,
          ),
          body: const SizedBox(),
        );
      },
    );
  }
}
