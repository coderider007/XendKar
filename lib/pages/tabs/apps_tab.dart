import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xendkar/model/app_state.dart';
import 'package:xendkar/redux/actions.dart';
import 'package:xendkar/widgets/selected_app.dart';

class AppsTab extends StatelessWidget {
  AppsTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) => GridView.count(
        // childAspectRatio: 2.0,
        crossAxisCount: (orientation == Orientation.portrait) ? 5 : 8,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 10.0,
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        children: appState.allApps.map((app) {
          return GestureDetector(
            onTap: () {
              appState.selectedApps.contains(app)
                  ? StoreProvider.of<AppState>(context)
                      .dispatch(AppDeselected(app))
                  : StoreProvider.of<AppState>(context)
                      .dispatch(AppSelected(app));
            },
            child: SelectedApp(app, appState.selectedApps.contains(app)),
          );
        }).toList(),
      ),
    );
  }
}
