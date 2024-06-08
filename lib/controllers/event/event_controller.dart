import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sapride/services/api_service.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event/event.dart';
import '../../views/events/event_detail.dart';
import 'event_detail_controller.dart';

final _eventDetailController = Get.find<EventDetailController>();
class EventController extends GetxController {
  RxBool showCalender = false.obs;
  final DateTime now = DateTime.now();
  DateTime selectedDate = DateTime.now();
  RxString headerDate = 'Today'.obs;

  RxList<Event> eventList = <Event>[].obs;
  RxList<Event> filterList = <Event>[].obs;

  RxBool loadingEvents = false.obs;
  RxBool eventsFailed = false.obs;



  void getEvents() async {
    loadingEvents.value = true;
    eventsFailed.value = false;
    var result = await ApiService.getData(endPoint: 'Event?\$expand=location');
    loadingEvents.value = false;

    if (result != null) {
      log(result.toString());
      eventList.value =
          List<Event>.from(result['value'].map((e) => Event.fromJson(e)))
              .toList();

      filterList.value = eventList
          .where((p0) => isSameDay(p0.eventDate, selectedDate))
          .toList();

    } else {
      //todo
      // eventsFailed.value = true;
    }
    eventList.add(
        Event(
            createdAt: DateTime.now(),
            createdBy: "",
            modifiedAt: DateTime.now(),
            modifiedBy: "",
            eventId: "571a94cf-7ea9-4779-8625-9c7a4fd487e6",
            eventName: "SAP DKOM",
            eventDate: DateTime.now().add(const Duration(days: 1)),
            eventDescription: "Developers meet",
            locationId: "16ed4cf9-e5e4-461f-8546-2b68e2869e69",
            eventImage: "https://picsum.photos/200/300",
            teamId: "",
            location: Location(
                createdAt: DateTime.now(),
                name: "SAP Labs",
                address: "KIADB Export Promotion Industrial Area, Whitefield, Bengaluru, Karnataka 560048",
                city: 'Bengaluru',
                country: 'India',
                createdBy: "",
                latitude: 12.9798034,
                locationId:"16ed4cf9-e5e4-461f-8546-2b68e2869e69" ,
                longitude: 77.7159617,
                modifiedAt: DateTime.now(),
                modifiedBy: "",
                state: 'Karnataka'

            )
        )
    );
     eventList.add(
        Event(
            createdAt: DateTime.now(),
            createdBy: "",
            modifiedAt: DateTime.now(),
            modifiedBy: "",
            eventId: "571a94cf-7ea9-4779-8625-9c7a4fd487e7",
            eventName: "Test event",
            eventDate: DateTime.now().add(const Duration(days: 2)),
            eventDescription: "Developers Connect",
            locationId: "16ed4cf9-e5e4-461f-8546-2b68e2869e69",
            eventImage: "https://picsum.photos/200/300",
            teamId: "",
            location: Location(
                createdAt: DateTime.now(),
                name: "SAP Labs",
                address: "KIADB Export Promotion Industrial Area, Whitefield, Bengaluru, Karnataka 560048",
                city: 'Bengaluru',
                country: 'India',
                createdBy: "",
                latitude: 12.9798034,
                locationId:"16ed4cf9-e5e4-461f-8546-2b68e2869e69" ,
                longitude: 77.7159617,
                modifiedAt: DateTime.now(),
                modifiedBy: "",
                state: 'Karnataka'

            )
        )
    );
  }


  void getDay() {
    if (isSameDay(selectedDate, now)) {
      headerDate.value = 'Today';
    } else if (isSameDay(selectedDate, now.add(const Duration(days: 1)))) {
      headerDate.value = 'Tomorrow';
    } else {
      headerDate.value = DateFormat('dd MMM').format(selectedDate);
    }
  }

  void applyFilter() {
    filterList.value =
        eventList.where((p0) => isSameDay(p0.eventDate, selectedDate)).toList();
    if(filterList.isNotEmpty){
      showCalender.value = false;
    }
  }

  Future<void> navToEventDetail(Event event) async {
    await _eventDetailController.getUserType();
    Get.to(() => EventDetail());
  }

  void clear(){
     showCalender = false.obs;
     selectedDate = DateTime.now();
     headerDate = 'Today'.obs;
     eventList = <Event>[].obs;
     filterList = <Event>[].obs;
     loadingEvents = false.obs;
     eventsFailed = false.obs;
  }
}
