
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';

import '../../models/event/carpool_seeker.dart';
import '../../models/profile/profile.dart';
import '../../services/api_service.dart';
import '../../util/loading_dialog.dart';
import '../../util/pin_marker.dart';
import '../profile/profile_controller.dart';
import 'event_detail_controller.dart';

final _profileController = Get.find<ProfileController>();
final _eventDetailController = Get.find<EventDetailController>();
class ProviderController extends GetxController{

  PageController pageController = PageController();
  OpenRouteService openrouteservice = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248a0d4e2838ca744eaa52576fb4bd191c9');

  RxList<LatLng> locations = <LatLng>[].obs;


  RxList<Marker> markers = <Marker>[].obs;
  RxList<Polyline> polyLines = <Polyline>[].obs;
  RxList<Color> colors = <Color>[].obs;

  RxList<CarpoolSeeker> requestsList = <CarpoolSeeker>[].obs;

  initialize(){
     locations.add(LatLng(_eventDetailController.event.first.location.latitude,_eventDetailController.event.first.location.longitude));
     locations.add(LatLng(_profileController.user.first.baseLocation!.latitude,_profileController.user.first.baseLocation!.longitude));
     for (var i in requestsList) {
       colors.add(Colors.grey);
     }

  }

  Future<void> submitProvider() async {
    CustomUtils.showLoading();
    User user = _profileController.user.first;
    String eventId = _eventDetailController.event.first.eventId;
    var data = {
      "user_id":user.userId,
      "event_id":eventId,
      "start_location_id":user.baseLocation!.locationId,
      "member_carpool_type":"provider",
      "seats":user.seats
    };
    var result = await ApiService.postData(endPoint: 'Member', data: data);
    log(result.toString());
    await _eventDetailController.getUserType();
    Get..back()..back();
  }

  Future<void> updateRequestStatus(String carpoolMemberId,String providerMemberId,bool status) async {
    CustomUtils.showLoading();
    if(status){
      var response = await ApiService.getData(endPoint: 'Member($providerMemberId)');
      int seats = jsonDecode(jsonEncode(response))['seats'];
      if(seats != 0){
        seats -= 1;
        await ApiService.patchData(endPoint: 'Member($providerMemberId)', data:{'seats':seats});
      }
    }
    Map<String,dynamic> body = {
      'status':status ? 'approved':'cancelled'
    };
    await ApiService.patchData(endPoint: 'Carpool_Member($carpoolMemberId)', data: body);
    Get.back();

  }

  Future<void> addPolyline() async {
    CustomUtils.showLoading();
    LatLng eventLoc = locations.first;
    LatLng userLoc = locations[1];

    markers.add(CustomMarker.buildPin(eventLoc));
    markers.add(CustomMarker.buildPin(userLoc,color: Colors.green));

    final List<ORSCoordinate> routeCoordinates =
        await openrouteservice.directionsRouteCoordsGet(
      profileOverride: ORSProfile.drivingCar,
      startCoordinate:  ORSCoordinate(
        latitude: userLoc.latitude,
        longitude: userLoc.longitude,
      ),
      endCoordinate: ORSCoordinate(
        latitude: eventLoc.latitude,
        longitude: eventLoc.longitude,
      ),
    );

    final List<LatLng> routePoints = routeCoordinates
        .map(
            (coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();

    // Create Polyline (requires Material UI for Color)
    Polyline routePolyline = Polyline(
      // polylineId: PolylineId('route'),
      // visible: true,
        points: routePoints,
        color: Colors.blue,
        strokeWidth: 4
      // width: 4,
    );
    polyLines.add(routePolyline);
    Get.back();
  }


  void addMarker() async {

    List<LatLng> latLngList = requestsList.map((e)=>LatLng(e.seekerMember.startLocation.latitude, e.seekerMember.startLocation.longitude)).toList();
    for (int i = 0; i < latLngList.length; i++) {
      markers.add(CustomMarker.buildUser(latLngList[i], onTap: () {
        pageController.animateToPage(i,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear);
        for (int j = 0; j < colors.length; j++) {
          colors[j] = Colors.grey;
        }
        colors[i] = Colors.lightBlue;

        addMarker();

      },
          color: colors[i],
      ));


    }

  }

}