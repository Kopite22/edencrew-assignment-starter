import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';

import 'package:edencrew_assignment_starter/features/favorite/presentation/favorite_screen.dart';
import 'package:edencrew_assignment_starter/features/search/presentation/search_screen.dart';
import 'package:edencrew_assignment_starter/features/stockDetail/presentation/stock_detail_screen.dart';

final router = GoRouter(
  initialLocation: '/favorite',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        final AppDimens dimens = context.dimens;
        final AppColors colors = context.colors;

        final selectedIndex = navigationShell.currentIndex;

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: colors.surfaceRaised,
              border: Border(
                top: BorderSide(color: colors.borderSubtle, width: 1),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: dimens.space2),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => navigationShell.goBranch(0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              selectedIndex == 0
                                  ? 'assets/icons/ico_starFill.svg'
                                  : 'assets/icons/ico_star.svg',
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '관심',
                              style: TextStyle(
                                color: selectedIndex == 0
                                    ? colors.navActive
                                    : colors.navInactive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => navigationShell.goBranch(1),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              color: selectedIndex == 1
                                  ? colors.navActive
                                  : colors.navInactive,
                              size: 22,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '검색',
                              style: TextStyle(
                                color: selectedIndex == 1
                                    ? colors.navActive
                                    : colors.navInactive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },

      branches: [
        // 관심
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorite',
              builder: (context, state) {
                return const FavoriteScreen();
              },
            ),
          ],
        ),

        // 검색
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) {
                return const SearchScreen();
              },
            ),
          ],
        ),
      ],
    ),

    // ⭐ 종목 상세
    GoRoute(
      path: '/stock/:stockCode',
      builder: (context, state) {
        final stockCode = state.pathParameters['stockCode']!;

        return StockDetailScreen(stockCode: stockCode);
      },
    ),
  ],
);
