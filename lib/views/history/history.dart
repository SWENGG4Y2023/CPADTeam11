import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/event/event_controller.dart';
import '../../models/event/event.dart';
import '../events/widgets/event_widget.dart';

final _eventController = Get.find<EventController>();

class HistoryEvents extends StatelessWidget {
  const HistoryEvents({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Event> eventList = _eventController.eventList
          .where((p0) => DateTime.now().isAfter(p0.eventDate))
          .toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'History',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: eventList.isNotEmpty
                ? ListView.builder(
                    itemCount: eventList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Event item = eventList[index];
                      return EventWidget(item: item);
                    })
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy_outlined,
                            color: Colors.grey,
                            size: 50,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'There are no Events',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
