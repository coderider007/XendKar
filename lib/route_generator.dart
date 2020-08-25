import 'dart:io';

import './constants.dart';
import './pages/home_page.dart';
import './pages/view_pages.dart';

import 'pages/home_page.dart';
import 'pages/send_pages.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Constants.ROUTE_HOME:
        return MaterialPageRoute(builder: (context) => HomePage());
      case Constants.ROUTE_SEND_PAGE:
        return MaterialPageRoute(builder: (context) => SendPage());
      case Constants.ROUTE_VIEW_PAGE:
        final File page = settings.arguments;
        return MaterialPageRoute(builder: (context) => ViewPages(page));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(
          child: Text("ERROR"),
        ),
      );
    });
  }
}
