import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape:  StadiumBorder(
              side: BorderSide(
                  color: getColorCode() == 1 ? Colors.greenAccent : getColorCode() == 2 ? Colors.redAccent : Colors.amberAccent)),
          color: (getColorCode() == 1 ? Colors.greenAccent : getColorCode() == 2 ? Colors.redAccent : Colors.amberAccent)
              .withOpacity(0.2)),
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 2),
      child: Text(
        status.toUpperCase(),
        style:  TextStyle(
          color: getColorCode() == 1 ? Colors.green : getColorCode() == 2 ? Colors.red : Colors.amber,
        ),
      ),
    );
  }

  int getColorCode(){
    switch(status){
      case 'approved':
        return 1;
      case 'cancelled':
        return 2;
      default :
        return 0;
    }
  }
}