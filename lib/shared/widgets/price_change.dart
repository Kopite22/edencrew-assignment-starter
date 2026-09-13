import 'package:edencrew_assignment_starter/shared/utils/number_formatter.dart';
import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

class PriceChange extends StatelessWidget {
  final int currentPrice;
  final int previousPrice;
  final bool showRate;

  const PriceChange({
    super.key,
    required this.currentPrice,
    required this.previousPrice,
    this.showRate = true,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors colors = context.colors;

    final change = currentPrice - previousPrice;
    final rate = previousPrice == 0 ? 0.0 : change / previousPrice * 100;

    final color = change > 0
        ? colors.priceUpText
        : change == 0
        ? colors.priceFlatText
        : colors.priceDownText;

    final changeText = change > 0
        ? '+${numberFormatter.format(change)}'
        : numberFormatter.format(change);

    final rateText = rate > 0
        ? '+${rate.toStringAsFixed(2)}%'
        : '${rate.toStringAsFixed(2)}%';

    return Text(
      '$changeText${showRate ? ' ($rateText)' : ''}',
      style: TextStyle(color: color, fontSize: 11),
    );
  }
}
