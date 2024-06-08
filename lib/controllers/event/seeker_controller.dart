

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:sapride/controllers/event/event_detail_controller.dart';

import '../../models/event/member.dart';
import '../../models/profile/profile.dart';
import '../../services/api_service.dart';
import '../../util/loading_dialog.dart';
import '../../util/pin_marker.dart';
import '../profile/profile_controller.dart';

final _profileController = Get.find<ProfileController>();
final _eventDetailController = Get.find<EventDetailController>();
class SeekerController extends GetxController{

  RxList<Member> rideProviders = <Member>[].obs;

  RxList<LatLng> locations = <LatLng>[].obs;

  PageController pageController = PageController();
  OpenRouteService openrouteservice = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248a0d4e2838ca744eaa52576fb4bd191c9');


  RxList<Marker> markers = <Marker>[].obs;
  RxList<Polyline> polyLines = <Polyline>[].obs;

  RxList<Color> colors = <Color>[].obs;

  initialize(){
    locations.add(LatLng(_eventDetailController.event.first.location.latitude,_eventDetailController.event.first.location.longitude));
    locations.add(LatLng(_profileController.user.first.baseLocation!.latitude,_profileController.user.first.baseLocation!.longitude));
    for (var i in rideProviders) {
      colors.add(Colors.grey);
    }

  }

  Future<void> addPolyLines() async {
    CustomUtils.showLoading();
    LatLng eventLoc = locations.first;
    LatLng userLoc = locations[1];

    List<LatLng> latLngList = rideProviders.map((e)=>LatLng(e.startLocation.latitude, e.startLocation.longitude)).toList();


    markers.add(CustomMarker.buildPin(eventLoc));
    markers.add(CustomMarker.buildPin(userLoc, color: Colors.green));
    for (int i = 0; i < latLngList.length; i++) {
      final List<ORSCoordinate> routeCoordinates =
      await openrouteservice.directionsRouteCoordsGet(
        profileOverride: ORSProfile.drivingCar,
        startCoordinate: ORSCoordinate(
          latitude: latLngList[i].latitude,
          longitude: latLngList[i].longitude,
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
      Polyline routePolyline = Polyline(
        // polylineId: PolylineId('route'),
        // visible: true,
          points: routePoints,
          color: Colors.blue,
          strokeWidth: 4
        // width: 4,
      );
      polyLines.add(routePolyline);
    }
    Get.back();
  }

  void addMarker() async {
    CustomUtils.showLoading();
    List<LatLng> latLngList = rideProviders.map((e)=>LatLng(e.startLocation.latitude, e.startLocation.longitude)).toList();

    for (int i = 0; i < latLngList.length; i++) {
      markers.add(CustomMarker.buildUser(
        latLngList[i],
        onTap: () {
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
    Get.back();
  }

  Future<void> addSeekerRequest(String providerMemberId) async {
    CustomUtils.showLoading();
    String eventId = _eventDetailController.event.first.eventId;
    User user = _profileController.user.first;
    Map<String,dynamic> body = {
      "user_id":user.userId,
      "event_id":eventId,
      "start_location_id":user.baseLocation!.locationId,
      "member_carpool_type":"seeker",
    };
    var response = await ApiService.postData(endPoint: 'Member', data: body);
    String seekerMemberId = jsonDecode(jsonEncode(response))['member_id'];
    var body2 = {
      "provider_member_id":providerMemberId,
      "seeker_member_id":seekerMemberId,
      "event_id":eventId,
      "status":"requested"
    };
    await ApiService.postData(endPoint: 'Carpool_Member', data: body2);
    await _eventDetailController.getRideStatus(seekerMemberId);
    await _eventDetailController.getUserType();
    Get.back();
    Get.snackbar('Success', "Ride Requested");

  }
}