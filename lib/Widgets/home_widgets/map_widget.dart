import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:projeto_cm/Services/accelarometer_service.dart';
import 'package:projeto_cm/Services/location_service.dart';


class MapWidget extends StatefulWidget {
  final double initialZoom;
  const MapWidget({super.key, this.initialZoom = 16.0});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final _locationService = LocationService();
  final _accelerometerService  = AccelerometerService();
  final _mapCtrl = MapController();
  LatLng? _pos;
  bool _mapReady = false;

  StreamSubscription? _movementSub;
  StreamSubscription? _positionSub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _locationService.ensurePermissions();

      _pos = await _locationService.getCurrentPosition();
      if (mounted) setState(() {});

      _accelerometerService.startMovementDetection();
      _movementSub = _accelerometerService.movementStream.listen((isMoving){
        if(isMoving){
          _updatePosition(); // Ativa o GPS quando movimento é detectado
        }
      });
    } catch (e) {
      setState(() => _pos = const LatLng(0, 0)); // fallback visível
      debugPrint('Erro: ${e.toString()}');
    }
  }


  void _updatePosition() {
    _positionSub?.cancel();
    _positionSub = _locationService.getPositionStream(highAccuracy: true)
        .take(1) // Pega apenas uma atualização
        .listen((newPos) {
      if (mounted) {
        setState(() => _pos = newPos);
        if (_mapReady) _mapCtrl.move(newPos, widget.initialZoom);
      }
    });
  }

  @override
  void dispose() {
    _movementSub?.cancel();
    _positionSub?.cancel();
    _accelerometerService.dispose();
    _mapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    if (_pos == null) return const Center(child: CircularProgressIndicator());

    return FlutterMap(
      mapController: _mapCtrl,
      options: MapOptions(
        initialCenter: _pos!,
        initialZoom: widget.initialZoom,
        onMapReady: () => _mapReady = true,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _pos!,
              width: 20,
              height: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
