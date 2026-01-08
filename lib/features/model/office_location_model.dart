class OfficeLocation {
  final String locationId;
  final String locationName;
  final String address;
  final double latitude;
  final double longitude;
  final double geofenceRadius; // in meters (default 150-200m)
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OfficeLocation({
    required this.locationId,
    required this.locationName,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.geofenceRadius = 200.0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory OfficeLocation.fromJson(Map<String, dynamic> json) {
    return OfficeLocation(
      locationId: json['id'] ?? '',
      locationName: json['location_name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      geofenceRadius: json['geofence_radius']?.toDouble() ?? 200.0,
      isActive: json['is_active'] ?? true,
      createdAt:
          json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt:
          json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': locationId,
      'location_name': locationName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'geofence_radius': geofenceRadius,
      'is_active': isActive,
      'created_at': createdAt?.toUtc().toIso8601String(),
      'updated_at': updatedAt?.toUtc().toIso8601String(),
    };
  }
}

// Location data for check-in/out
class LocationData {
  final double latitude;
  final double longitude;
  final String? address;
  final double? accuracy;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.accuracy,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'accuracy': accuracy,
    };
  }

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'],
      accuracy: json['accuracy']?.toDouble(),
    );
  }
}
