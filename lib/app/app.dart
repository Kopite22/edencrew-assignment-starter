import 'package:flutter/material.dart';

import 'package:edencrew_assignment_starter/theme/theme.dart';
import './router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '이든크루 평가 과제',
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
