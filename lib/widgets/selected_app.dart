import 'package:apk_admin/apk_admin.dart';
import 'package:flutter/material.dart';

class SelectedApp extends StatelessWidget {
  final App _app;
  final bool _isSelected;

  SelectedApp(this._app, this._isSelected);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          color: _isSelected ? Colors.grey : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                Image.memory(
                  _app.decodedIcon,
                  height: 40,
                  width: 40,
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(child: Text(_app.appName)),
              ],
            ),
          ),
        ),
        if (_isSelected)
          Positioned(
            top: 0,
            left: 2,
            child: Icon(Icons.check, color: Colors.white, size: 60),
          ),
      ],
    );
  }
}
