
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class CustomUtils{

  static showLoading(){
    Get.dialog(
        useSafeArea: true,
        Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              height: 60,
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration:  BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(12)
              ),
              child: SpinKitThreeBounce(
                color: Colors.lightBlue,
                size: 29,
              ),
            ),
          ),
        )
    );
  }
}