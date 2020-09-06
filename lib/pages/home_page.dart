import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xendkar/model/app_state.dart';
import 'package:xendkar/pages/send_pages.dart';
import 'package:xendkar/pages/tabs/apps_tab.dart';
import 'package:xendkar/pages/tabs/audios_tab.dart';
import 'package:xendkar/pages/tabs/files_tab.dart';
import 'package:xendkar/pages/tabs/pictures_tab.dart';
import 'package:xendkar/pages/tabs/recent_tab.dart';
import 'package:xendkar/pages/tabs/videos_tab.dart';
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
                //width: MediaQuery.of(context).size.width / 2 - 50,
                child: Tab(
                  text: homeTab.title.toString().split('.').last,
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
            StoreConnector<AppState, AppState>(
              converter: (store) => store.state,
              builder: (context, appState) => ClipOval(
                child: Material(
                  color: Colors.black.withOpacity(0.40),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(
                      child: Text(
                        (appState.selectedApps.length +
                                appState.selectedAudios.length +
                                appState.selectedFiles.length +
                                appState.selectedPictures.length +
                                appState.selectedVideos.length)
                            .toString(), //count.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ClipOval(
              child: Material(
                color: Colors.green.withOpacity(0.70),
                child: InkWell(
                  splashColor: Colors.blue,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_download,
                            size: 20,
                            color: Colors.white,
                          ),
                          Text(
                            'Receive',
                            style: TextStyle(
                                fontSize: 12,
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
                color: Colors.blue.withOpacity(0.70),
                child: InkWell(
                  splashColor: Colors.red,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.file_upload,
                            size: 20,
                            color: Colors.white,
                          ),
                          Text(
                            'Send',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(Constants.ROUTE_PEER_SELECTION_PAGE);
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

  final TITLE title;
  final IconData icon;
}

enum TITLE { Recent, Files, Videos, Pictures, Apps, Audio }

const List<HomeTab> tabs = const <HomeTab>[
  // const HomeTab(title: TITLE.Recent, icon: Icons.watch_later),
  const HomeTab(title: TITLE.Files, icon: Icons.folder),
  const HomeTab(title: TITLE.Videos, icon: Icons.video_library),
  const HomeTab(title: TITLE.Pictures, icon: Icons.photo_library),
  const HomeTab(title: TITLE.Apps, icon: Icons.android),
  const HomeTab(title: TITLE.Audio, icon: Icons.library_music),
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
    if (this.widget.homeTab.title == TITLE.Recent) {
      return RecentTab();
    } else if (this.widget.homeTab.title == TITLE.Files) {
      return FilesTab();
    } else if (this.widget.homeTab.title == TITLE.Videos) {
      return VideosTab();
    } else if (this.widget.homeTab.title == TITLE.Pictures) {
      return PicturesTab();
    } else if (this.widget.homeTab.title == TITLE.Apps) {
      return AppsTab();
    } else if (this.widget.homeTab.title == TITLE.Audio) {
      return AudiosTab();
    } else {
      return Container(
        child: Center(
          child: Text('Tab View'),
        ),
      );
    }
  }
}
