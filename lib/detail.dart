

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/sousproduit.dart';

import 'article.dart';
import 'constants.dart';
import 'httpbeans/beansousproduit.dart';
import 'httpbeans/beansousproduitarticle.dart';
import 'httpbeans/detailbean.dart';
import 'newpage.dart';
import 'package:http/http.dart' as https;

class DetailEcran extends StatelessWidget{

  // Attribute
  int idSprod = 0;
  String libSProd = "";
  https.Client? client;

  DetailEcran({super.key});//, required this.idprod, required this.libProd});
  DetailEcran.setId(this.idSprod, this.libSProd, this.client);


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
    var response = await client!.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": idSprod
        }));
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
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
    var response = await client!.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": idSprod
        }));
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
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

              return Column(
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
                                        return Sousproduitecran.setParams(3, listeDetail[index].iddet, listeDetail[index].libelle, client);
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
                  Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            //height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: listeArticle.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Container(
                                        color: greenGridViewtitle,// Colors.green[200],
                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                        margin: const EdgeInsets.only(left: 10, right: 10),
                                        width: MediaQuery.of(context).size.width,
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(listeArticle[index].detail,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold
                                                  )),
                                            ),
                                            const Expanded(
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Text("Voir tout",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                      )),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Set GRIDVIEW :
                                      SizedBox(
                                        //listeArticle[index].liste.length < 4 ? 170 : 340
                                        // NeverScrollableScrollPhysics  ScrollPhysics
                                          width: MediaQuery.of(context).size.width,
                                          height: listeArticle[index].liste.length < 4 ? 200 : 340,
                                          child: GridView.extent(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            maxCrossAxisExtent: 150.0, // maximum item width
                                            mainAxisSpacing: 8.0, // spacing between rows
                                            crossAxisSpacing: 8.0, // spacing between columns
                                            childAspectRatio: MediaQuery.of(context).size.width /  (MediaQuery.of(context).size.height / 1.6),
                                            padding: const EdgeInsets.all(8.0),
                                            children: listeArticle[index].liste.sublist(0,
                                                (listeArticle[index].liste.length > 6 ? 6 : listeArticle[index].liste.length) ).map((item) {
                                              return GestureDetector(
                                                onTap: (){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) {
                                                        return ArticleEcran.setId(item.idart, 0, 0);
                                                      }
                                                      )
                                                  );
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
                                                            child: CachedNetworkImage(
                                                              imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${item.lienweb}?alt=media",
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              placeholder: (context, url) => const CircularProgressIndicator(
                                                                color: Colors.amber,
                                                              ),
                                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                                            )

                                                            /*decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${item.lienweb}?alt=media"
                                                                    ),
                                                                    fit: BoxFit.fill
                                                                )
                                                            ),*/
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
                        ),
                      )
                  )
                ],
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