import 'package:flutter/material.dart';
import '../custom/custom_drawer.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.appTitle + ' - Home'),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipOval(
              child: Material(
                color: Colors.green,
                child: InkWell(
                  splashColor: Colors.blue,
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Column(
                      children: [
                        Icon(
                          Icons.file_download,
                          size: 70,
                          color: Colors.white,
                        ),
                        Text(
                          'Receive',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
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
                    width: 120,
                    height: 120,
                    child: Column(
                      children: [
                        Icon(
                          Icons.file_upload,
                          size: 70,
                          color: Colors.white,
                        ),
                        Text(
                          'Send',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
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
