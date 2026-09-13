import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

import '../models/stock_daily_price.dart';

class StockDailyPriceApi {
  const StockDailyPriceApi(this._dio);

  final Dio _dio;

  static const String _url = 'https://finance.naver.com/item/sise_day.naver';

  Future<DailyPricePage> fetchDailyPrices({
    required String stockCode,
    required int page,
  }) async {
    final response = await _dio.get<List<int>>(
      _url,
      queryParameters: {'code': stockCode, 'page': page},
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
              'AppleWebKit/537.36 (KHTML, like Gecko) '
              'Chrome/140.0.0.0 Safari/537.36',
        },
      ),
    );

    final bytes = response.data;

    if (bytes == null || bytes.isEmpty) {
      throw Exception('일별 시세 응답이 비어있습니다.');
    }

    final html = await _decodeHtml(bytes);
    final document = html_parser.parse(html);

    final table = _findDailyPriceTable(document);

    if (table == null) {
      throw Exception('일별 시세 테이블을 찾을 수 없습니다.');
    }

    final prices = <DailyPrice>[];

    for (final row in table.querySelectorAll('tr')) {
      final cells = row.querySelectorAll('td');

      if (cells.length < 7) {
        continue;
      }

      final dateText = cells[0].text.trim();

      if (!_isDate(dateText)) {
        continue;
      }

      prices.add(
        DailyPrice(
          localDate: _normalizeDate(dateText),
          closePrice: _parseNumber(cells[1].text),
          openPrice: _parseNumber(cells[3].text),
          highPrice: _parseNumber(cells[4].text),
          lowPrice: _parseNumber(cells[5].text),
          accumulatedTradingVolume: _parseNumber(cells[6].text),
        ),
      );
    }

    return DailyPricePage(
      prices: prices,
      lastPage: _parseLastPage(document),
      page: page,
    );
  }

  Future<String> _decodeHtml(List<int> bytes) {
    return CharsetConverter.decode('euc-kr', Uint8List.fromList(bytes));
  }

  Element? _findDailyPriceTable(Document document) {
    for (final table in document.querySelectorAll('table')) {
      for (final row in table.querySelectorAll('tr')) {
        final cells = row.querySelectorAll('td');

        if (cells.length < 7) {
          continue;
        }

        if (_isDate(cells[0].text.trim())) {
          return table;
        }
      }
    }

    return null;
  }

  bool _isDate(String value) {
    return RegExp(r'^\d{4}\.\d{2}\.\d{2}$').hasMatch(value);
  }

  int _parseNumber(String value) {
    return int.tryParse(value.replaceAll(',', '').replaceAll(' ', '').trim()) ??
        0;
  }

  String _normalizeDate(String value) {
    final parts = value.trim().split('.');

    if (parts.length != 3) {
      throw FormatException('잘못된 날짜 형식입니다: $value');
    }

    return '${parts[0]}'
        '${parts[1].padLeft(2, '0')}'
        '${parts[2].padLeft(2, '0')}';
  }

  int _parseLastPage(Document document) {
    var lastPage = 1;

    for (final link in document.querySelectorAll('table.Nnavi a')) {
      final href = link.attributes['href'];

      if (href == null) {
        continue;
      }

      final match = RegExp(r'[?&]page=(\d+)').firstMatch(href);

      if (match == null) {
        continue;
      }

      final page = int.tryParse(match.group(1)!);

      if (page != null && page > lastPage) {
        lastPage = page;
      }
    }

    return lastPage;
  }
}

class DailyPricePage {
  const DailyPricePage({
    required this.prices,
    required this.lastPage,
    required this.page,
  });

  final List<DailyPrice> prices;
  final int lastPage;
  final int page;
}
