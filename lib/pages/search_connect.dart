import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_p2p/flutter_p2p.dart';
import 'package:flutter_p2p/gen/protos/protos.pb.dart';
import 'package:xendkar/model/circular_wave.dart';

import '../constants.dart';

class SearchConnectPage extends StatefulWidget {
  SearchConnectPage({Key key}) : super(key: key);

  @override
  _SearchConnectPageState createState() => _SearchConnectPageState();
}

class _SearchConnectPageState extends State<SearchConnectPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _register();
    WidgetsBinding.instance.addObserver(this);

    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    FlutterP2p.discoverDevices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _register();
    } else if (state == AppLifecycleState.paused) {
      _unregister();
    }
  }

  List<WifiP2pDevice> devices = [];

  var _isConnected = false;
  var _isHost = false;

  List<StreamSubscription> _subscriptions = [];

  void _register() async {
    if (!await _checkPermission()) {
      return;
    }
    _subscriptions.add(FlutterP2p.wifiEvents.stateChange.listen((change) {
      print("stateChange: ${change.isEnabled}");
    }));

    _subscriptions.add(FlutterP2p.wifiEvents.connectionChange.listen((change) {
      setState(() {
        _isConnected = change.networkInfo.isConnected;
        _isHost = change.wifiP2pInfo.isGroupOwner;
        _deviceAddress = change.wifiP2pInfo.groupOwnerAddress;
      });
      print(
          "connectionChange: ${change.wifiP2pInfo.isGroupOwner}, Connected: ${change.networkInfo.isConnected}");
    }));

    _subscriptions.add(FlutterP2p.wifiEvents.thisDeviceChange.listen((change) {
      print(
          "deviceChange: ${change.deviceName} / ${change.deviceAddress} / ${change.primaryDeviceType} / ${change.secondaryDeviceType} ${change.isGroupOwner ? 'GO' : '-GO'}");
    }));

    _subscriptions.add(FlutterP2p.wifiEvents.discoveryChange.listen((change) {
      print("discoveryStateChange: ${change.isDiscovering}");
    }));

    _subscriptions.add(FlutterP2p.wifiEvents.peersChange.listen((change) {
      print("peersChange: ${change.devices.length}");
      change.devices.forEach((device) {
        print("device: ${device.deviceName} / ${device.deviceAddress}");
      });

      setState(() {
        devices = change.devices;
      });
    }));

    FlutterP2p.register();
  }

  void _unregister() {
    _subscriptions.forEach((subscription) => subscription.cancel());
    FlutterP2p.unregister();
  }

  P2pSocket _socket;
  void _openPortAndAccept(int port) async {
    var socket = await FlutterP2p.openHostPort(port);
    setState(() {
      _socket = socket;
    });

    var buffer = "";
    socket.inputStream.listen((data) {
      var msg = String.fromCharCodes(data.data);
      buffer += msg;
      if (data.dataAvailable == 0) {
        snackBar("Data Received: $buffer");
        socket.writeString("Successfully received: $buffer");
        buffer = "";
      }
    });

    print("_openPort done");

    await FlutterP2p.acceptPort(port);
    print("_accept done");
  }

  var _deviceAddress = "";

  _connectToPort(int port) async {
    var socket = await FlutterP2p.connectToHost(
      _deviceAddress,
      port,
      timeout: 100000,
    );

    setState(() {
      _socket = socket;
    });

    _socket.inputStream.listen((data) {
      var msg = utf8.decode(data.data);
      snackBar("Received from Host: $msg");
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  double waveRadius = 0.0;
  double waveGap = 20.0;
  Animation<double> _animation;
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    _animation = Tween(begin: 0.0, end: waveGap).animate(controller)
      ..addListener(() {
        setState(() {
          waveRadius = _animation.value;
        });
      });

    Random random = new Random();
    double width = MediaQuery.of(context).size.width - 10;
    double height = MediaQuery.of(context).size.height - 10;

    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   title: Text(Constants.appTitle),
      // ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: CircleWavePainter(waveRadius),
          ),
          Center(
              child: Icon(
            Icons.phone_android,
            // color: Colors.deepOrange,
            size: 50,
          )),
        ]..addAll(this.devices.map((d) {
            return Positioned(
              top: random.nextDouble() * height,
              left: random.nextDouble() * width,
              child: InkWell(
                child: Column(
                  children: [
                    Icon(Icons.phone_android),
                    Text(d.deviceName),
                  ],
                ),
                //              title: Text(d.deviceName),
                //            subtitle: Text(d.deviceAddress),
                onTap: () {
                  print(
                      "${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");
                  return _isConnected
                      ? FlutterP2p.cancelConnect(d)
                      : FlutterP2p.connect(d);
                },
              ),
            );
          }).toList()),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     key: _scaffoldKey,
  //     appBar: AppBar(
  //       title: Text(Constants.appTitle),
  //     ),
  //     body: Column(
  //       children: <Widget>[
  //         Text(_isConnected
  //             ? "Connected: ${_isHost ? "Host" : "Client"}"
  //             : "Disconnected"),
  //         RaisedButton(
  //           onPressed: () => FlutterP2p.discoverDevices(),
  //           child: Text("Discover Devices"),
  //         ),
  //         RaisedButton(
  //           onPressed:
  //               _isConnected && _isHost ? () => _openPortAndAccept(8888) : null,
  //           child: Text("Open and accept data from port 8888"),
  //         ),
  //         RaisedButton(
  //           onPressed: _isConnected ? () => _connectToPort(8888) : null,
  //           child: Text("Connect to port 8888"),
  //         ),
  //         RaisedButton(
  //           onPressed: _socket != null
  //               ? () => _socket.writeString("Hello World")
  //               : null,
  //           child: Text("Send hello world"),
  //         ),
  //         RaisedButton(
  //           onPressed: _isConnected ? () => FlutterP2p.removeGroup() : null,
  //           child: Text("Disconnect"),
  //         ),
  //         Expanded(
  //           child: ListView(
  //             children: this.devices.map((d) {
  //               return ListTile(
  //                 title: Text(d.deviceName),
  //                 subtitle: Text(d.deviceAddress),
  //                 onTap: () {
  //                   print(
  //                       "${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");
  //                   return _isConnected
  //                       ? FlutterP2p.cancelConnect(d)
  //                       : FlutterP2p.connect(d);
  //                 },
  //               );
  //             }).toList(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  snackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
