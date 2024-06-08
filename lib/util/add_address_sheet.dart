import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sapride/util/rounded_button.dart';

import '../controllers/map/map_controller.dart';

final _customMapController = Get.find<CustomMapController>();

class AddAddressSheet extends StatelessWidget {
  const AddAddressSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        constraints: BoxConstraints(
          maxHeight: 6.sh,
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Address Details',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              TextField(
                onChanged: (value){
                  if(value.isNotEmpty){
                    _customMapController.addressName = value.trim();
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xffB8B8B8),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xffB8B8B8),
                      width: 1.5,
                    ),
                  ),
                  labelText: 'Enter the name',
                  labelStyle:  TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  prefixIcon: const Icon(Icons.location_city,color: Colors.lightBlue,),
                ),
              ),
              SizedBox(height: 10.h,),
               Text('Address',style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500
              ),),
              SizedBox(height: 5.h,),
              Text(_customMapController.addressLine,style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400
              ),),
              SizedBox(height: 10.h,),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('City',style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500
                      ),),
                      const SizedBox(height: 5,),
                      Text(_customMapController.city,style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400
                      ),),
                    ],
                  ),
                  SizedBox(width: 25.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text('Postal Code',style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500
                      ),),
                      Text(_customMapController.postalCode),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15.h,),
              RRectangleButton(
                text: 'Proceed',
                onTap: (){
                  _customMapController.saveAddress();
                },

              ),
              const SizedBox(height: 10,),
            ],
          ),
        ));
  }
}
