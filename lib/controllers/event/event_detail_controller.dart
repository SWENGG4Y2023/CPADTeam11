import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'provider_controller.dart';
import 'seeker_controller.dart';
import '../profile/profile_controller.dart';
import '../../models/event/member.dart';
import '../../models/event/carpool_seeker.dart';
import '../../models/event/carpool_provider.dart';
import '../../services/api_service.dart';
import '../../util/loading_dialog.dart';

import '../../models/event/event.dart';
import '../../models/profile/profile.dart';
import '../../views/events/provider/requests_list.dart';
import '../../views/events/provider/submit_provider.dart';
import '../../views/events/seeker/seeker_map_view.dart';

final _profileController = Get.find<ProfileController>();
final _providerController = Get.find<ProviderController>();
final _seekerController = Get.find<SeekerController>();
class EventDetailController extends GetxController {

  RxList<CarpoolProvider> carpoolMember = <CarpoolProvider>[].obs;
   String  route = "";

   String providerMemberId = '';

   RxBool registered = false.obs,provider=false.obs;

   RxList<Event> event = <Event>[].obs;




  Future<void> getRideStatus(String seekerMemberId) async {
    String eventId = event.first.eventId;
    var response = await ApiService.getData(endPoint: 'Carpool_Member?\$filter=(event_id eq $eventId and seeker_member_id eq $seekerMemberId)&\$expand=provider_member(\$expand=start_location,user)');
    log(response.toString());
    var res = jsonDecode(jsonEncode(response))['value'];
    carpoolMember.value = List<CarpoolProvider>.from(res.map((e)=>CarpoolProvider.fromJson(e)));
  }

  Future<void> navToSeeker() async {
    User user = _profileController.user.first;
    Event locEvent = event.first;
   if(user.baseLocation != null) {
     var response = await ApiService.getData(endPoint: 'Member?\$filter=event_id eq ${locEvent.eventId} and member_carpool_type eq \'provider\'&\$expand=user,start_location');
     log(response.toString());
     var result = jsonDecode(jsonEncode(response));
     List<Member> rideProviders = List<Member>.from(result['value'].map((e)=>Member.fromJson(e)));
     rideProviders.removeWhere((e)=>e.seats == 0);
     if(rideProviders.isNotEmpty) {
       _seekerController.rideProviders.value = rideProviders;
       _seekerController.initialize();
       Get.to(() =>
           const SeekerMapView());
     }else{
       Get.snackbar("Error", "No Providers available");
     }
   }else{
     Get.snackbar("Error", "Kindly update your Address details to proceed");
   }
  }

  Future<void> navToRequestsList() async {
   CustomUtils.showLoading();
   Event locEvent = event.first;
   var response = await ApiService.getData(endPoint: 'Carpool_Member?\$filter=(event_id eq ${locEvent.eventId} and provider_member_id eq $providerMemberId)&\$expand=seeker_member(\$expand=start_location,user)');

   var res = jsonDecode(jsonEncode(response))['value'];
   List<CarpoolSeeker> requestsList = List<CarpoolSeeker>.from(res.map((e)=>CarpoolSeeker.fromJson(e)));
   Get.back();
   _providerController.requestsList.value = requestsList;
   _providerController.initialize();
    Get.to(() =>  const RequestsList());
  }



  void navToProvider(){
    User user = _profileController.user.first;
    if(user.baseLocation != null && user.car != null) {
      Get.to(() =>
          const SubmitProvider());
    }else{
      Get.snackbar("Error", "Kindly update your Address and vehicle details to proceed");
    }
  }



  Future<void> getUserType() async {

    if(_profileController.user.isNotEmpty) {
      CustomUtils.showLoading();
      User user = _profileController.user.first;
      String eventId = event.first.eventId;
      var response = await ApiService.getData(
          endPoint: 'Member?\$filter=(event_id eq $eventId and user_id eq ${user
              .userId})&\$expand=start_location');
      log(response.toString());
      List list = jsonDecode(jsonEncode(response))['value'];
      if (list.isNotEmpty) {
        registered.value = true;
        String type = list[0]['member_carpool_type'];
        if (type.contains('provider')) {
          provider.value = true;
          providerMemberId = list[0]['member_id'];
        } else {
          provider.value = false;
          String seekerMemberId = list[0]['member_id'];
          getRideStatus(seekerMemberId);
        }
      }
      Get.back();
    }
  }



  Future<void> removeSeeker({required String carpoolMemberId, required String memberId}) async {
    CustomUtils.showLoading();
    await ApiService.deleteData(endPoint: 'Member($memberId)');
    await ApiService.deleteData(endPoint: 'Carpool_Member($carpoolMemberId)');
    carpoolMember = <CarpoolProvider>[].obs;
    providerMemberId = '';
    registered = false.obs;
    provider=false.obs;
    getUserType();
    Get.back();
    navToSeeker();
  }

  void clear(){
     carpoolMember = <CarpoolProvider>[].obs;
      route = "";
     providerMemberId = '';
     registered = false.obs;
     provider=false.obs;
     event = <Event>[].obs;
  }
}
