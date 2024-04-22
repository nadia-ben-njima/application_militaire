// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position _currentPosition;
  String _address = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _address = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _address = 'Location permissions are permanently denied.';
      });
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          _address = 'Location permissions are denied.';
        });
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _getAddressFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude);
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark firstPlacemark = placemarks.first;
        String address =
            "${firstPlacemark.street}, ${firstPlacemark.locality}, ${firstPlacemark.postalCode}, ${firstPlacemark.country}";
        setState(() {
          _address = address;
        });
      } else {
        setState(() {
          _address = 'Address not found.';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Error getting address: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Current Location"),
      ),
      body: Stack(
        children: [
          // Image d'arrière-plan
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.jpeg', 
              fit: BoxFit.cover,
            ),
          ),
          // Icône de localisation centrée en haut
          Positioned(
            top: 50, // Ajustez la position verticale
            left: MediaQuery.of(context).size.width / 2 - 24, // Centrage horizontal
            child: const Icon(
              Icons.location_on,
              size: 90,
              color: Colors.red, // Couleur de l'icône de localisation
            ),
          ),
          // Contenu au centre
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Latitude: ${_currentPosition.latitude}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Longitude: ${_currentPosition.longitude}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Address:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  _address,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
