import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapride/controllers/home/home_controller.dart';

import '../events/my_events.dart';
import '../history/history.dart';
import '../profile/profile.dart';

final _homeController = Get.find<HomeController>();

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int index = _homeController.currentIndex.value;
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: index == 0
                ?  const MyEvents()
                : index == 1
                    ? const HistoryEvents()
                    : const Profile(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightBlue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'My Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: (index) {
            _homeController.switchPage(index);
          },
          currentIndex: index,
        ),
      );
    });
  }
}





