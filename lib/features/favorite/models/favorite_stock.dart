class FavoriteStock {
  final String code;
  final String name;
  final String typeName;

  const FavoriteStock({
    required this.code,
    required this.name,
    required this.typeName,
  });

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'typeName': typeName};
  }

  factory FavoriteStock.fromJson(Map<String, dynamic> json) {
    return FavoriteStock(
      code: json['code'] as String,
      name: json['name'] as String,
      typeName: json['typeName'] as String,
    );
  }
}
