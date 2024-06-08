import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackScreen extends StatefulWidget {
  const OrderTrackScreen({Key? key}) : super(key: key);

  @override
  State<OrderTrackScreen> createState() => _OrderTrackScreenState();
}

class _OrderTrackScreenState extends State<OrderTrackScreen> {
  final LatLng _center = LatLng(37.422131, 2.084801);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Track"),),
        body: GoogleMap(
          onMapCreated: (controller) {

          },
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: {
            const Marker(
              markerId: MarkerId("Sydney"),
              position: LatLng(-33.86, 151.20),
              infoWindow: InfoWindow(
                title: "Sydney",
                snippet: "Capital of New South Wales",
              ),
              icon: BitmapDescriptor.defaultMarker
            ),
            const Marker(
              markerId: MarkerId("marker2"),
              position: LatLng(37.415768808487435, -122.08440050482749),
            ),
          },
        ),
    );
  }
}
