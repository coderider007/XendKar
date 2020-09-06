import 'dart:io';
import 'package:file_icon/file_icon.dart';
// import 'package:image/image.dart' as IMG;
// import 'package:file_icon/file_icon.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class SelectedFile extends StatelessWidget {
  final File _file;
  final bool _isSelected;

  SelectedFile(this._file, this._isSelected);

  @override
  Widget build(BuildContext context) {
    // var image = IMG.decodeImage(_file.readAsBytesSync());
    // var thumbnail = IMG.copyResize(image, width: 120);
    String fileName = path.basename(_file.path);
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3,
          color: _isSelected ? Colors.grey : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                FileIcon(fileName, size: 80),
                // Image.file(
                //   _file,
                //   height: 80,
                //   width: 80,
                // ),
                Expanded(child: Text(fileName)),
              ],
            ),
          ),
        ),
        if (_isSelected)
          Positioned(
            top: 2,
            right: 2,
            child: CircleAvatar(
              maxRadius: 10,
              backgroundColor: Colors.green[800],
              child: Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
      ],
    );
  }
}
