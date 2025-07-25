import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class GestorEnvioImagens {

  Future<String> gerarURL(String caminhoNoStorage) async {
    final ref = FirebaseStorage.instance.ref().child(caminhoNoStorage);
    return await ref.getDownloadURL();
  }


  Future<String?> enviarImagem({required File imagemLocal, required String caminhoStorage}) async {
    try{
      final ref = FirebaseStorage.instance.ref().child(caminhoStorage);

      await ref.putFile(imagemLocal);

      final url = await ref.getDownloadURL();
    } catch(e){
      print('Erro ao enviar imagem: $e');
      return null;
    }
  }


  Future<String?> obterImagemAPartirDoStorage(String caminhoNoStorage) async {
  try {
    final ref = FirebaseStorage.instance.ref().child(caminhoNoStorage);
    final url = await ref.getDownloadURL();
    return url;
  } catch (e) {
    print('Erro ao carregar imagem: $e');
    return null;
  }
}


}