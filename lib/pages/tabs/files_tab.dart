import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xendkar/model/app_state.dart';
import 'package:xendkar/redux/actions.dart';
import 'package:xendkar/widgets/selected_file.dart';

class FilesTab extends StatelessWidget {
  const FilesTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) => GridView.count(
        // childAspectRatio: 2.0,
        crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        children: appState.allFiles.map((file) {
          return GestureDetector(
            onTap: () {
              appState.selectedFiles.contains(file)
                  ? StoreProvider.of<AppState>(context)
                      .dispatch(FileDeselected(file))
                  : StoreProvider.of<AppState>(context)
                      .dispatch(FileSelected(file));
            },
            child: SelectedFile(file, appState.selectedFiles.contains(file)),
          );
        }).toList(),
      ),
    );
  }
}
