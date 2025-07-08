// import '../../../Core/image_assets.dart';

// class AdModel {
//   final String title;
//   final String price;
//   final String image;
//   final String date;
//   final Map<String, dynamic> stats;

//   AdModel({
//     required this.title,
//     required this.price,
//     required this.image,
//     required this.date,
//     required this.stats,
//   });

//   static List<AdModel> sampleAds() => [
//     AdModel(
//       title: "Produto Agrícola Premium",
//       price: "25,10€",
//       image: ImageAssets.produto,
//       date: "Publicado em 10/06/2025",
//       stats: {
//         'views': 124,
//         'clicks': 42,
//         'conversions': 8,
//         'history': [12, 18, 26, 34, 42],
//       },
//     ),
//     AdModel(
//       title: "Colheita de Maçãs",
//       price: "12,50€/kg",
//       image: ImageAssets.fruta,
//       date: "Publicado em 09/06/2025",
//       stats: {
//         'views': 89,
//         'clicks': 31,
//         'conversions': 5,
//         'history': [8, 12, 15, 22, 31],
//       },
//     ),
//   ];
// }


import '../../../Core/image_assets.dart';

class Produtos {
  String title;
  String image;
  bool isAsset;
  String price; // <-- agora é mutável
  String date;
  String description;
  String? categoria;
  Map<String, dynamic> stats;

  Produtos({
    required this.title,
    required this.image,
    required this.isAsset,
    required this.price,
    required this.date,
    required this.description,
    required this.stats,
    this.categoria,
  });


  Produtos.simple({
    required this.title,
    required this.price,
    required this.image,
    this.categoria,
  }) : isAsset = true,
    date = '',
    description = '',
    stats = {};

  static List<Produtos> sampleAds() => [
        Produtos(
          title: "Produto Agrícola Premium",
          price: "25,10€",
          image: ImageAssets.produto,
          isAsset: true,
          date: "Publicado em 10/06/2025",
          stats: {
            'views': 124,
            'clicks': 42,
            'conversions': 8,
            'history': [12, 18, 26, 34, 42],
          },
          description: "Produto de alta qualidade, cultivado com técnicas sustentáveis.",
        ),
        Produtos(
          title: "Colheita de Maçãs",
          price: "12,50€/kg",
          image: ImageAssets.fruta,
          isAsset: true,
          date: "Publicado em 09/06/2025",
          stats: {
            'views': 89,
            'clicks': 31,
            'conversions': 5,
            'history': [8, 12, 15, 22, 31],
          },
          description: "Maçãs frescas e suculentas, colhidas diretamente do pomar.",
        ),
      ];
}
