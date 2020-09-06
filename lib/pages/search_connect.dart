import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xendkar/model/app_state.dart';
import 'package:xendkar/model/circular_wave.dart';
import 'package:xendkar/services/wifi_service.dart';

import '../constants.dart';

class SearchConnectPage extends StatefulWidget {
  SearchConnectPage({Key key}) : super(key: key);

  @override
  _SearchConnectPageState createState() => _SearchConnectPageState();
}

class _SearchConnectPageState extends State<SearchConnectPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  WiFiService wiFiService = WiFiService.instance;

  double waveRadius = 0.0;
  double waveGap = 20.0;
  Animation<double> _animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    wiFiService.register();
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
    wiFiService.discoverDevices();
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
      wiFiService..register();
    } else if (state == AppLifecycleState.paused) {
      wiFiService.unregister();
    }
  }

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

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) => Scaffold(
        appBar: AppBar(
          title: const Text('Select Receiver'),
        ),
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
          ]..addAll(appState.wiFiState.devices.map((d) {
              return Positioned(
                top: random.nextDouble() * height,
                left: random.nextDouble() * width,
                child: InkWell(
                  child: Column(
                    children: [
                      Icon(Icons.phone_android),
                      Text(d.deviceName),
                      Text(d.deviceAddress),
                    ],
                  ),
                  //              title: Text(d.deviceName),
                  //            subtitle: Text(d.deviceAddress),
                  onTap: () {
                    print(
                        "${appState.wiFiState.isConnected ? "Disconnect" : "Connect"} to device: ${appState.wiFiState.deviceAddress}");
                    appState.wiFiState.isConnected
                        ? wiFiService.cancelConnect(d)
                        : wiFiService.connect(d);
                    wiFiService.stopDiscoverDevices();
                    Navigator.of(context).pushNamed(Constants.ROUTE_SEND_PAGE);
                  },
                ),
              );
            }).toList()),
        ),
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

}
