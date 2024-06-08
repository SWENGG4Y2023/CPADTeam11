

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../controllers/profile/profile_controller.dart';
import 'rounded_button.dart';

final _profileController = Get.find<ProfileController>();
class AddCarSheet extends StatelessWidget {
  const AddCarSheet({super.key});

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
                    'Vehicle Details',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              TextFormField(
                initialValue: _profileController.carName.value,
                onChanged: (value){
                  if(value.isNotEmpty){
                    _profileController.carName.value = value.trim();
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
                  labelText: 'Enter the car name',
                  labelStyle:  TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                ),
              ),
              SizedBox(height: 10.h,),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _profileController.carNumber.value,
                      onChanged: (value){
                        if(value.isNotEmpty){
                          _profileController.carNumber.value = value.trim();
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
                        labelText: 'Enter the car number',
                        labelStyle:  TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Obx(
                     () {
                       int value = _profileController.seater.value;
                      return Row(
                        children: [
                          Radio(value: value, groupValue: 5, onChanged: (value){
                            _profileController.seater.value = 5;
                          },
                            visualDensity: VisualDensity.compact,
                          ),
                          Text('5 Seater'),
                          Radio(value: value, groupValue: 7, onChanged: (value){
                            _profileController.seater.value = 7;
                          },
                            visualDensity: VisualDensity.compact,
                          ),
                          Text('7 Seater')
                        ],
                      );
                    }
                  )
                ],
              ),
              SizedBox(height: 10.h,),
              RRectangleButton(
                text: 'Proceed',
                onTap: (){
                  _profileController.saveVehicle();
                },

              ),
              const SizedBox(height: 10,),
            ],
          ),
        ));
  }
}
