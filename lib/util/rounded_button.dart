import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RRectangleButton extends StatelessWidget {
  const RRectangleButton({
    super.key,
    required this.text,
    this.invert = false,
    this.onTap
  });

  final String text;
  final bool invert;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 1.sw,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration:  ShapeDecoration(
            shape: StadiumBorder(
              side:invert ? const BorderSide(
                color: Colors.lightBlue
              ) : BorderSide.none
            ),
            color: invert ? Colors.white : Colors.lightBlue
        ),
        child:  Text(text,style: TextStyle(
            color: invert ? Colors.lightBlue : Colors.white,
            fontWeight: FontWeight.w500
        ),),
      ),
    );
  }
}