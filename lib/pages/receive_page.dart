import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:xendkar/model/app_state.dart';
import 'package:xendkar/services/wifi_service.dart';

import '../constants.dart';

class ReceivePage extends StatefulWidget {
  @override
  _ReceivePageState createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> with WidgetsBindingObserver {
  WiFiService wiFiService = WiFiService.instance;

  @override
  void initState() {
    super.initState();
    wiFiService.register();
    WidgetsBinding.instance.addObserver(this);
    wiFiService.discoverDevices();
    wiFiService.openPortAndAccept();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      wiFiService.register();
    } else if (state == AppLifecycleState.paused) {
      wiFiService.unregister();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, appState) => Scaffold(
        appBar: AppBar(
          title: const Text('Receive Files'),
        ),
        body: Column(
          children: [
            Text(appState.wiFiState.isConnected
                ? "Connected: ${appState.wiFiState.isHost ? "Host" : "Client"}"
                : "Disconnected"),
            RaisedButton(
              onPressed: appState.wiFiState.isConnected
                  ? () => wiFiService.removeGroup()
                  : null,
              child: Text("Disconnect"),
            ),
            Center(
                child: Icon(
              Icons.phone_android,
              // color: Colors.deepOrange,
              size: 50,
            )),
          ],
        ),
      ),
    );
  }
}
