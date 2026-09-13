enum SortType { currentPrice, changeRate, name }

extension SortTypeExtension on SortType {
  String get label {
    switch (this) {
      case SortType.currentPrice:
        return '현재가순';
      case SortType.changeRate:
        return '등락률순';
      case SortType.name:
        return '가나다순';
    }
  }
}
