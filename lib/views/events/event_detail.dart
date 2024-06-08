import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'utils.dart';

import '../../controllers/event/event_detail_controller.dart';
import '../../models/event/event.dart';
import '../../models/event/carpool_provider.dart';
import '../../util/rounded_button.dart';

final _eventDetailController = Get.find<EventDetailController>();

class EventDetail extends StatelessWidget {
  const EventDetail({super.key,});


  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (pop){
        _eventDetailController.clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_eventDetailController.event.first.eventName),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              bool registered = _eventDetailController.registered.value;
              bool provider = _eventDetailController.provider.value;
              Event event = _eventDetailController.event.first;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x40000000),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: event.eventImage,
                              height: 120,
                              fit: BoxFit.cover,
                              width: 1.sw,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.eventDescription),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Location',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.blueGrey),
                                    ),
                                    Text(
                                      DateFormat('dd MMM yy - hh:mm')
                                          .format(event.eventDate),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.blueGrey),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  event.location.name,
                                  style:  TextStyle(
                                      fontSize: 14.sp),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      '${event.location.address},${event.location.city}',
                                      style:  TextStyle(
                                        fontWeight: FontWeight.w400,
                                          fontSize: 10.sp),
                                    )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          MapsLauncher.launchCoordinates(
                                              event.location.latitude,
                                              event.location.longitude);
                                        },
                                        child: const Icon(Icons.map))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (registered && !provider)
                                  Obx(
                                     () {
                                       if(_eventDetailController.carpoolMember.isNotEmpty) {
                                         CarpoolProvider member = _eventDetailController.carpoolMember.first;
                                         return Expanded(
                                           child: Column(

                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   const Text(
                                                     'Ride',
                                                     style: TextStyle(
                                                         fontSize: 14, color: Colors.blueGrey),
                                                   ),
                                                   const SizedBox(
                                                     height: 5,
                                                   ),
                                                   Row(
                                                     mainAxisAlignment:
                                                     MainAxisAlignment.spaceBetween,
                                                     children: [
                                                       Column(
                                                         crossAxisAlignment:
                                                         CrossAxisAlignment.start,
                                                         children: [
                                                           Text('${member.providerMember.user.firstName}'
                                                               '${member.providerMember.user.lastName}',style: TextStyle(
                                                             fontSize: 14.sp,

                                                           ),),
                                                           Text(
                                                               '${member.providerMember.user.car}',style: TextStyle(
                                                             fontSize: 10.sp,

                                                           ),),
                                                           Text('${member.providerMember.user.car}  ${member.providerMember.user.seats} Seater',style: TextStyle(
                                                             fontSize: 10.sp,
                                                           ),)
                                                         ],
                                                       ),
                                                       StatusWidget(status: member.status,)
                                                     ],
                                                   ),
                                                   const SizedBox(height: 10,),
                                                 ],
                                               ),
                                               if(member.status.contains('cancelled'))
                                               RRectangleButton(
                                                 onTap: () async {
                                                  await _eventDetailController.removeSeeker(
                                                       carpoolMemberId: member.carpoolMemberId,
                                                     memberId: member.seekerMemberId
                                                   );

                                                 },
                                                 text: 'Try Again',
                                                 invert: true,
                                               ),
                                             ],
                                           ),
                                         );
                                       }
                                     return const SizedBox();
                                    }
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      if (!registered) ...[
                        RRectangleButton(
                          onTap: () {
                            _eventDetailController.navToSeeker();
                          },
                          text: 'Seeker',
                          invert: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RRectangleButton(
                          onTap: () {
                            _eventDetailController.navToProvider();

                          },
                          text: 'Provider',
                        ),
                      ],
                      if (registered && provider)
                        RRectangleButton(
                          onTap: () {
                           _eventDetailController.navToRequestsList();
                          },
                          text: 'Requests',
                        ),
                    ],
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}


