import 'dart:io';

import 'package:apk_admin/apk_admin.dart';
import 'package:flutter_p2p/flutter_p2p.dart';
import 'package:flutter_p2p/gen/protos/protos.pb.dart';

class AppSelected {
  final App app;
  AppSelected(this.app);
}

class AppDeselected {
  final App app;
  AppDeselected(this.app);
}

class FileSelected {
  final File file;
  FileSelected(this.file);
}

class FileDeselected {
  final File file;
  FileDeselected(this.file);
}

class VideoSelected {
  final File file;
  VideoSelected(this.file);
}

class VideoDeselected {
  final File file;
  VideoDeselected(this.file);
}

class PicSelected {
  final File file;
  PicSelected(this.file);
}

class PicDeselected {
  final File file;
  PicDeselected(this.file);
}

class AudioSelected {
  final File file;
  AudioSelected(this.file);
}

class AudioDeselected {
  final File file;
  AudioDeselected(this.file);
}

class DeviceListUpdated {
  final List<WifiP2pDevice> devices;
  DeviceListUpdated(this.devices);
}

class OpenedHostPort {
  final P2pSocket socket;
  OpenedHostPort(this.socket);
}

class ConnectToHostPort {
  final P2pSocket socket;
  ConnectToHostPort(this.socket);
}

class ConnectionChangeAction {
  final bool isConnected;
  final bool isHost;
  final String deviceAddress;
  ConnectionChangeAction(this.isConnected, this.isHost, this.deviceAddress);
}
