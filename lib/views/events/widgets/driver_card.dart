
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sapride/controllers/event/seeker_controller.dart';
import 'package:sapride/models/event/member.dart';
import 'package:sapride/util/rounded_button.dart';

import '../../../controllers/event/event_detail_controller.dart';

final _seekerController = Get.find<SeekerController>();
class DriverCard extends StatelessWidget {
  const DriverCard({
    super.key,
    required this.rideProvider
  });

  final Member rideProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all( 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${rideProvider.user.firstName} ${rideProvider.user.lastName}',style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500
                  ),),
                  Text(rideProvider.user.userEmail,style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500
                  ),),
                  Text(rideProvider.startLocation.address,style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500
                  ),),
                  const SizedBox(height: 5,),
                  Text('Vehicle Details',style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey
                  ),),
                  Text(rideProvider.user.car!,style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500
                  ),),
                  Row(
                    children: [
                      Text(rideProvider.user.car!,style: TextStyle(
                          fontSize: 10.sp,
                      ),),
                      const SizedBox(width: 10,),
                      Text('${rideProvider.user.seats} Seater',style: TextStyle(
                        fontSize: 10.sp,
                      ),),
                    ],
                  ),

                ],
              ),
            ],
          ),
           RRectangleButton(text: 'Request',invert: true,onTap: ()  {
             _seekerController.addSeekerRequest(rideProvider.memberId);
            Get.back();
          },)
        ],
      ),
    );
  }
}