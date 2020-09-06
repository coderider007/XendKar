import 'package:flutter_p2p/flutter_p2p.dart';
import 'package:flutter_p2p/gen/protos/protos.pb.dart';

class WiFiState {
  var isConnected = false;
  var isHost = false;
  var deviceAddress = "";
  P2pSocket socket;
  List<WifiP2pDevice> devices = [];

  WiFiState() {
    this.isConnected = false;
    this.isHost = false;
    this.deviceAddress = "";
    this.devices = [];
  }

  WiFiState.fromAppState(WiFiState another) {
    this.isConnected = another.isConnected;
    this.isHost = another.isHost;
    this.deviceAddress = another.deviceAddress;
    this.socket = another.socket;
    this.devices = []..addAll(another.devices);
  }
}
