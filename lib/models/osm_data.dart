class OSMData {
  final int placeId;
  final String displayName;
  final double lat;
  final double lon;
  OSMData({required this.displayName, required this.lat, required this.lon,required this.placeId});
  @override
  String toString() {
    return '$displayName, $lat, $lon';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OSMData && other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(displayName, lat, lon);
}