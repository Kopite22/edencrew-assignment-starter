import 'package:dio/dio.dart';

import 'models/stock_metadata.dart';

class StockMetadataApi {
  const StockMetadataApi(this._dio);

  final Dio _dio;

  Future<StockMetadata> getStockMetadata(String symbol) async {
    final response = await _dio.get(
      'https://stock.naver.com/api/securityFe/api/fchart/domestic/stock/$symbol',
    );

    return StockMetadata.fromJson(response.data as Map<String, dynamic>);
  }
}
