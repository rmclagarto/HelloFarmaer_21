import 'dart:math';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  final StreamController<bool> _movementController = StreamController<bool>.broadcast();
  Stream<bool> get movementStream => _movementController.stream;

  static const double _movementThreshold = 1.5;
  static const int _sampleSize = 5;
  static const Duration _samplingInterval = Duration(milliseconds: 100);

  final List<double> _accelerationSamples = [];
  StreamSubscription<AccelerometerEvent>? _subscription;
  Timer? _samplingTimer;
  bool _isDisposed = false;

  void startMovementDetection() {
    if (_isDisposed || _subscription != null) return;

    _subscription = accelerometerEvents.listen(
      (event) {
        if (_isDisposed) return;
        
        final acceleration = sqrt(
          pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2),
        );
        _accelerationSamples.add(acceleration);

        if (_accelerationSamples.length > _sampleSize) {
          _accelerationSamples.removeAt(0);
        }
      },
      onError: (error) {
        if (!_isDisposed && !_movementController.isClosed) {
          _movementController.addError(error);
        }
      },
      cancelOnError: false,
    );

    _samplingTimer = Timer.periodic(_samplingInterval, (_) {
      if (_isDisposed || _accelerationSamples.length < _sampleSize) return;
      
      final delta = _accelerationSamples.reduce(max) - _accelerationSamples.reduce(min);
      if (!_movementController.isClosed) {
        _movementController.add(delta > _movementThreshold);
      }
    });
  }

  void stopMovementDetection() {
    _subscription?.cancel();
    _subscription = null;
    _samplingTimer?.cancel();
    _samplingTimer = null;
    _accelerationSamples.clear();
  }

  void dispose() {
    _isDisposed = true;
    stopMovementDetection();
    if (!_movementController.isClosed) {
      _movementController.close();
    }
  }
}