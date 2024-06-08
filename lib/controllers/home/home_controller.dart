
import 'package:get/get.dart';
import 'package:sapride/controllers/event/event_controller.dart';

final _eventController = Get.find<EventController>();

class HomeController extends GetxController{

  RxInt currentIndex = 0.obs;

  switchPage(int index){
    switch(index){
      case 0:
        _eventController.getEvents();
        break;
      case 1:
        _eventController.getEvents();
        break;
    }
    currentIndex.value = index;
  }

}