import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  final StreamController<bool> _movimentController =
      StreamController.broadcast();
  Stream<bool> get movementStream => _movimentController.stream;

  static const double _movimentThreshold = 1.5;
  static const int _sampleSize = 5;

  final List<double> _accelarationSamples = [];
  StreamSubscription<AccelerometerEvent>? _subscription;

  void startMovementDetection() {
    if (_subscription != null) return;
    _subscription = accelerometerEventStream().listen((event) {
      final acceleration = sqrt(
        pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2),
      );
      _accelarationSamples.add(acceleration);

      if (_accelarationSamples.length > _sampleSize) {
        _accelarationSamples.removeAt(0);
        final delta =
            _accelarationSamples.reduce(max) - _accelarationSamples.reduce(min);
        _movimentController.add(delta > _movimentThreshold);
      }
    });
  }

  void stopMovementDetection() {
    _subscription?.cancel();
    _subscription = null;
    _accelarationSamples.clear();
  }

  void dispose() {
    stopMovementDetection();
    _movimentController.close();
  }
}
