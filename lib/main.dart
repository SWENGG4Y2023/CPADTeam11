import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sapride/controllers/event/event_controller.dart';
import 'package:sapride/services/api_service.dart';
import 'package:sapride/services/get_initialize.dart';
import 'package:sapride/views/home/home.dart';

import 'controllers/profile/profile_controller.dart';
import 'views/auth/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetInitialize.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_,child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SAP Ride',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
            fontFamily: 'poppins',
          ),
          home:  const Splash(),
        );
      }
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {



  @override
  void initState() {
    super.initState();

    ApiService().refreshToken().then((session) async {
      await Future.delayed(const Duration(seconds: 5));
      if(session){
        final eventController = Get.find<EventController>();
        final profileController = Get.find<ProfileController>();
        eventController.getEvents();
        profileController.getUserDetail();
        Get.offAll(()=>const Home());
      }else{
        Get.offAll(()=>const Login());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("asset/svg/sap_logo.svg"),
            const SizedBox(height: 15,),
            const SpinKitThreeBounce(
              color: Colors.lightBlue,
              size: 10,
            )
          ],
        ),
      ),
    );
  }
}



