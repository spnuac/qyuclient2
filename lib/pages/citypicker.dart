import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../classes/Api.dart' as api;
import '../classes/messages.dart' as messages;
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';


final searchScaffoldKey = GlobalKey<ScaffoldState>();
// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey:api.GoogleApi);

final customTheme = ThemeData(
  primarySwatch: Colors.black,
  brightness: Brightness.dark,
  accentColor: Colors.redAccent,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.00)),
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: 12.50,
      horizontal: 10.00,
    ),
  ),
);


class citypicker extends PlacesAutocompleteWidget {
  citypicker()
      : super(
    apiKey: api.GoogleApi,
    sessionToken: Uuid().generateV4(),
    language: "en",
    components: [],
  );

  @override
  _citypickerState createState() => _citypickerState();
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  messages.waiting(scaffold.context,title: "Proccessing");
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    messages.closeWaiting(scaffold.context);
    Navigator.pop(scaffold.context,{lat:lat,"lng":lng,"city":detail.result.addressComponents[0].longName});
  }
}
class _citypickerState extends PlacesAutocompleteState {
  String searchtxt = '';
  AppBar appBar;
  @override
  Widget build(BuildContext context) {
    appBar = AppBar(
      title: AppBarPlacesAutoCompleteTextField(  textDecoration: InputDecoration(hintStyle: TextStyle(color:Colors.white), hintText: 'Please enter your city'), textStyle: TextStyle(color: Colors.white),),
      backgroundColor: Colors.black,
      actions: [
          FlatButton(
            onPressed: (){
                messages.waiting(context,title: "Get Your Location");
                bool serviceEnabled;
                LocationPermission permission;
                Geolocator.isLocationServiceEnabled().then((serviceEnabled) async {
                  if (!serviceEnabled) {
                    messages.closeWaiting(context);
                    return messages.show(context,title:"error",content: 'Location services are disabled.',type: messages.msgtype.error);
                  }
                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.deniedForever) {
                    messages.closeWaiting(context);
                    return messages.show(context,title:"error",content: 'Location permissions are permantly denied, we cannot request permissions.',type: messages.msgtype.error);
                  }

                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
                      messages.closeWaiting(context);
                      return messages.show(context,title:"error",content: 'Location permissions are denied (actual value: $permission).',type: messages.msgtype.error);
                    }
                  }
                  Geolocator.getCurrentPosition().then((value){
                    final coordinates = new Coordinates(value.latitude, value.longitude);
                    Geocoder.local.findAddressesFromCoordinates(coordinates).then((addresses){
                      messages.closeWaiting(context);
                      Navigator.pop(context,{"lat":value.latitude,"lng":value.longitude,"city":addresses.first.locality});

                    });
                  });
                }).catchError((onError){messages.closeWaiting(context);messages.show(context,title:"Error",content: onError,type: messages.msgtype.error);});
            },
            child:Icon(Icons.location_pin,color:Colors.white,size:20)
          )
      ],
    );
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
      },
      logo: Row(
        children: [
          Center(child: Text( "Please enter your city or tap on map marker \r\nto get current location from your device",textAlign: TextAlign.center))
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}