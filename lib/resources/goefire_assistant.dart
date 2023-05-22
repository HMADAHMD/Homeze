
import 'package:homeze_screens/models/active_nearby_taskers.dart';

class GeofireAssistant {

  static List<ActiveNearbyTaskers> activeNearbyTaskersList = [];
  static void deleteTaskerFromList(String taskerId) {
    int indexNumber = activeNearbyTaskersList
        .indexWhere((element) => element.taskerId == taskerId);
    activeNearbyTaskersList.removeAt(indexNumber);
  }

  static void updateNearbyTaskerLocation(ActiveNearbyTaskers taskerWhoMove) {
    int indexNumber = activeNearbyTaskersList
        .indexWhere((element) => element.taskerId == taskerWhoMove.taskerId);
    activeNearbyTaskersList[indexNumber].locationlatitide =
        taskerWhoMove.locationlatitide;
    activeNearbyTaskersList[indexNumber].locationlongitude =
        taskerWhoMove.locationlongitude;
  }
}
