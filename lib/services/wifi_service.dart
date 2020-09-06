import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_p2p/flutter_p2p.dart';
import 'package:flutter_p2p/gen/protos/protos.pb.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:xendkar/constants.dart';
import 'package:xendkar/model/app_state.dart';
import 'package:xendkar/redux/actions.dart';

class WiFiService {
  WiFiService._privateConstructor();

  static final WiFiService instance = WiFiService._privateConstructor();

  factory WiFiService(BuildContext context) {
    instance._store = StoreProvider.of<AppState>(context);
    return instance;
  }

  Store<AppState> _store; //= StoreProvider.of<AppState>(context);

  //List<WifiP2pDevice> devices = [];

  List<StreamSubscription> subscriptions = [];

  void discoverDevices() {
    FlutterP2p.discoverDevices();
  }

  void stopDiscoverDevices() {
    FlutterP2p.stopDiscoverDevices();
  }

  void connect(WifiP2pDevice device) {
    FlutterP2p.connect(device);
  }

  void cancelConnect(WifiP2pDevice device) {
    FlutterP2p.cancelConnect(device);
  }

  void removeGroup() {
    FlutterP2p.removeGroup();
  }

  void register() async {
    if (!await _checkPermission()) {
      return;
    }
    subscriptions.add(FlutterP2p.wifiEvents.stateChange.listen((change) {
      print("stateChange: ${change.isEnabled}");
    }));

    subscriptions.add(FlutterP2p.wifiEvents.connectionChange.listen((change) {
      //XXX: Connection change
      _store.dispatch(ConnectionChangeAction(
          change.networkInfo.isConnected,
          change.wifiP2pInfo.isGroupOwner,
          change.wifiP2pInfo.groupOwnerAddress));

      print(
          "connectionChange: ${change.wifiP2pInfo.isGroupOwner}, Connected: ${change.networkInfo.isConnected}");
    }));

    subscriptions.add(FlutterP2p.wifiEvents.thisDeviceChange.listen((change) {
      print(
          "deviceChange: ${change.deviceName} / ${change.deviceAddress} / ${change.primaryDeviceType} / ${change.secondaryDeviceType} ${change.isGroupOwner ? 'GO' : '-GO'}");
    }));

    subscriptions.add(FlutterP2p.wifiEvents.discoveryChange.listen((change) {
      print("discoveryStateChange: ${change.isDiscovering}");
    }));

    subscriptions.add(FlutterP2p.wifiEvents.peersChange.listen((change) {
      print("peersChange: ${change.devices.length}");
      change.devices.forEach((device) {
        print("device: ${device.deviceName} / ${device.deviceAddress}");
      });
      // XXX: Device list updated
      _store.dispatch(DeviceListUpdated(change.devices));
    }));

    FlutterP2p.register();
  }

  void unregister() {
    subscriptions.forEach((subscription) => subscription.cancel());
    FlutterP2p.unregister();
  }

  void openPortAndAccept() async {
    var socket = await FlutterP2p.openHostPort(Constants.PORT);
    //XXX: Host port opened for data
    _store.dispatch(OpenedHostPort(socket));

    var buffer = "";
    socket.inputStream.listen((data) {
      var msg = String.fromCharCodes(data.data);
      buffer += msg;
      if (data.dataAvailable == 0) {
        // snackBar("Data Received: $buffer");
        socket.writeString("Successfully received: $buffer");
        buffer = "";
      }
    });

    print("_openPort done");

    await FlutterP2p.acceptPort(Constants.PORT);
    print("_accept done");
  }

  connectToPort() async {
    var socket = await FlutterP2p.connectToHost(
      _store.state.wiFiState.deviceAddress,
      Constants.PORT,
      timeout: 100000,
    );

    //XXX: Connect to host port
    _store.dispatch(ConnectToHostPort(socket));
    //});

    socket.inputStream.listen((data) {
      var msg = utf8.decode(data.data);
      // snackBar("Received from Host: $msg");
    });

    print("_connectToPort done");
  }

  Future<bool> _checkPermission() async {
    if (!await FlutterP2p.isLocationPermissionGranted()) {
      await FlutterP2p.requestLocationPermission();
      return false;
    }
    return true;
  }
}
