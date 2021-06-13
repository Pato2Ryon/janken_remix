import 'package:flutter/material.dart';
import 'package:janken_remix/ui/normal_janken.dart';
import 'package:janken_remix/ui/test.dart';

enum AppPage { root, normalJanken, test }

extension AppPageExtension on AppPage {
  String get routeName {
    switch (this) {
      case AppPage.root:
        return '/';
      case AppPage.normalJanken:
        return 'normalJanken';
      case AppPage.test:
        return 'test';
      default:
        return null;
    }
  }

  Widget get newPageWidget {
    switch (this) {
      case AppPage.root:
        return null;
      case AppPage.normalJanken:
        return NormalJankenPage();
      case AppPage.test:
        return TestPage();
    }
  }
}

PageRouteBuilder<void> fadeTransitionPageRouteBuilder(AppPage page) {
  return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) {
        return page.newPageWidget;
      },
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      });
}
