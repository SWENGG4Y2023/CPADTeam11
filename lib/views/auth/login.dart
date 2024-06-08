import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sapride/controllers/auth/auth.dart';

final _loginController = Get.find<LoginController>();

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 20.0.h,horizontal: 26.w),
          child: Obx(
             () {
               bool loginValue = _loginController.loginLoading.value;
               bool loginCheck = _loginController.check();
              return SingleChildScrollView(
                child: Column(
                  children: [
                     SizedBox(height: 200,
                    child: SvgPicture.asset("asset/svg/sap_logo.svg")
                      ,),
                     SizedBox(height: 18.h,),
                    TextFormField(
                      onChanged: (text){
                        String val = text.trim();
                        if(val.isNotEmpty){
                          _loginController.email.value = val;
                        }else{
                          _loginController.email.value='';
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        String txt = value!.trim();
                        return txt.isNotEmpty ? null : 'Kindly enter a valid Email/I number';
                      },
                      style:  TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontFamily: 'ProximaNova'
                      ),
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
                        labelText: 'Enter your Official Mail ID',
                        labelStyle:  TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        prefixIcon: const Icon(Icons.email_outlined,color: Colors.lightBlue,),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                     SizedBox(height: 16.h,),
                    TextFormField(
                      onChanged: (val){
                        String text = val.trim();
                        if(text.isNotEmpty && text.length >= 15){
                          _loginController.password.value = text;
                        }else{
                          _loginController.password.value = '';
                        }
                      },
                      style:  TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: 'ProximaNova'
                      ),
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
                        labelText: 'Enter your password',
                        labelStyle:  TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                        prefixIcon: const Icon(Icons.password,color: Colors.lightBlue,),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        return value!.trim().length < 15 ? 'Kindly enter 15 digit password' : null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                     SizedBox(height: 26.h,),
                    GestureDetector(
                      onTap: (){
                        if(loginCheck) {
                          _loginController.login();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: !loginCheck ? Colors.black26 : Colors.lightBlue,
                          borderRadius: BorderRadius.circular(12.r)
                        ),
                        padding:  EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 20.w
                        ),
                        alignment: Alignment.center,
                        child: loginValue ? const SpinKitThreeBounce(
                          color: Colors.white,
                          size: 29,
                        ) :  Text('Sign In',
                          style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),),
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
