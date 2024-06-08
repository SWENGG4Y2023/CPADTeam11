import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMarker {
  static Marker buildPin(LatLng point,
          {Function()? onTap, Color color = Colors.red}) =>
      Marker(
        rotate: true,
        point: point,
        child: GestureDetector(
            onTap: onTap,
            child: Icon(Icons.location_pin, size: 40, color: color)),
        width: 60,
        height: 60,
      );


  static Marker buildUser(LatLng point,
          {Function()? onTap, Color color = Colors.black}) =>
      Marker(
        rotate: true,
        point: point,
        child: GestureDetector(
            onTap: onTap,
            child:
            Icon(
              Icons.person_pin_circle_rounded,
              color: color,
              size: 40,
            )),
        width: 60,
        height: 60,
      );
}
