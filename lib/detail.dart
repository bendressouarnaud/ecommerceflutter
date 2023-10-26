

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/sousproduit.dart';

import 'constants.dart';
import 'httpbeans/beansousproduit.dart';
import 'httpbeans/beansousproduitarticle.dart';
import 'httpbeans/detailbean.dart';
import 'newpage.dart';

class DetailEcran extends StatelessWidget{

  // Attribute
  int idSprod = 0;
  String libSProd = "";

  DetailEcran({super.key});//, required this.idprod, required this.libProd});
  DetailEcran.setId(this.idSprod, this.libSProd);


  // METHODS :
  String formatPrice(int price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price.toDouble()
    );
    //
    return fmf.output.withoutFractionDigits;
  }

  // Get SUB-Product :
  Future<List<Detail>> getmobilealldetailsbyidspr() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobilealldetailsbyidspr');
    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": idSprod
        }));
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<Detail> posts = body
          .map(
            (dynamic item) => Detail.fromJson(item),
      )
          .toList();
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  // Get SUB-Product :
  Future<List<Beansousproduitarticle>> getmobilealldetailsarticles() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobilealldetailsarticles');
    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": idSprod
        }));
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<Beansousproduitarticle> posts = body
          .map(
            (dynamic item) => Beansousproduitarticle.fromJson(item),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(libSProd, textAlign: TextAlign.start, ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black,)
          ),
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.search, color: Colors.black)
          )
        ],
      ),
      body: FutureBuilder(
          future:Future.wait([getmobilealldetailsbyidspr(), getmobilealldetailsarticles()]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {

              List<Detail> listeDetail = snapshot.data[0];
              List<Beansousproduitarticle> listeArticle = snapshot.data[1];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 140,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: listeDetail.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    // Display
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)
                                        {
                                          return Sousproduitecran.setId(3, listeDetail[index].iddet, listeDetail[index].libelle);
                                        }
                                      )
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    width: 120,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
                                        image: NetworkImage(
                                          'https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${listeDetail[index].lienweb}?alt=media',
                                        ),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(listeDetail[index].libelle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                            //backgroundColor: Colors.grey
                                          )),
                                    ),
                                  )
                              );
                            }
                        )
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 500,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: listeArticle.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Container(
                                    color: greenGridViewtitle,// Colors.green[200],
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(listeArticle[index].detail),
                                        ),
                                        const Expanded(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Text("Voir tout"),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Set GRIDVIEW :
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 340,
                                      child: GridView.extent(
                                        maxCrossAxisExtent: 150.0, // maximum item width
                                        mainAxisSpacing: 8.0, // spacing between rows
                                        crossAxisSpacing: 8.0, // spacing between columns
                                        childAspectRatio: MediaQuery.of(context).size.width /  (MediaQuery.of(context).size.height / 1.6),
                                        padding: const EdgeInsets.all(8.0),
                                        children: listeArticle[index].liste.sublist(0,
                                            (listeArticle[index].liste.length > 6 ? 6 : listeArticle[index].liste.length) ).map((item) {
                                          return GestureDetector(
                                            onTap: (){
                                              Fluttertoast.showToast(
                                                  msg: "${dotenv.env['FOO']}",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.all(3),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.all(5),
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 110,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${item.lienweb}?alt=media"
                                                                ),
                                                                fit: BoxFit.fill
                                                            )
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(item.libelle.length > 16 ?
                                                        "${item.libelle.substring(0,11)} ..." : item.libelle,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black
                                                            )
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text("${formatPrice(item.prix)} FCFA",
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                color: Colors.grey
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            ),
                                          );
                                        }).toList(),
                                      )
                                  )
                                ],
                              );
                            }
                        )
                    )

                  ],
                ),
              );
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
      ),
    );
    throw UnimplementedError();
  }

}