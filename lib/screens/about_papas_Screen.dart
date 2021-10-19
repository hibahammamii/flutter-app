
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget
{
  static const routeName = '/aboutScreen';
  @override
  Widget build(BuildContext context) {
    final Map<String, Marker> _markers = {};

          final marker = Marker(
            markerId: MarkerId("Papa's"),
            position: LatLng(30.36474559416418, 30.530557293435983),
          );
          _markers[""] = marker;


     GoogleMapController mapController;

    final LatLng _center = const LatLng(30.36474559416418, 30.530557293435983);

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("About papa's"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height *0.5,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
          SizedBox(height: 5,),
          Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration( ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Phone Number:  " ,style:
                TextStyle(fontWeight: FontWeight.bold,color: kThirdColor),),

                Text("01061596589" , style: TextStyle(fontStyle: FontStyle.italic),),
                Spacer(),

                InkWell(
                  onTap:() {_launch("tel:" +"0106159539");},
                  child: Container(
                   padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.phone,color: kThirdColor,)),
                ),



              ],
            ),
          )
        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
  _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Not supported");
    }
  }

}
