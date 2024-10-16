import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DeliveryLocationMap extends StatefulWidget {
  @override
  _DeliveryLocationMapState createState() => _DeliveryLocationMapState();
}

class _DeliveryLocationMapState extends State<DeliveryLocationMap> {
  MapController _mapController = MapController();
  loc.Location _location = loc.Location();
  LatLng _currentLocation =
      LatLng(30.033333, 31.233334); // Default location (Cairo)
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _locationSuggestions = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          if (!mounted) return; // Check if the widget is still mounted
          _showErrorDialog('Location service is disabled. Please enable it.');
          return;
        }
      }

      loc.PermissionStatus _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          if (!mounted) return; // Check if the widget is still mounted
          _showErrorDialog(
              'Location permission denied. Please grant permission.');
          return;
        }
      }

      loc.LocationData _locationData = await _location.getLocation();
      if (!mounted)
        return; // Check if the widget is still mounted before updating the state
      setState(() {
        _currentLocation =
            LatLng(_locationData.latitude!, _locationData.longitude!);
        _mapController.move(_currentLocation, 15.0);
      });
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      _showErrorDialog('Failed to get location: ${e.toString()}');
    }
  }

  Future<void> _searchLocation(String query) async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          LatLng newLocation = LatLng(lat, lon);

          setState(() {
            _currentLocation = newLocation;
            _mapController.move(newLocation, 15.0);
            _isLoading = false;
          });
        } else {
          _showErrorDialog('Location Not Found . Please try another search. ');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        _showErrorDialog('Location Not Found . Please try another search. ');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to search location : ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchLocationSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _locationSuggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _locationSuggestions = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _locationSuggestions = [];
          _isLoading = false;
        });
        _showErrorDialog('Failed to fetch suggestions. Please try again.');
      }
    } catch (e) {
      setState(() {
        _locationSuggestions = [];
        _isLoading = false;
      });
      _showErrorDialog('Error fetching location suggestions: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Delivery Location'),
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for Location......',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _isLoading ? CircularProgressIndicator() : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _searchLocation(value);
                }
              },
              onChanged: (value) {
                _fetchLocationSuggestions(value);
              },
            ),
          ),
          _locationSuggestions.isEmpty
              ? const Center(
                  child: Text(''),
                )
              : SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _locationSuggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = _locationSuggestions[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 30,vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0,2)
                            )
                          ]
                        ),
                        child: ListTile(
                          title: Text(
                            suggestion['display_name'] ?? 'Unknown Location',
                            style: TextStyle(color: Colors.black45),
                          ),
                          onTap: () {
                            final lat = double.parse(suggestion['lat']);
                            final lon = double.parse(suggestion['lon']);
                            LatLng newLocation = LatLng(lat, lon);
                            setState(() {
                              _currentLocation = newLocation;
                              _mapController.move(newLocation, 15.0);
                            });
                            _locationSuggestions.clear();
                          },
                        ),
                      );
                    },
                  ),
                ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 15.0,
                onPositionChanged: (position, bool hasGesture) {
                  setState(() {
                    _currentLocation = position.center ?? _currentLocation;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentLocation,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          _confirmLocation();
        },
      ),
    );
  }

  void _confirmLocation() async {
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
      _currentLocation.latitude,
      _currentLocation.longitude,
    );
    String address =
        "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}";

    // Store the confirmed delivery location in Firebase Firestore
    await FirebaseFirestore.instance.collection('delivery_locations').add({
      'latitude': _currentLocation.latitude,
      'longitude': _currentLocation.longitude,
      'address': address,
      'timestamp': Timestamp.now(),
    });

    Navigator.pop(context, {
      'address': address,
      'location': LatLng(_currentLocation.latitude, _currentLocation.longitude),
    }); // Return the confirmed address
  }
}
