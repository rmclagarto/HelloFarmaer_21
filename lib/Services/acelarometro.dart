import 'dart:math';
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class Acelarometro {
  final StreamController<bool> _controladorMovimento = StreamController<bool>.broadcast();
  
  // Stream pública que emite `true` se for detetado movimento, ou `false` caso contrário.
  Stream<bool> get fluxoMovimento => _controladorMovimento.stream;

  static const double _limiteMovimento = 1.5;
  static const int _tamanhoAmostra = 5;
  static const Duration _intervaloAmostragem = Duration(milliseconds: 100);

  final List<double> _amostrasAceleracao = [];
  StreamSubscription<AccelerometerEvent>? _subscricao;
  Timer? _temporizadorAmostragem;
  bool _foiEliminado = false;


  // Inicia a deteção de movimento a partir dos eventos do acelerómetro.
  void iniciarDetecaoMovimento() {
    if (_foiEliminado || _subscricao != null) return;

    // Escuta os eventos do acelerómetro
    _subscricao = accelerometerEvents.listen(
      (evento) {
        if (_foiEliminado) return;
        
        // Calcula a aceleração total (magnitude do vetor)
        final acceleration = sqrt(
          pow(evento.x, 2) + pow(evento.y, 2) + pow(evento.z, 2),
        );

        // Adiciona a amostra à lista
        _amostrasAceleracao.add(acceleration);

        // Mantém apenas as últimas N amostras
        if (_amostrasAceleracao.length > _tamanhoAmostra) {
          _amostrasAceleracao.removeAt(0);
        }
      },
      onError: (erro) {
        if (!_foiEliminado && !_controladorMovimento.isClosed) {
          _controladorMovimento.addError(erro);
        }
      },
      cancelOnError: false,
    );

    // Avalia as amostras periodicamente para detetar movimento
    _temporizadorAmostragem = Timer.periodic(_intervaloAmostragem, (_) {
      if (_foiEliminado || _amostrasAceleracao.length < _tamanhoAmostra) return;
      
      // Calcula a diferença entre a maior e menor aceleração
      final delta = _amostrasAceleracao.reduce(max) - _amostrasAceleracao.reduce(min);

      // Emite true se o delta ultrapassar o limite definido
      if (!_controladorMovimento.isClosed) {
        _controladorMovimento.add(delta > _limiteMovimento);
      }
    });
  }

  // Para a deteção de movimento e limpa os dados armazenados.
  void pararDetecaoMovimento() {
    _subscricao?.cancel();
    _subscricao = null;
    _temporizadorAmostragem?.cancel();
    _temporizadorAmostragem = null;
    _amostrasAceleracao.clear();
  }

  // Liberta recursos e encerra o stream.
  void dispose() {
    _foiEliminado = true;
    pararDetecaoMovimento();
    if (!_controladorMovimento.isClosed) {
      _controladorMovimento.close();
    }
  }
}