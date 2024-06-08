import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sapride/util/add_address_sheet.dart';
import 'package:sapride/util/add_car_sheet.dart';
import '../../controllers/map/map_controller.dart';
import '../../controllers/profile/profile_controller.dart';

import '../../models/profile/profile.dart';
import '../../util/pick_address.dart';

final _profileController = Get.find<ProfileController>();
final _customMapController = Get.find<CustomMapController>();
class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_profileController.user.isNotEmpty) {
        User user = _profileController.user.first;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          radius: 40,
                          child: Icon(
                            Icons.person,
                            size: 40,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${user.firstName} ${user.lastName}'),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(user.userEmail),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'Address',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          if(user.baseLocation == null)
                          GestureDetector(
                            onTap: () async {
                              await _customMapController.getLocation();
                              Get.to(()=>const PickAddress());
                            },
                              child: const Icon(Icons.add))
                        ],
                      ),
                      if(user.baseLocation != null)
                           Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.baseLocation!.name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            ),
                                      ),
                                      Text(
                                        '${user.baseLocation!.address}, ${user.baseLocation!.city}',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                GestureDetector(
                                    onTap: () async {
                                      await _customMapController.getLocation();
                                      Get.to(()=>const PickAddress());
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.black87,
                                    ))
                              ],
                            ),
                      const Divider()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            children: [
                              Text(
                                'Vehicle',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          if(user.car == null)
                          GestureDetector(
                            onTap: (){
                              Get.bottomSheet(const AddCarSheet());
                            },
                              child: const Icon(Icons.add))
                        ],
                      ),
                      if(user.car != null)
                      Row(
                        children: [
                           Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.car!,
                                  style:  TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                   /*${user.carNumber}*/ 'KA01AB1234   ${user.seats} Seater' ,
                                   style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          GestureDetector(
                              onTap: () {
                                _profileController.editVehicle();
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.black87,
                              ))
                        ],
                      ),
                      const Divider()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Text('1.0.0',style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),)
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}
