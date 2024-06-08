import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../models/event/event.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({
    super.key,
    required this.item,
    this.onTap
  });

  final Event item;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12,horizontal: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0,4),
                  blurRadius: 4
              )
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: 'https://picsum.photos/200/300',
                height: 100,
                fit: BoxFit.cover,
                width: 1.sw,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(item.eventName,style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                      Text(DateFormat('dd MMM').format(item.eventDate),style: const TextStyle(
                          fontSize: 12,
                        color: Colors.blueGrey
                      ),),
                    ],
                  ),
                  const SizedBox(height: 2,),
                  const Text('Bengaluru',style: TextStyle(
                    fontSize: 12
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}