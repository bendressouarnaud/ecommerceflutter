

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:newecommerce/models/achat.dart';
import 'package:newecommerce/repositories/achat_repository.dart';

import 'constants.dart';
import 'getxcontroller/getachatcontroller.dart';
import 'httpbeans/beanarticlestatusresponse.dart';
import 'newpage.dart';


class Paniercran extends StatefulWidget {

  // Attribute



  // METHODS :
  const Paniercran({Key? key}) : super(key: key);

  @override
  State<Paniercran> createState() => _NewPanier();
}


class _NewPanier extends State<Paniercran> {

  // A T T R I B U T E S /
  //final _achatRepository = AchatRepository();
  final AchatGetController _achatController = Get.put(AchatGetController());


  // M e t h o d  :
  @override
  void initState() {
    super.initState();
  }

  // Get Products :
  Future<List<BeanArticlestatusresponse>> getArticlesStatus() async {

    //List<Achat> liste =  _achatRepository.findAllAchatByActif("1") as List<Achat>;
    Set<int> setIdart = _achatController.taskData.map((element) => element.idart).toSet();
    List<int> finalListe = [];
    setIdart.forEach((element) => finalListe.add(element));

    Fluttertoast.showToast(
        msg: "Taille: ${finalListe.length}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getarticledetails');

    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "articleid": finalListe
        }));

    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<BeanArticlestatusresponse> posts = body
          .map(
            (dynamic item) => BeanArticlestatusresponse.fromJson(item),
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Panier", textAlign: TextAlign.start, ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
          ),
        ),
        body: FutureBuilder(
            future: Future.wait([getArticlesStatus()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                List<BeanArticlestatusresponse> liste =  snapshot.data[0];
                return Container();
              }
              else{
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) => const NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: defaultPadding),
                );
              }
            }
        )
    );
  }
}