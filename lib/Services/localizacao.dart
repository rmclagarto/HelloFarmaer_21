import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';


class Localizacao {


  Stream<LatLng> obterStreamDePosicao({bool altaPrecisao = false}) {
    final definicoes = LocationSettings(
      accuracy: altaPrecisao ? LocationAccuracy.high : LocationAccuracy.low,
      distanceFilter: altaPrecisao ? 10 : 100, // metros
    );

    return Geolocator.getPositionStream(locationSettings: definicoes)
       .map((posicao) => LatLng(posicao.latitude, posicao.longitude));
  }
  

  // Obtém amposição atual com alta precisão.
  Future<LatLng> obterPosicaoAtual() async {
    final posicao = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      )
    );
    return LatLng(posicao.latitude, posicao.longitude);
  }


  // Garante que o utilizador deu permissão para aceder à localização.
  Future<void> garantirPermissoes() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Serviço de localização desativado.');
    }
    
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();

      if (permissao == LocationPermission.denied) {
        throw Exception('Permissão negada.');
      }

    }
    
    if (permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão negada permanentemente.');
    }
  }
}