import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:projeto_cm/Core/image_assets.dart';
import 'package:projeto_cm/Services/location_service.dart';
import 'package:projeto_cm/Services/accelarometer_service.dart';


class MapWidget extends StatefulWidget {
  final double initialZoom;
  const MapWidget({super.key, this.initialZoom = 16.0});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final _locationService = LocationService();
  final _accelerometerService = AccelerometerService();
  final _mapCtrl = MapController();
  LatLng? _pos;
  bool _mapReady = false;

  StreamSubscription? _movementSub;
  StreamSubscription? _positionSub;

  final List<Marker> _markerPositions = [];

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
      _movementSub = _accelerometerService.movementStream.listen((isMoving) {
        if (isMoving) {
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
    _positionSub = _locationService
        .getPositionStream(highAccuracy: true)
        .take(1) // Pega apenas uma atualização
        .listen((newPos) {
          if (mounted) {
            setState(() => _pos = newPos);
            if (_mapReady) _mapCtrl.move(newPos, widget.initialZoom);
          }
        });
  }

  void addMarker(LatLng point) {
    setState(() {
      _markerPositions.add(
        Marker(
          point: point,
          width: 30,
          height: 30,
          child: const Icon(Icons.location_on, size: 30, color: Colors.red),
        ),
      );
      _mapCtrl.move(point, widget.initialZoom);
    });
  }

 void addRandomMarker() {
  final random = Random();
  if (_pos == null) return;

  final randomLat = _pos!.latitude + (random.nextDouble() - 0.5) * 0.01;
  final randomLng = _pos!.longitude + (random.nextDouble() - 0.5) * 0.01;
  final randomPoint = LatLng(randomLat, randomLng);

  final marker = Marker(
    point: randomPoint,
    width: 80,
    height: 60,
    child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Loja XYZ'),
            content: Text('Aqui vão os detalhes da loja...'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
          border: Border.all(color: Colors.orange, width: 2),
        ),
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Image.asset(
              ImageAssets.quinta,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Loja XYZ', // LOja nome
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  setState(() {
    _markerPositions.add(marker);
    _mapCtrl.move(randomPoint, widget.initialZoom);
  });

  // Remover o marcador depois de 5 segundos
  Future.delayed(Duration(seconds: 5), () {
    setState(() {
      _markerPositions.remove(marker);
    });
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
            ..._markerPositions,
          ],
        ),
      ],
    );
  }
}
