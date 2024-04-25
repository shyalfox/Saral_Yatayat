// distance_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DistanceService {
  final String _baseUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json';

  Future<String> getDistance(
      String origin, String destination, String? apiKey) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl?destinations=$destination&origins=$origin&key=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['rows'][0]['elements'][0]['distance']['text'];
    } else {
      throw Exception('Failed to load distance data');
    }
  }
}
