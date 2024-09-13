import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:postgres/postgres.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _pestMarkers = [];

  @override
  void initState() {
    super.initState();
    _fetchPestData();
  }

  Future<void> _fetchPestData() async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'pestsurveillance',
      username: 'ndegwaofficial',
      password: 'ndegwaofficial',
    );
    await connection.open();

    List<List<dynamic>> results = await connection.query('''
      SELECT r.latitude, r.longitude, p.name
      FROM reports r
      JOIN pests p ON r.pest_id = p.id;
    ''');

    List<Marker> markers = results.map((row) {
      double lat = row[0]; // Latitude
      double lng = row[1]; // Longitude
      String pestName = row[2]; // Pest Name

      return Marker(
        point: LatLng(lat, lng),
        builder: (ctx) => Tooltip(
          message: pestName,
          child: const Icon(Icons.bug_report, color: Colors.red, size: 30),
        ),
      );
    }).toList();

    setState(() {
      _pestMarkers = markers;
    });

    await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Distribution Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(0, 0), // Default center of the map
          zoom: 2.0, // Default zoom level
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _pestMarkers,
          ),
        ],
      ),
    );
  }
}
