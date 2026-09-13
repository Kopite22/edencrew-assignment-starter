// features/stock/data/models/stock_search_response.dart

class StockSearchResponse {
  const StockSearchResponse({required this.items});

  final List<StockSearchItem> items;

  factory StockSearchResponse.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? [])
        .map((item) => StockSearchItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return StockSearchResponse(items: items);
  }
}

class StockSearchItem {
  const StockSearchItem({
    required this.code,
    required this.name,
    required this.typeCode,
    required this.typeName,
    required this.url,
    required this.nationCode,
    required this.category,
  });

  final String code;
  final String name;
  final String typeCode;
  final String typeName;
  final String url;
  final String nationCode;
  final String category;

  factory StockSearchItem.fromJson(Map<String, dynamic> json) {
    return StockSearchItem(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      typeCode: json['typeCode'] as String? ?? '',
      typeName: json['typeName'] as String? ?? '',
      url: json['url'] as String? ?? '',
      nationCode: json['nationCode'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
}
