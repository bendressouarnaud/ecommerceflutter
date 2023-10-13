

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'constants.dart';
import 'httpbeans/beansousproduit.dart';
import 'newpage.dart';

class ProduitEcran extends StatelessWidget{

  // Attribute
  int idprod = 0;
  String libProd = "";

  ProduitEcran({super.key});//, required this.idprod, required this.libProd});
  ProduitEcran.setId(this.idprod, this.libProd);


  // METHODS :
  // Get SUB-Product :
  Future<List<Beansousproduit>> sousproduitLoading() async {
    final url = Uri.parse('http://10.1.4.102:8080/backendcommerce/getmobileallsousproduitsbyidprd');
    var response = await post(url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "idprd": idprod
      }));
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<Beansousproduit> posts = body
          .map(
            (dynamic item) => Beansousproduit.fromJson(item),
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
  Future<List<Beansousproduit>> getSousProduitArticle() async {
    final url = Uri.parse('http://10.1.4.102:8080/backendcommerce/getmobileallsousproduitsarticles');
    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": idprod
        }));
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<Beansousproduit> posts = body
          .map(
            (dynamic item) => Beansousproduit.fromJson(item),
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
        title: Text(libProd, textAlign: TextAlign.start, ),
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
        future:Future.wait([sousproduitLoading()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            List<Beansousproduit> listeSousProduit = snapshot.data[0];
            return SingleChildScrollView(
              child: Container(
                //color: Colors.blue,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: listeSousProduit.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            // Display
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return ProduitEcran.setId(1, "");
                                }
                                ));
                          },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff7c94b6),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.dstATop),
                                  image: NetworkImage(
                                    'https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${listeSousProduit[index].lienweb}?alt=media',
                                  ),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(listeSousProduit[index].libelle,
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