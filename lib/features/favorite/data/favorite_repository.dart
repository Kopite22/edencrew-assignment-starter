import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/stock_price.dart';

class FavoriteRepository {
  const FavoriteRepository(this._dio);

  final Dio _dio;

  Future<Map<String, StockPrice>> getStockPrices(List<String> codes) async {
    if (codes.isEmpty) {
      return {};
    }

    final response = await _dio.get(
      'https://polling.finance.naver.com/api/realtime',
      queryParameters: {'query': 'SERVICE_ITEM:${codes.join(',')}'},
    );

    final data = jsonDecode(response.data as String) as Map<String, dynamic>;

    final items = data['result']['areas'][0]['datas'] as List<dynamic>;

    final stockPrices = items.map((item) {
      final json = item as Map<String, dynamic>;

      return StockPrice.fromJson(json);
    }).toList();

    return {for (final stockPrice in stockPrices) stockPrice.cd: stockPrice};
  }
}
