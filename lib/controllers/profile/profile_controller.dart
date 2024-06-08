

import 'dart:developer';

import 'package:get/get.dart';
import 'package:sapride/util/add_car_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/event/car_model.dart';
import '../../models/profile/profile.dart';
import '../../services/api_service.dart';
import '../../util/loading_dialog.dart';

class ProfileController extends GetxController{

  RxList<User> user = <User>[].obs;

  RxString carName = "".obs;
  RxString carNumber = "".obs;
  RxInt seater = 0.obs;

  Future<void> getUserDetail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String email = preferences.getString('userEmail')??'';
    var result = await ApiService.getData(endPoint: "User?\$filter=user_email eq '${email.toLowerCase()}'&\$expand=base_location");
    log(result.toString());
    if(result != null) {
      user.value =
          List<User>.from(result['value'].map((e) => User.fromJson(e)))
              .toList();
    }
    }

    Future<void> saveVehicle() async {
      if (carName.value.isNotEmpty && carNumber.value.isNotEmpty && seater.value != 0) {
        CustomUtils.showLoading();
        String userId = user.first.userId;
        try {
         var res = await ApiService.patchData(
              endPoint: 'User($userId)',
              data: {
                "car": carName.value,
                // "car_number":carNumber.value,
                "seats":seater.value
              });
         log(res.toString());
          await getUserDetail();
          Get..back()..back();
        } catch (e) {
          log(e.toString());
        }
      } else {
        Get.snackbar('Error', 'Kindly enter all the fields');
      }
    }

    void editVehicle(){
    carName.value = user.first.car??'';
    // carNumber.value = user.first.carNumber??'';
      seater.value = user.first.seats??0;
      Get.bottomSheet(AddCarSheet());
    }
}