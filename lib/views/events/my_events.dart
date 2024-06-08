

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sapride/controllers/event/event_detail_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../controllers/profile/profile_controller.dart';
import 'event_detail.dart';
import '../../controllers/event/event_controller.dart';
import 'widgets/event_widget.dart';

import '../../models/event/event.dart';

final _eventController = Get.find<EventController>();
final _eventDetailController = Get.find<EventDetailController>();
class MyEvents extends StatelessWidget {
   const MyEvents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
            () {
          List<Event> filterList = _eventController.filterList;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                   Text(_eventController.headerDate.value, style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24
                  ),),
                  GestureDetector(
                      onTap: () {
                        _eventController.showCalender.value = !_eventController.showCalender.value;
                      },
                      child: const Icon(Icons.calendar_today)),
              ]
              ),
              const SizedBox(height: 10,),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 500),
                  firstChild: Container(),
                  secondChild: TableCalendar(
                      focusedDay: _eventController.now,
                      firstDay: _eventController.now,
                      lastDay: DateTime(_eventController.now.year,12,31),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      titleTextFormatter: (date,val){
                        return DateFormat('MMMM').format(date);
                      },
                    ),
                    calendarFormat: CalendarFormat.month,
                    dayHitTestBehavior: HitTestBehavior.translucent,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                      ),
                      weekendStyle: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    onDaySelected: (date1,date2){
                        _eventController.selectedDate = date1;
                        _eventController.applyFilter();
                        _eventController.getDay();
                    },
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    selectedDayPredicate: (day) {

                      return  isSameDay(_eventController.selectedDate, day);
                    },
                    calendarBuilders: CalendarBuilders(
                    markerBuilder: (context,date1,value){
                     List<DateTime> dates = [];
                     dates = _eventController.eventList.map((e) => e.eventDate).toList();
                     for(var i in dates){
                       if(isSameDay(date1,i)){
                         return const Align(
                           alignment: Alignment.bottomCenter,
                             child: Icon(Icons.circle,color: Colors.lightBlueAccent,size: 7,));
                       }
                     }
                      return null;
                    }
                    ),
                  ), crossFadeState: _eventController.showCalender.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                ),
              Expanded(
                  child: _eventController.loadingEvents.value ?
                  const Center(child: SpinKitThreeBounce(
                    color: Colors.lightBlue,
                    size: 29,
                  ),) :
                  _eventController.eventsFailed.value ?
                  const Center(child: Text('Something Went Wrong'),) :
                      filterList.isNotEmpty ?
                  ListView.builder(
                      itemCount: filterList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Event item = filterList[index];
                        return EventWidget(
                          item: item,
                          onTap: () {
                            _eventDetailController.event.value = [item];
                            _eventController.navToEventDetail(item);

                          },
                        );
                      }) : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy_outlined,color: Colors.grey,size: 50,),
                          SizedBox(height: 10,),
                          Text('There are no Events Scheduled for Today',style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12
                          ),),
                        ],
                      )


              ),
            ],
          );
        }
    );
  }
}