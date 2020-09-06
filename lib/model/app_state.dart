import 'dart:io';

import 'package:apk_admin/apk_admin.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xendkar/model/wifi_state.dart';
import 'package:permission_handler/permission_handler.dart';

class AppState {
  List<File> selectedFiles = [];
  List<File> allFiles = [];

  List<File> selectedVideos = [];
  List<File> allVideos = [];

  List<File> selectedPictures = [];
  List<File> allPictures = [];

  List<App> selectedApps = [];
  List<App> allApps = [];

  List<File> selectedAudios = [];
  List<File> allAudios = [];

  WiFiState wiFiState;

  AppState({
    @required allApps,
    @required allFiles,
    @required allAudios,
    @required allVideos,
    @required allPictures,
  }) {
    this.selectedApps = [];
    this.selectedFiles = [];
    this.selectedAudios = [];
    this.selectedVideos = [];
    this.selectedPictures = [];
    wiFiState = WiFiState();

    this.allApps = []..addAll(allApps);
    this.allFiles = []..addAll(allFiles);
    this.allAudios = []..addAll(allAudios);
    this.allVideos = []..addAll(allVideos);
    this.allPictures = []..addAll(allPictures);
  }

  AppState.fromAppState(AppState another) {
    this.selectedApps = []..addAll(another.selectedApps);
    this.selectedFiles = []..addAll(another.selectedFiles);
    this.selectedAudios = []..addAll(another.selectedAudios);
    this.selectedVideos = []..addAll(another.selectedVideos);
    this.selectedPictures = []..addAll(another.selectedPictures);
    this.wiFiState = another.wiFiState;

    this.allApps = []..addAll(another.allApps);
    this.allFiles = []..addAll(another.allFiles);
    this.allAudios = []..addAll(another.allAudios);
    this.allVideos = []..addAll(another.allVideos);
    this.allPictures = []..addAll(another.allPictures);
  }

  static Future<AppState> initState() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    ApkScouter apkScouter = ApkScouter();
    var _installedApps = await apkScouter.getInstalledApps(
        includeSystemApps: true, includeAppIcon: true);

    List<File> _allFiles = [];
    List<File> _allAudios = [];
    List<File> _allVideos = [];
    List<File> _allPictures = [];
    try {
      // Get Files
      var fileDir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);

      Directory(fileDir).listSync(recursive: true).forEach((entry) {
        if (entry is File) {
          _allFiles.add(entry);
        }
      });

      // Get Pictures
      var musicDir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_MUSIC);
      Directory(musicDir).listSync(recursive: true).forEach((entry) {
        if (entry is File) {
          _allAudios.add(entry);
        }
      });
      // Get Pictures
      var picsDir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DCIM);
      Directory(picsDir).listSync(recursive: true).forEach((entry) {
        if (entry is File) {
          _allPictures.add(entry);
        }
      });
      // Get Videos
      var videosDir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DCIM);
      Directory(videosDir).listSync(recursive: true).forEach((entry) {
        if (entry is File) {
          _allVideos.add(entry);
        }
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    return AppState(
        allApps: _installedApps,
        allFiles: _allFiles,
        allAudios: _allAudios,
        allVideos: _allVideos,
        allPictures: _allPictures);
  }
}
