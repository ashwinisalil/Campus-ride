import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationService {
  // Check & request location permission
  static Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current device position
  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestPermission();
      if (!hasPermission) return null;
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  // Open native Google Maps app with lat and long for navigation/live view
  static Future<bool> openGoogleMaps(double lat, double lng, {String? destinationLabel}) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final Uri uri = Uri.parse(googleMapsUrl);

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Calculate distance between two coordinates in kilometers
  static double calculateDistanceKm(double startLat, double startLng, double endLat, double endLng) {
    double distanceInMeters = Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    return distanceInMeters / 1000.0;
  }
}
