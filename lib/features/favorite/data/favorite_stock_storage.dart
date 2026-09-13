import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite_stock.dart';

class FavoriteStockStorage {
  static const _key = 'favorite_stocks';

  Future<List<FavoriteStock>> getFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map((json) => FavoriteStock.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveFavorite(List<FavoriteStock> stocks) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      stocks.map((stock) => stock.toJson()).toList(),
    );

    await prefs.setString(_key, jsonString);
  }
}
