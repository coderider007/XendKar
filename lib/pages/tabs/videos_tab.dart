import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xendkar/widgets/selected_file.dart';

class VideosTab extends StatefulWidget {
  const VideosTab({Key key}) : super(key: key);

  @override
  _VideosTabState createState() => _VideosTabState();
}

class _VideosTabState extends State<VideosTab> {
  List<File> _files = [];
  List<File> _selectedFiles = [];
  Future<List<File>> _filesFuture;

  @override
  void initState() {
    super.initState();
    _filesFuture = _getFiles();
  }

  Future<List<File>> _getFiles() async {
    List<File> _tempFiles = [];
    try {
      // var dir = await ExtStorage.getExternalStorageDirectory();
      var dir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_MOVIES);

      Directory(dir).listSync(recursive: true).forEach((entry) {
        if (entry is File) {
          _tempFiles.add(entry);
        }
      });
      _files = _tempFiles;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    return _tempFiles;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return FutureBuilder<List<File>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              // childAspectRatio: 2.0,
              crossAxisCount: (orientation == Orientation.portrait) ? 3 : 5,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 10.0,
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              children: _files.map((file) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFiles.contains(file)
                          ? _selectedFiles.remove(file)
                          : _selectedFiles.add(file);
                    });
                  },
                  child: SelectedFile(file, _selectedFiles.contains(file)),
                );
              }).toList(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
