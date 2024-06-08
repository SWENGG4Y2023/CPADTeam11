import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sapride/controllers/event/event_detail_controller.dart';

import '../../../models/event/carpool_seeker.dart';



class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key, required this.user,required this.onApprove,required this.onReject});

  final CarpoolSeeker user;
  final Function() onApprove;
  final Function() onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      // height: 100,
      // width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.seekerMember.user.firstName} ${user.seekerMember.user.lastName}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                user.seekerMember.user.userEmail,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                user.seekerMember.startLocation.address,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          if (user.status.contains('requested'))
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onReject,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text(
                    'Reject',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  child: const Text(
                    'Approve',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          if (user.status.contains('approved'))
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MapsLauncher.launchCoordinates(
                       user.seekerMember.startLocation.latitude,
                        user.seekerMember.startLocation.longitude);
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: const Text(
                    'Navigate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
