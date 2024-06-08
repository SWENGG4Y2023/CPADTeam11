
import 'package:get/get.dart';
import 'package:sapride/controllers/auth/auth.dart';
import 'package:sapride/controllers/home/home_controller.dart';
import 'package:sapride/controllers/profile/profile_controller.dart';

import '../controllers/event/event_controller.dart';
import '../controllers/event/event_detail_controller.dart';
import '../controllers/event/provider_controller.dart';
import '../controllers/event/seeker_controller.dart';
import '../controllers/map/map_controller.dart';

class GetInitialize{

  static initialize(){
    Get.put(LoginController());
    Get.put(HomeController());
    Get.put(EventController());
    Get.put(ProfileController());
    Get.put(CustomMapController());
    Get.put(EventDetailController());
    Get.put(SeekerController());
    Get.put(ProviderController());
  }
}