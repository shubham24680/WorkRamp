import 'dart:math' as math;

import '../../app.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permissions
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permissions
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception(
            'Location services are disabled. Please enable location services.');
      }

      // Check permission
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied. Please enable from settings.');
      }

      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }

  // Get address from coordinates (Reverse Geocoding)
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }

  // Calculate distance between two coordinates (Haversine formula)
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth radius in meters

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = earthRadius * c;

    return distance; // Returns distance in meters
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  // Check if user is within office geofence
  Future<GeofenceValidationResult> validateGeofence({
    required Position currentPosition,
    required OfficeLocation officeLocation,
  }) async {
    double distance = calculateDistance(
      currentPosition.latitude,
      currentPosition.longitude,
      officeLocation.latitude,
      officeLocation.longitude,
    );

    bool isWithinGeofence = distance <= officeLocation.geofenceRadius;

    return GeofenceValidationResult(
      isWithinGeofence: isWithinGeofence,
      distance: distance,
      officeLocation: officeLocation,
      userLatitude: currentPosition.latitude,
      userLongitude: currentPosition.longitude,
      accuracy: currentPosition.accuracy,
    );
  }

  // Create LocationData object from Position
  Future<LocationData> createLocationData(Position position) async {
    String? address = await getAddressFromCoordinates(
      position.latitude,
      position.longitude,
    );

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      accuracy: position.accuracy,
    );
  }

  // Check if user can check-in based on location
  Future<CheckInValidationResult> validateCheckIn({
    required Position currentPosition,
    required OfficeLocation officeLocation,
    required bool canCheckInAnywhere,
  }) async {
    // If user has permission to check-in from anywhere
    if (canCheckInAnywhere) {
      LocationData locationData = await createLocationData(currentPosition);
      return CheckInValidationResult(
        isValid: true,
        message: 'Check-in allowed from any location',
        locationData: locationData,
      );
    }

    // Validate geofence for regular employees
    GeofenceValidationResult geofenceResult = await validateGeofence(
      currentPosition: currentPosition,
      officeLocation: officeLocation,
    );

    if (geofenceResult.isWithinGeofence) {
      LocationData locationData = await createLocationData(currentPosition);
      return CheckInValidationResult(
        isValid: true,
        message: 'You are at ${officeLocation.locationName}',
        locationData: locationData,
        distanceFromOffice: geofenceResult.distance,
      );
    } else {
      LocationData locationData = await createLocationData(currentPosition);
      return CheckInValidationResult(
        isValid: false,
        message:
            'You are ${geofenceResult.distance.toStringAsFixed(0)}m away from ${officeLocation.locationName}. You must be within ${officeLocation.geofenceRadius.toStringAsFixed(0)}m to check-in.',
        locationData: locationData,
        distanceFromOffice: geofenceResult.distance,
      );
    }
  }
}

// Result classes
class GeofenceValidationResult {
  final bool isWithinGeofence;
  final double distance;
  final OfficeLocation officeLocation;
  final double userLatitude;
  final double userLongitude;
  final double accuracy;

  GeofenceValidationResult({
    required this.isWithinGeofence,
    required this.distance,
    required this.officeLocation,
    required this.userLatitude,
    required this.userLongitude,
    required this.accuracy,
  });
}

class CheckInValidationResult {
  final bool isValid;
  final String message;
  final LocationData locationData;
  final double? distanceFromOffice;

  CheckInValidationResult({
    required this.isValid,
    required this.message,
    required this.locationData,
    this.distanceFromOffice,
  });
}
