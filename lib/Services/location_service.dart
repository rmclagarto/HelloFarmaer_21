import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  Stream<LatLng> getPositionStream({bool highAccuracy = false}) {
    final settings = LocationSettings(
      accuracy: highAccuracy ? LocationAccuracy.high : LocationAccuracy.low,
      distanceFilter: highAccuracy ? 10 : 100,
    );
    return Geolocator.getPositionStream(locationSettings: settings)
       .map((pos) => LatLng(pos.latitude, pos.longitude));
  }

  Future<LatLng> getCurrentPosition() async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      )
    );
    return LatLng(pos.latitude, pos.longitude);
  }

  Future<void> ensurePermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Serviço de localização desativado.');
    }
    
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw Exception('Permissão negada.');
      }
    }
    
    if (perm == LocationPermission.deniedForever) {
      throw Exception('Permissão negada permanentemente.');
    }
  }
}