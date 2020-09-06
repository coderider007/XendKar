import 'dart:io';

import 'package:apk_admin/apk_admin.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xendkar/redux/reducers.dart';

import './constants.dart';

import './route_generator.dart';
import 'package:flutter/material.dart';

import 'model/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _initialState = await AppState.initState();
  final Store<AppState> _store =
      Store<AppState>(reducer, initialState: _initialState);

  runApp(MyApp(store: _store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: Constants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
            primaryColor:
                Constants.MAIN_COLOR), // canvasColor: Colors.transparent),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
