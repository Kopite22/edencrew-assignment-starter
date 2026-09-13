import 'dart:async';

import 'package:edencrew_assignment_starter/features/search/presentation/widgets/search_stock_item.dart';
import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/core/network/dio_client.dart';
import 'package:edencrew_assignment_starter/features/search/data/stock_repository.dart';
import 'package:edencrew_assignment_starter/features/search/models/stock.dart';
import 'package:edencrew_assignment_starter/features/search/presentation/widgets/search_app_bar.dart';
import 'package:edencrew_assignment_starter/core/widgets/empty_content.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  late final StockRepository _stockRepository;

  Timer? _debounce;

  List<Stock> _results = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _stockRepository = StockRepository(DioClient.instance.dio);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    final keyword = value.trim();

    if (keyword.isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });

      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 300),
      () => _searchStocks(keyword),
    );
  }

  Future<void> _searchStocks(String keyword) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _stockRepository.searchStocks(keyword);

      if (!mounted) return;

      setState(() {
        _results = results;
      });
    } catch (e) {
      if (!mounted) return;

      debugPrint('종목 검색 실패: $e');

      setState(() {
        _results = [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onClear() {
    _debounce?.cancel();

    _searchController.clear();

    setState(() {
      _results = [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyword = _searchController.text.trim();

    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (keyword.isEmpty) {
      content = EmptyContent(
        icon: SvgPicture.asset(
          'assets/icons/ico_search.svg',
          width: 40,
          height: 40,
        ),
        title: '종목을 검색해 보세요',
        description: '종목명 또는 종목코드 6자리로\n검색하실 수 있습니다.',
      );
    } else if (_results.isEmpty) {
      content = EmptyContent(
        icon: SvgPicture.asset(
          'assets/icons/ico_search_empty.svg',
          width: 40,
          height: 40,
        ),
        title: '검색 결과가 없습니다',
        description: '$keyword와\n일치하는 검색 결과를 찾지 못했습니다.',
      );
    } else {
      content = ListView.builder(
        itemCount: _results.length,
        itemBuilder: (context, index) {
          final stock = _results[index];

          return SearchStockItem(stock: stock, keyword: keyword);
        },
      );
    }

    return Scaffold(
      appBar: SearchAppBar(
        controller: _searchController,
        onChanged: _onChanged,
        onClear: _onClear,
      ),
      body: SafeArea(child: content),
    );
  }
}
