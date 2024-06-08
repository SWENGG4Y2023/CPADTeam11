import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/map/map_controller.dart';
import '../models/osm_data.dart';
import 'pin_marker.dart';
import 'tile_providers.dart';

final _customMapController = Get.find<CustomMapController>();
class PickAddress extends StatefulWidget {
  const PickAddress({super.key});

  @override
  State<PickAddress> createState() => _PickAddressState();
}

class _PickAddressState extends State<PickAddress> {

  MapController mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode =  FocusNode();
  Timer? _debounce;
  List<OSMData> _options = <OSMData>[];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Address'),
        actions: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: GestureDetector(
              onTap: (){
               _customMapController.lat.value = mapController.camera.center.latitude;
               _customMapController.long.value = mapController.camera.center.longitude;
               _customMapController.getAddress();

              },
                child: const Icon(Icons.check,color: Colors.black,size: 25,)),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(
           () {
             double lat = _customMapController.lat.value;
             double long = _customMapController.long.value;
            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, long),
                    initialZoom: 15,
                    onMapEvent: (event){
                      _customMapController.markers.clear();
                      _customMapController.markers.add(
                          CustomMarker.buildPin(event.camera.center));
                    }

                    // onTap: (position, latLang) async {
                    //   markers.clear();
                    //   markers.add(buildPin(LatLng(lat, long)));
                    //   markers.add(buildPin(latLang));
                    //   final List<
                    //       ORSCoordinate> routeCoordinates = await openrouteservice
                    //       .directionsRouteCoordsGet(
                    //     profileOverride: ORSProfile.drivingCar,
                    //     startCoordinate: ORSCoordinate(
                    //       latitude: lat, longitude: long,),
                    //     endCoordinate: ORSCoordinate(latitude: latLang.latitude,
                    //       longitude: latLang.longitude,),
                    //   );
                    //
                    //   // Print the route coordinates
                    //   routeCoordinates.forEach(print);
                    //
                    //   final List<LatLng> routePoints = routeCoordinates
                    //       .map((coordinate) =>
                    //       LatLng(coordinate.latitude, coordinate.longitude))
                    //       .toList();
                    //
                    //   // Create Polyline (requires Material UI for Color)
                    //   Polyline routePolyline = Polyline(
                    //     // polylineId: PolylineId('route'),
                    //     // visible: true,
                    //       points: routePoints,
                    //       color: Colors.blue,
                    //       strokeWidth: 4
                    //     // width: 4,
                    //   );
                    //
                    //   polyLines.clear();
                    //   polyLines.add(routePolyline);
                    //   setState(() {
                    //
                    //   });
                    //   // log(routePoints.length.toString());
                    //   // log(routePoints[6].latitude.toString());
                    //   // for(int i=0;i<routePoints.length;i++){
                    //   //
                    //   //   vehicle.add(buildVehicle(routePoints[i]));
                    //   //
                    //   //   if(i < routePoints.length-1) {
                    //   //     log((routePoints.length-1).toString());
                    //   //     log(i.toString());
                    //   //     log((i+1).toString());
                    //   //     double lat2 = routePoints[i+1].latitude;
                    //   //     double long2 = routePoints[i+1].latitude;
                    //   //     double bearing = Geolocator.bearingBetween(
                    //   //         routePoints[i].latitude,
                    //   //         routePoints[i].longitude,
                    //   //        lat2,
                    //   //       long2
                    //   //     );
                    //   //     angle = bearing;
                    //   //     log('angle $angle');
                    //   //   }
                    //   //
                    //   //   setState(() {
                    //   //   });
                    //   //
                    //   //   await Future.delayed(const Duration(seconds: 2));
                    //   //   vehicle.removeRange(0, vehicle.length);
                    //   // }
                    // },
                  ),
                  mapController: mapController,
                  children: [
                    openStreetMapTileLayer,
                    RichAttributionWidget(
                      popupInitialDisplayDuration: const Duration(seconds: 5),
                      animationConfig: const ScaleRAWA(),
                      showFlutterMapAttribution: false,
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () =>
                              launchUrl(
                                Uri.parse(
                                    'https://openstreetmap.org/copyright'),
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
                      markers:_customMapController.markers,
                      rotate: true,
                    ),

                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  constraints: BoxConstraints(maxHeight: 0.4.sh),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          onChanged: (String value) {
                            if (_debounce?.isActive ?? false) {
                              _debounce?.cancel();
                            }

                            _debounce = Timer(
                                const Duration(milliseconds: 1000), () async {
                              log(value);
                              Dio dio = Dio();
                              try {
                                String url =
                                    'https://nominatim.openstreetmap.org/search?q=${value
                                    .toLowerCase().trim()}&format=jsonv2';
                                // '&polygon_geojson=1&addressdetails=1';
                                log(url);
                                var response = await dio.get(url);
                                // var response = await client.post(Uri.parse(url));

                                var decodedResponse = response.data;
                                log(decodedResponse.toString());
                                _options = List<OSMData>.from(decodedResponse
                                    .map(
                                      (e) =>
                                      OSMData(
                                        placeId: e['place_id'],
                                        displayName: e['display_name'],
                                        lat: double.parse(e['lat']),
                                        lon: double.parse(e['lon']),
                                      ),
                                ).toList());
                                String exclude = '&exclude_place_ids=${_options
                                    .isNotEmpty ? _options.first.placeId : ''}';
                                if (_options.length <= 1) {
                                  url = url + exclude;
                                  log(url);
                                  var response = await dio.get(url);
                                  // var response = await client.post(Uri.parse(url));
                                  var decodedResponse =
                                  response.data;
                                  log(decodedResponse.toString());
                                  _options = List<OSMData>.from(decodedResponse
                                      .map(
                                        (e) =>
                                        OSMData(
                                          placeId: e['place_id'],
                                          displayName: e['display_name'],
                                          lat: double.parse(e['lat']),
                                          lon: double.parse(e['lon']),
                                        ),
                                  )
                                      .toList());
                                }

                                setState(() {});
                              }catch(error){
                                log(error.toString());
                                if(error is TypeError){
                                  log(error.stackTrace.toString());
                                }
                              }
                              setState(() {});
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hintText: 'Search here',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                          ),
                        ),
                      ),
                      Container(
                        constraints:  BoxConstraints(maxHeight: 0.3.sh),
                        child: StatefulBuilder(
                          builder: ((context, setState) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount:
                              _options.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_options[index].displayName,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: _options[index].displayName
                                            .isCaseInsensitiveContainsAny(
                                            _searchController.text.trim()) ? Colors
                                            .black : Colors.grey
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_options[index].lat},${_options[index].lon}',
                                  ),
                                  onTap: () {
                                    _searchController.clear();
                                      mapController.move(
                                          LatLng(_options[index].lat,
                                              _options[index].lon),
                                          15.0);

                                    _focusNode.unfocus();
                                    _options.clear();
                                    setState(() {});
                                  },
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
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
