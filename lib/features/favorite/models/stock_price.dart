class StockPrice {
  final String cd;
  final int nv;
  final int pcv;
  final int ov;
  final int hv;
  final int lv;
  final int aq;
  final int countOfListedStock;

  const StockPrice({
    required this.cd,
    required this.nv,
    required this.pcv,
    required this.ov,
    required this.hv,
    required this.lv,
    required this.aq,
    required this.countOfListedStock,
  });

  /// 등락액
  int get change {
    return nv - pcv;
  }

  /// 등락률
  double get changeRate {
    if (pcv == 0) return 0;

    return (nv - pcv) / pcv;
  }

  /// 시가총액
  int get marketCap {
    return nv * countOfListedStock;
  }

  factory StockPrice.fromJson(Map<String, dynamic> json) {
    return StockPrice(
      cd: json['cd'] as String,
      nv: json['nv'] as int,
      pcv: json['pcv'] as int,
      ov: json['ov'] as int,
      hv: json['hv'] as int,
      lv: json['lv'] as int,
      aq: json['aq'] as int,
      countOfListedStock: json['countOfListedStock'] as int,
    );
  }
}
