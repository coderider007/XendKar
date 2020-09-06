import 'dart:io';

import 'package:xendkar/pages/receive_page.dart';
import 'package:xendkar/pages/search_connect.dart';

import './constants.dart';
import './pages/home_page.dart';

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
      case Constants.ROUTE_RECEIVE_PAGE:
        return MaterialPageRoute(builder: (context) => ReceivePage());
      case Constants.ROUTE_PEER_SELECTION_PAGE:
        return MaterialPageRoute(builder: (context) => SearchConnectPage());
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
