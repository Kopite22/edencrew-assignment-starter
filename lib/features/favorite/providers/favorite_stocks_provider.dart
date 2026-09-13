import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:edencrew_assignment_starter/core/network/dio_client.dart';

import '../data/favorite_repository.dart';
import '../data/favorite_stock_storage.dart';
import '../models/favorite_stock.dart';
import '../models/stock_price.dart';

final favoriteStockStorageProvider = Provider<FavoriteStockStorage>((ref) {
  return FavoriteStockStorage();
});

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepository(DioClient.instance.dio);
});

final favoriteStocksProvider =
    AsyncNotifierProvider<FavoriteStocksNotifier, List<FavoriteStock>>(
      FavoriteStocksNotifier.new,
    );

class FavoriteStocksNotifier extends AsyncNotifier<List<FavoriteStock>> {
  @override
  Future<List<FavoriteStock>> build() async {
    final storage = ref.read(favoriteStockStorageProvider);

    return storage.getFavorite();
  }

  Future<void> add(FavoriteStock stock) async {
    final current = state.value ?? [];

    final isExist = current.any((item) => item.code == stock.code);

    if (isExist) {
      return;
    }

    final newList = [...current, stock];

    state = AsyncData(newList);

    final storage = ref.read(favoriteStockStorageProvider);

    await storage.saveFavorite(newList);
  }

  Future<void> remove(String code) async {
    final current = state.value ?? [];

    final newList = current.where((stock) => stock.code != code).toList();

    state = AsyncData(newList);

    final storage = ref.read(favoriteStockStorageProvider);

    await storage.saveFavorite(newList);
  }

  bool isFavorite(String code) {
    final current = state.value ?? [];

    return current.any((stock) => stock.code == code);
  }
}

final stockPricesProvider = FutureProvider<Map<String, StockPrice>>((
  ref,
) async {
  final favorites = await ref.watch(favoriteStocksProvider.future);

  if (favorites.isEmpty) {
    return {};
  }

  final codes = favorites.map((stock) => stock.code).toList();

  final repository = ref.read(favoriteRepositoryProvider);

  return repository.getStockPrices(codes);
});
