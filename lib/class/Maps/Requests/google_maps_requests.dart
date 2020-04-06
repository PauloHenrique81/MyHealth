import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapsServices {
  final apiKey = "AIzaSyCkqiI9439-ZJbmpGgyY9oPuXakV13JRy4";

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

  Future<String> getPlaceLatLng(String placeId) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,formatted_phone_number,geometry/location&key=$apiKey";
    http.Response response = await http.get(url);
    Map values = jsonDecode(response.body);
    String lat = values["result"]["geometry"]["location"]["lat"].toString();
    String lng = values["result"]["geometry"]["location"]["lng"].toString();
    return lat + ',' + lng;
  }
}
