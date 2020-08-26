import 'package:apk_admin/apk_admin.dart';
import 'package:flutter/material.dart';
import 'package:xendkar/pages/tabs/apps_tab.dart';
import 'package:xendkar/pages/tabs/files_tab.dart';
import '../widgets/custom_drawer.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: const Text(Constants.appTitle + ' - Home'),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs.map((homeTab) {
              return Container(
                width: MediaQuery.of(context).size.width / 2 - 50,
                child: Tab(
                  text: homeTab.title,
                  icon: Icon(homeTab.icon),
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((homeTab) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: TabViewChoice(homeTab: homeTab),
            );
          }).toList(),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipOval(
              child: Material(
                color: Colors.green,
                child: InkWell(
                  splashColor: Colors.blue,
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_download,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            'Receive',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
            ClipOval(
              child: Material(
                color: Colors.blue[300],
                child: InkWell(
                  splashColor: Colors.red,
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_upload,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            'Send',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(Constants.ROUTE_SEND_PAGE);
                    // .then(
                    //   (value) => {
                    //     setState(() {
                    //       allFiles = loadImageList();
                    //     })
                    //   },
                    // );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab {
  const HomeTab({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<HomeTab> tabs = const <HomeTab>[
  // const Choice(title: 'Recent', icon: Icons.watch_later),
  const HomeTab(title: 'Files', icon: Icons.folder),
  // const Choice(title: 'Videos', icon: Icons.video_library),
  // const Choice(title: 'Pictures', icon: Icons.photo_library),
  const HomeTab(title: 'Apps', icon: Icons.android),
  // const Choice(title: 'Audio', icon: Icons.library_music),
];

class TabViewChoice extends StatefulWidget {
  const TabViewChoice({Key key, this.homeTab}) : super(key: key);

  final HomeTab homeTab;

  @override
  _TabViewChoiceState createState() => _TabViewChoiceState();
}

class _TabViewChoiceState extends State<TabViewChoice> {
  @override
  Widget build(BuildContext context) {
    if (this.widget.homeTab.title == 'Apps') {
      return AppsTab();
    } else if (this.widget.homeTab.title == 'Files') {
      return FilesTab();
    } else {
      return Container(
        child: Center(
          child: Text('Tab View'),
        ),
      );
    }
  }
}
