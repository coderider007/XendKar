import 'package:xendkar/model/app_state.dart';

import 'actions.dart';

AppState reducer(AppState prevState, dynamic action) {
  AppState newState = AppState.fromAppState(prevState);

  if (action is AppSelected) {
    newState.selectedApps.add(action.app);
  } else if (action is AppDeselected) {
    newState.selectedApps.remove(action.app);
  } else if (action is FileSelected) {
    newState.selectedFiles.add(action.file);
  } else if (action is FileDeselected) {
    newState.selectedFiles.remove(action.file);
  } else if (action is VideoSelected) {
    newState.selectedVideos.add(action.file);
  } else if (action is VideoDeselected) {
    newState.selectedVideos.remove(action.file);
  } else if (action is PicSelected) {
    newState.selectedPictures.add(action.file);
  } else if (action is PicDeselected) {
    newState.selectedPictures.remove(action.file);
  } else if (action is AudioSelected) {
    newState.selectedAudios.add(action.file);
  } else if (action is AudioDeselected) {
    newState.selectedAudios.remove(action.file);
  } else if (action is DeviceListUpdated) {
    newState.wiFiState.devices = action.devices;
  } else if (action is OpenedHostPort) {
    newState.wiFiState.socket = action.socket;
  } else if (action is ConnectToHostPort) {
    newState.wiFiState.socket = action.socket;
  } else if (action is ConnectionChangeAction) {
    newState.wiFiState.deviceAddress = action.deviceAddress;
    newState.wiFiState.isConnected = action.isConnected;
    newState.wiFiState.isHost = action.isHost;
  }

  return newState;
}
