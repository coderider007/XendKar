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
  }

  return newState;
}
