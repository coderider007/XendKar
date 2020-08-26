import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilesTab extends StatefulWidget {
  const FilesTab({Key key}) : super(key: key);

  @override
  _FilesTabState createState() => _FilesTabState();
}

class _FilesTabState extends State<FilesTab> {
  List<File> _files;
  bool _loadingPath = false;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _files = await FilePicker.getMultiFile();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
    });
  }

  void _clearSelection() {
    setState(() {
      _files = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () => _openFileExplorer(),
                  child: Text("Open file picker"),
                ),
                RaisedButton(
                  onPressed: () => _clearSelection(),
                  child: Text("Clear selection"),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Builder(
              builder: (BuildContext context) => _loadingPath
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator())
                  : _files != null && _files.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: Scrollbar(
                              child: ListView.separated(
                            itemCount: _files.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String name = 'File $index: ' +
                                  _files.elementAt(index).path;
                              final path = _files.elementAt(index).path;

                              return ListTile(
                                title: Text(
                                  name,
                                ),
                                subtitle: Text(path),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(),
                          )),
                        )
                      : Container(),
            ),
          ),
        ],
      ),
    );
  }
}
