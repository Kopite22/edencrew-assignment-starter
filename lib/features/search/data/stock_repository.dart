// features/stock/data/stock_repository.dart

import 'package:dio/dio.dart';

import '../models/stock.dart';
import 'package:edencrew_assignment_starter/features/search/models/stock_search_response.dart';

class StockRepository {
  const StockRepository(this._dio);

  final Dio _dio;

  Future<List<Stock>> searchStocks(String query) async {
    final response = await _dio.get(
      'https://ac.stock.naver.com/ac',
      queryParameters: {
        'q': query,
        'target': 'stock,ipo,index,marketindicator',
      },
    );

    final result = StockSearchResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    return result.items.where(_isDomesticStock).map(_toStock).toList();
  }

  bool _isDomesticStock(StockSearchItem item) {
    return item.nationCode == 'KOR' && RegExp(r'^\d{6}$').hasMatch(item.code);
  }

  Stock _toStock(StockSearchItem item) {
    return Stock(
      id: 'domestic:${item.code}',
      code: item.code,
      name: item.name,
      typeName: item.typeName,
    );
  }
}
