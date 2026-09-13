import 'package:flutter/material.dart';

class StockDetailScreen extends StatelessWidget {
  const StockDetailScreen({super.key, required this.stockCode});

  final String stockCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(stockCode)),
      body: Center(child: Text('$stockCode 종목 상세 화면')),
    );
  }
}
