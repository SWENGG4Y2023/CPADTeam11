
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sapride/controllers/event/seeker_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/event/event_detail_controller.dart';
import '../../../models/event/member.dart';
import '../../../util/tile_providers.dart';
import '../widgets/driver_card.dart';

final _eventDetailController = Get.find<EventDetailController>();
final _seekerController = Get.find<SeekerController>();
class SeekerMapView extends StatelessWidget {
  const SeekerMapView(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_eventDetailController.event.first.eventName),
      ),
      body: SafeArea(
        child: Obx(
           () {
             LatLng initialLoc = LatLng(
                 _eventDetailController.event.first.location.latitude,
                 _eventDetailController.event.first.location.longitude);
             List<Marker> markers = _seekerController.markers.value;
             List<Polyline> polyLines = _seekerController.polyLines.value;
            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                      initialCenter: initialLoc,
                      initialZoom: 10,
                      onMapReady: () async {
                        await _seekerController.addPolyLines();
                        _seekerController.addMarker();
                      }
                      ),
                  children: [
                    openStreetMapTileLayer,
                    RichAttributionWidget(
                      popupInitialDisplayDuration: const Duration(seconds: 5),
                      animationConfig: const ScaleRAWA(),
                      showFlutterMapAttribution: false,
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright'),
                          ),
                        ),
                        const TextSourceAttribution(
                          'This attribution is the same throughout this app, except '
                          'where otherwise specified',
                          prependCopyright: false,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: markers,
                      rotate: true,
                    ),
                    PolylineLayer(polylines: polyLines),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 1.sw,
                    constraints: BoxConstraints(maxHeight: 0.25.sh),
                    child: PageView.builder(
                        controller: _seekerController.pageController,
                        itemCount: _seekerController.rideProviders.length,
                        itemBuilder: (context, index) {
                          Member provider = _seekerController.rideProviders[index];
                          return DriverCard(
                            rideProvider: provider,
                          );
                        }),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
