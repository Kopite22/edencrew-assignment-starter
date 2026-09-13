// features/stock/models/stock.dart

class Stock {
  const Stock({
    required this.id,
    required this.code,
    required this.name,
    required this.typeName,
  });

  final String id;
  final String code;
  final String name;
  final String typeName;
}
