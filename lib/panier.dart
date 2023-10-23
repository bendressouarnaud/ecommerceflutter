

import 'package:flutter/material.dart';


class Detailecran extends StatefulWidget {

  // Attribute



  // METHODS :
  Detailecran({Key? key}) : super(key: key);

  @override
  State<Detailecran> createState() => _NewDetail();
}


class _NewDetail extends State<Detailecran> {


  // M e t h o d  :
  @override
  void initState() {
    super.initState();
  }

  // Get Products :
  Future<List<Produit>> produitLoading() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobileAllProduits');
    mreponse.Response response = await get(url);
    if(response.statusCode == 200){
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<Produit> posts = body
          .map(
            (dynamic item) => Produit.fromJson(item),
      )
          .toList();
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}