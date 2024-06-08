import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/event/event_detail_controller.dart';
import '../../../controllers/event/provider_controller.dart';
import '../../../controllers/profile/profile_controller.dart';
import '../../../models/event/event.dart';
import '../../../util/rounded_button.dart';

import '../../../models/profile/profile.dart';

final _profileController = Get.find<ProfileController>();
final _eventDetailController = Get.find<EventDetailController>();
final _providerController = Get.find<ProviderController>();

class SubmitProvider extends StatelessWidget {
  const SubmitProvider({super.key,});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,),
          child: Obx(() {
            Event event = _eventDetailController.event.first;
           User user = _profileController.user.first;
            BaseLocation userBaseLocation = user.baseLocation!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Route',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(
                              value: 0,
                              groupValue: 0,
                              onChanged: (value) {},
                              activeColor: Colors.lightBlue,
                            ),
                            CustomPaint(
                                size: const Size(1, 80),
                                painter: DashedLineVerticalPainter(
                                    color: Colors.lightBlue))
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Point',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 2),
                                    decoration: ShapeDecoration(
                                        shape: StadiumBorder(
                                          side: BorderSide(
                                            color: Colors.orange
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        color: Colors.orangeAccent
                                            .withOpacity(0.2)),
                                    child: Text(
                                      userBaseLocation.name,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.deepOrange),
                                    ),
                                  ),
                                  Text(
                                    '${userBaseLocation.address}, ${userBaseLocation.city}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Radio(
                    //           value: 0,
                    //           groupValue: 0,
                    //           onChanged: (value) {},
                    //           activeColor: Colors.blueGrey,
                    //         ),
                    //         CustomPaint(
                    //             size: const Size(1, 50),
                    //             painter: DashedLineVerticalPainter(
                    //                 color: Colors.lightBlue))
                    //       ],
                    //     ),
                    //     Expanded(
                    //       child: Column(
                    //         children: [
                    //           const Row(
                    //             children: [
                    //               Text(
                    //                 'Via',
                    //                 style: TextStyle(
                    //                   color: Colors.grey,
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 ' (Optional)',
                    //                 style: TextStyle(
                    //                   color: Colors.grey,
                    //                   fontSize: 10,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           TextField(
                    //             onChanged: (value){
                    //               _eventDetailController.route = value;
                    //             },
                    //             decoration: InputDecoration(
                    //               contentPadding: const EdgeInsets.symmetric(
                    //                   horizontal: 10),
                    //               border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               enabledBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               focusedBorder: OutlineInputBorder(
                    //                   borderRadius: BorderRadius.circular(8),
                    //                   borderSide: const BorderSide(
                    //                       color: Colors.lightBlue)),
                    //             ),
                    //           ),
                    //           const SizedBox(
                    //             height: 30,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio(
                          value: 0,
                          groupValue: 0,
                          onChanged: (value) {},
                          activeColor: Colors.lightBlue,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Drop Point',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: ShapeDecoration(
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: Colors.orange.withOpacity(0.5),
                                      ),
                                    ),
                                    color:
                                        Colors.orangeAccent.withOpacity(0.2)),
                                child: Text(
                                  event.location.name,
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.deepOrange),
                                ),
                              ),
                              Text(
                                '${event.location.address}, ${event.location.city}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Vehicle',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                    Row(
                      children: [
                         Expanded(
                            child: Text(
                              user.car??'',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            )),
                         Row(
                          children: [
                            const Icon(
                              Icons.event_seat_sharp,
                              color: Colors.grey,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(user.seats.toString()),
                          ],
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.black, width: 0.5),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x40000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 2))
                                ]),
                            child: const Text(
                              //user.carNumber
                              'KA 01 AB 1234',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            )),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                     RRectangleButton(text: 'Submit',onTap: (){
                       _providerController.submitProvider();

                    },),
                    const SizedBox(height: 10,),
                  ],
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  DashedLineVerticalPainter({this.color = Colors.grey});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
