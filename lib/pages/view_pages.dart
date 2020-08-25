import 'dart:io';

import '../services/file_storage.dart';
import 'package:flutter/material.dart';

class ViewPages extends StatelessWidget {
  ViewPages(this.page);
  final FileStorageService _fileStorageService = FileStorageService.instance;

  final File page;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page " +
            _fileStorageService.getFileNameWithoutExtension(page.path)),
      ),
      body: Container(
        child: Image.file(page),
      ),
    );
  }
}
