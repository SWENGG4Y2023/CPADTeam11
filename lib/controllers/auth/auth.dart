

import 'package:get/get.dart';
import 'package:sapride/controllers/event/event_controller.dart';
import 'package:sapride/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../views/home/home.dart';
import '../profile/profile_controller.dart';

class LoginController extends GetxController{

  RxBool loginLoading = false.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;

  ApiService apiService = ApiService();

  Future<void> login() async {
    loginLoading.value = true;
    bool check = await apiService.getToken(userName: email.value, password: password.value);
    loginLoading.value = false;
    if(check) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('userEmail', email.value);
      final eventController = Get.find<EventController>();
      final profileController = Get.find<ProfileController>();
      eventController.getEvents();
      profileController.getUserDetail();
      Get.offAll(() => const Home());
    }else{
      Get.snackbar('Auth Error','OOPS!!! You do not have the access to the app');
    }
  }

  bool check(){
    return email.value.isNotEmpty && password.value.isNotEmpty;
  }
}