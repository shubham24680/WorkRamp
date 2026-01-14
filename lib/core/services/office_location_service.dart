import 'dart:developer';
import '../../app.dart';

class OfficeLocationService {
  OfficeLocationService._();

  factory OfficeLocationService() => _instance;
  static final OfficeLocationService _instance = OfficeLocationService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<OfficeLocation> getOfficeLocation(String locationId) async {
    try {
      final response = await _supabase
          .from(ApiConstants.OFFICE_SERVICE)
          .select()
          .eq("id", locationId)
          .single();

      log("Office Location Response - $response");
      return OfficeLocation.fromJson(response);
    } catch (e) {
      log('Error getting office location: $e');
      rethrow;
    }
  }

// Create new office location (Admin/HR only)
// Future<void> createOfficeLocation(OfficeLocation location) async {
//   try {
//     await _supabase.from('office_locations').insert(location.toJson());
//   } catch (e) {
//     print('Error creating office location: $e');
//     rethrow;
//   }
// }

// Get all office locations
// Future<List<OfficeLocation>> getAllOfficeLocations() async {
//   try {
//     final response = await _supabase
//         .from('office_locations')
//         .select()
//         .eq('is_active', true);
//
//     return (response as List)
//         .map((item) => OfficeLocation.fromJson(item))
//         .toList();
//   } catch (e) {
//     print('Error getting office locations: $e');
//     return [];
//   }
// }

// Update office location
// Future<void> updateOfficeLocation(OfficeLocation location) async {
//   try {
//     await _supabase
//         .from('office_locations')
//         .update(location.toJson())
//         .eq('id', location.locationId);
//   } catch (e) {
//     print('Error updating office location: $e');
//     rethrow;
//   }
// }

// Delete office location (soft delete)
// Future<void> deleteOfficeLocation(String locationId) async {
//   try {
//     await _supabase.from('office_locations').update({
//       'is_active': false,
//       'updated_at': DateTime.now().toIso8601String(),
//     }).eq('id', locationId);
//   } catch (e) {
//     print('Error deleting office location: $e');
//     rethrow;
//   }
// }

// Stream of office locations
// Stream<List<OfficeLocation>> officeLocationsStream() {
//   return _supabase
//       .from('office_locations')
//       .stream(primaryKey: ['id'])
//       .eq('is_active', true)
//       .map((data) =>
//           data.map((item) => OfficeLocation.fromJson(item)).toList());
// }
}
