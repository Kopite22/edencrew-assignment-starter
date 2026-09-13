import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/features/search/models/stock.dart';
import 'package:edencrew_assignment_starter/theme/theme.dart';

class StockNameInfo extends StatelessWidget {
  final Stock stock;

  final String? keyword;
  final bool highlightKeyword;

  const StockNameInfo({
    super.key,
    required this.stock,
    this.keyword,
    this.highlightKeyword = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      spacing: 2,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStockName(colors),
        Text(
          '${stock.code} · ${stock.typeName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 11,
            height: 14 / 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStockName(AppColors colors) {
    final style = TextStyle(
      color: colors.textPrimary,
      fontSize: 15,
      fontWeight: AppTypography.medium,
      height: 20 / 15,
      letterSpacing: -0.1,
    );

    if (!highlightKeyword || keyword == null || keyword!.isEmpty) {
      return Text(
        stock.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final searchKeyword = keyword!;
    final index = stock.name.toLowerCase().indexOf(searchKeyword.toLowerCase());

    if (index == -1) {
      return Text(
        stock.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final matchedEnd = index + searchKeyword.length;

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: stock.name.substring(0, index)),
          TextSpan(
            text: stock.name.substring(index, matchedEnd),
            style: style.copyWith(color: colors.accentDefault),
          ),
          TextSpan(text: stock.name.substring(matchedEnd)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
