import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xendkar/model/app_state.dart';
import 'package:xendkar/redux/actions.dart';
import 'package:xendkar/widgets/selected_image.dart';

class PicturesTab extends StatelessWidget {
  const PicturesTab({Key key}) : super(key: key);

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
        children: appState.allPictures.map((file) {
          return GestureDetector(
            onTap: () {
              appState.selectedPictures.contains(file)
                  ? StoreProvider.of<AppState>(context)
                      .dispatch(PicDeselected(file))
                  : StoreProvider.of<AppState>(context)
                      .dispatch(PicSelected(file));
            },
            child:
                SelectedImage(file, appState.selectedPictures.contains(file)),
          );
        }).toList(),
      ),
    );
  }
}
