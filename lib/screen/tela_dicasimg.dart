import 'package:flutter/material.dart';
import 'package:webcodetricks/tabs/home_tab.dart';

class PageDicas extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[HomeTab()],
    );
  }
}
