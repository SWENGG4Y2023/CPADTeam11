import 'dart:convert';
import 'dart:developer';

import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sapride/controllers/profile/profile_controller.dart';
import 'package:sapride/models/profile/profile.dart';
import 'package:sapride/services/api_service.dart';
import 'package:sapride/util/pin_marker.dart';

import '../../util/add_address_sheet.dart';
import '../../util/loading_dialog.dart';

final _profileController = Get.find<ProfileController>();

class CustomMapController extends GetxController {
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;

  RxList<Marker> markers = <Marker>[].obs;

  RxList<BaseLocation> selectedAddress = <BaseLocation>[].obs;

  String addressName = '';
  String addressLine = '';
  String city = '';
  String postalCode = '';
  String state = '';
  String country = '';

  Future<void> getLocation() async {
    CustomUtils.showLoading();
    await Geolocator.requestPermission();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.unableToDetermine) {
      Position loc = await Geolocator.getCurrentPosition();
      Get.back();
      lat.value = loc.latitude;
      long.value = loc.longitude;

      markers.add(CustomMarker.buildPin(LatLng(lat.value, long.value)));
    } else {
      Geolocator.requestPermission();
    }
  }

  Future<void> getAddress() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(lat.value, long.value);
    if (placemarks.isNotEmpty) {
      var plm = placemarks.first;
      log(plm.toJson().toString());
      addressLine = '${plm.street},${plm.name},${plm.subLocality}';
      city = plm.locality ?? 'Bengaluru';
      postalCode = plm.postalCode ?? '560001';
      state = plm.administrativeArea ?? 'Karnataka';
      country = plm.country ?? 'India';
      Get.bottomSheet(const AddAddressSheet());
    } else {
      Get.snackbar('Invalid Address', 'Move the pin to a valid location');
    }
  }

  Future<void> saveAddress() async {
    if (addressName.isNotEmpty) {
      CustomUtils.showLoading();
      String userId = _profileController.user.first.userId;
      try {
        var response = await ApiService.postData(endPoint: 'Location', data: {
          "name": addressName,
          "address": addressLine,
          "city": city,
          "state": state,
          "country": country,
          "latitude": lat.value,
          "longitude": long.value,
        });
        var json = jsonDecode(jsonEncode(response));
        await ApiService.patchData(
            endPoint: 'User($userId)',
            data: {"base_location_id": json['location_id']});
        await _profileController.getUserDetail();
        Get
          ..back()
          ..back()
          ..back();
      } catch (e) {
        log(e.toString());
      }
    } else {
      Get.snackbar('Address Error', 'Kindly Add a Name for the Address');
    }
  }
}
