import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sapride/controllers/event/provider_controller.dart';
import 'package:sapride/models/event/carpool_seeker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/event/event_detail_controller.dart';
import '../../../util/tile_providers.dart';
import '../widgets/employee_card.dart';

final _eventDetailController = Get.find<EventDetailController>();
final _providerController = Get.find<ProviderController>();

class RequestsList extends StatelessWidget {
  const RequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_eventDetailController.event.first.eventName),
      ),
      body: SafeArea(
        child: Obx(() {
          LatLng initialLoc = LatLng(
              _eventDetailController.event.first.location.latitude,
              _eventDetailController.event.first.location.longitude);
          List<Marker> markers = _providerController.markers.value;
          List<Polyline> polyLines = _providerController.polyLines.value;
          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                    initialCenter: initialLoc,
                    initialZoom: 10,
                    onMapReady: () async {
                      await _providerController.addPolyline();
                      _providerController.addMarker();
                    }),
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
                  // height: 0.5.sh,
                  width: 1.sw,
                  constraints: BoxConstraints(maxHeight: 0.25.sh),
                  child: PageView.builder(
                      controller: _providerController.pageController,
                      itemCount: _providerController.requestsList.length,
                      itemBuilder: (context, index) {
                        CarpoolSeeker user =
                            _providerController.requestsList[index];
                        return EmployeeCard(
                          user: user,
                          onReject: () async {
                            await _providerController.updateRequestStatus(
                                user.carpoolMemberId,
                                user.providerMemberId,
                                false);
                            _providerController.requestsList.removeWhere((e) =>
                                e.carpoolMemberId == user.carpoolMemberId);
                            _providerController.addMarker();
                          },
                          onApprove: () async {
                            await _providerController.updateRequestStatus(
                                user.carpoolMemberId,
                                user.providerMemberId,
                                true);
                            _providerController.requestsList[index].status =
                                'approved';
                            _providerController.addMarker();
                          },
                        );
                      }),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
