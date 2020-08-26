import 'package:apk_admin/apk_admin.dart';
import 'package:flutter/material.dart';
import 'package:xendkar/widgets/selected_app.dart';

class AppsTab extends StatefulWidget {
  AppsTab({Key key}) : super(key: key);

  @override
  _AppsTabState createState() => _AppsTabState();
}

class _AppsTabState extends State<AppsTab> {
  ApkScouter apkScouter = ApkScouter();
  // ApkController apkController = ApkController();
  ApkBackup apkBackup = ApkBackup();
  // ApkExporter apkExporter = ApkExporter();
  List<App> _installedApps = [];
  Future<List<App>> _installedAppsFuture;

  List<App> _selectedApps = [];

  @override
  void initState() {
    super.initState();
    _installedAppsFuture = _getInstallApps();
  }

  Future<List<App>> _getInstallApps() async {
    _installedApps = await apkScouter.getInstalledApps(
        includeSystemApps: true, includeAppIcon: true);
    return _installedApps;
  }

  Widget buildOptionButton(String title, Function action) {
    return MaterialButton(
      padding: EdgeInsets.all(0),
      onPressed: action,
      child: Text(
        title,
        style: TextStyle(color: Colors.blueGrey, fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return FutureBuilder<List<App>>(
        future: _installedAppsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              // childAspectRatio: 2.0,
              crossAxisCount: (orientation == Orientation.portrait)
                  ? 5
                  : 8, // The number of items per row
              mainAxisSpacing: 20.0, // Spacing between rows
              crossAxisSpacing: 10.0,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              children: _installedApps.map((app) {
                // Iterate through _icons as a map
                // For each icon in the _icons list, return a widget
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedApps.contains(app)
                          ? _selectedApps.remove(app)
                          : _selectedApps.add(app);
                    });
                  },
                  child: SelectedApp(
                      app,
                      _selectedApps.contains(
                          app)), // Pass iconData and a boolean that specifies if the icon is selected or not
                );
              }).toList(), // Convert the map to a list of widgets
            );
          }
          return Center(child: CircularProgressIndicator());
        });
    // FutureBuilder<List<App>>(
    //   future: _getInstallApps(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       List<App> apps = snapshot.data;
    //       return GridView.builder(
    //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //             crossAxisCount: (orientation == Orientation.portrait) ? 5 : 8),
    //         itemCount: apps.length,
    //         itemBuilder: (context, i) => GestureDetector(
    //           onTap: () {
    //             setState(() {
    //               _selectedApps.contains(apps[i])
    //                   ? _selectedApps.remove(apps[i])
    //                   : _selectedApps.add(apps[i]);
    //             });
    //           },
    //           child: SelectedApp(apps[i], _selectedApps.contains(apps[i])),
    //         ),
    //       );
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }
}
