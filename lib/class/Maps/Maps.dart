import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:myhealth/Persistencia/P_UserLocalModulo.dart';
import 'package:myhealth/Screens/Loading.dart';
import 'package:myhealth/class/Maps/Requests/google_maps_requests.dart';
import 'package:myhealth/class/UserLocalModulo.dart';

import '../user.dart';

class Maps extends StatefulWidget {
  final String idItem;
  final User user;
  String modulo;
  UserLocalModulo userLocalModulo;

  Maps({this.user, this.idItem, this.modulo, this.userLocalModulo});

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  GoogleMapController mapController;
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Polyline> _polyLines = {};
  List<Marker> allMarkers = [];
  Position positionUser;

//----------------------------------------------------------------------------------------------------

  UserLocalModulo _userLocalModuloEdicao;
  bool _novoUserLocalModulo = false;
  P_UserLocalModulo conectionBD = new P_UserLocalModulo();

//-----------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getUserLocation();

    if (widget.userLocalModulo == null){
      _userLocalModuloEdicao = new UserLocalModulo();
      _novoUserLocalModulo = true;
    } else {
      _userLocalModuloEdicao = widget.userLocalModulo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Mapa"),
        centerTitle: true,
      ),
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: LoadingAnimation(),
              ),
            )
          : Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _initialPosition, zoom: 13.21),
                  onMapCreated: onCreated,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  compassEnabled: true,
                  markers: Set.from(allMarkers),
                  onCameraMove: _onCameraMove,
                  polylines: _polyLines,
                ),
                Positioned(
                  top: 10.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: locationController,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "Onde Estou",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 70.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: TextField(
                      onTap: () async {
                        Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: _googleMapsServices.apiKey,
                            language: "pt",
                            components: [
                              Component(Component.country, "br"),
                            ]);
                        if (p.placeId != null) {
                          var destination =
                              await _getLocationbyPlaceId(p.placeId);

                          _desenharRota(p.description, destination);

                          _salvarUserLocalModulo(
                              destination.latitude.toString(),
                              destination.longitude.toString(),
                              p.description);
                        }
                      },
                      cursorColor: Colors.black,
                      controller: destinationController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20, top: 5),
                          width: 10,
                          height: 10,
                          child: Icon(
                            Icons.local_taxi,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "Destino",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70,
                  right: 10,
                  child: FloatingActionButton(
                    heroTag: "btnSalvar",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: "Salvar",
                    backgroundColor: Colors.white,
                    child: Icon(Icons.save, color: Colors.blue),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    heroTag: "btnLimpar",
                    onPressed: () {
                      _restartMap();
                    },
                    tooltip: "Limpar busca",
                    backgroundColor: Colors.white,
                    child: Icon(Icons.remove_circle, color: Colors.red),
                  ),
                ),
              ],
            ),
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;

      if (widget.userLocalModulo != null) {
        _createRouteWhenStart();
      }
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _addMarker(LatLng location, String nomeLocal) {
    setState(() {
      allMarkers.add(Marker(
          markerId: MarkerId('myMarker'),
          draggable: true,
          infoWindow: InfoWindow(title: nomeLocal, snippet: ""),
          position: location));
    });
    moveCameraToNewPoint(location);
  }

  moveCameraToNewPoint(LatLng location) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: location, zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  void createRoute(String encondedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 6,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: Colors.blue));
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
    // repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    /*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    positionUser = position;
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _lastPosition = _initialPosition;
      locationController.text = placemark[0].name;
    });
  }

  void _getUserLocationAfterClean() async {
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(positionUser.latitude, positionUser.longitude);
    setState(() {
      _initialPosition = LatLng(positionUser.latitude, positionUser.longitude);
      _lastPosition = _initialPosition;
      locationController.text = placemark[0].name;
    });
  }

  Future<LatLng> _getLocationbyPlaceId(
    String placeId,
  ) async {
    var latLng = await _googleMapsServices.getPlaceLatLng(placeId);
    var aux = latLng.split(',');
    LatLng destination = new LatLng(double.parse(aux[0]), double.parse(aux[1]));

    return destination;
  }

  void _desenharRota(String nomeLocal, LatLng destination) async {
    _addMarker(destination, nomeLocal);

    String route = await _getRoute(_initialPosition, destination);
    destinationController.text = nomeLocal;
    createRoute(route);
  }

  void _restartMap() {
    _polyLines.clear();
    allMarkers.clear();
    _getUserLocationAfterClean();
    destinationController.clear();
    moveCameraToNewPoint(_initialPosition);
  }

  Future<String> _getRoute(LatLng _initialPosition, LatLng destination) async {
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);

    return route;
  }

  void _createRouteWhenStart() async {
    LatLng location = new LatLng(double.parse(_userLocalModuloEdicao.latitude),
        double.parse(_userLocalModuloEdicao.longitude));

    _desenharRota(_userLocalModuloEdicao.nomeLocal, location);
  }

  void _salvarUserLocalModulo(
      String latitude, String longitude, String nomeLocal) {
    if (_novoUserLocalModulo) {
      conectionBD.cadastraUserLocalModulo(widget.user.uid, widget.modulo,
          widget.idItem, latitude, longitude, nomeLocal);
    } else {
      conectionBD.atualizarUserLocalModulo(
          widget.userLocalModulo.idUserLocalModulo,
          latitude,
          longitude,
          nomeLocal);
    }
  }
}
