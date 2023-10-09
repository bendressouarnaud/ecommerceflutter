import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newecommerce/beanproduit.dart';
import 'package:newecommerce/skeleton.dart';
import 'package:shimmer/shimmer.dart';
import 'carouselcustom.dart';
import 'constants.dart';
import 'package:http/http.dart';

import 'httpbeans/beanarticledetail.dart';

class EcranCompte extends StatefulWidget {
  const EcranCompte({Key? key}) : super(key: key);

  @override
  State<EcranCompte> createState() => _NewEcranState();
}

class _NewEcranState extends State<EcranCompte> {
  // A t t r i b u t e s  :
  late Future<List<Produit>> futureProduit;
  late Future<List<Beanarticledetail>> futureBeanarticle;
  late bool _isLoading;
  int callNumber = 0;
  int currentPageIndex = 0;


  // M e t h o d  :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Gouabo", textAlign: TextAlign.start, ),
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
        ),*/
        body: Container(
          color: Colors.brown[50],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 7, left: 7),
                color: Colors.black,
                child: Row(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Bonjour\nGérer vos données",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                    Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange[400]
                            ),
                            child: const Text("CONNECTEZ-VOUS",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          ),
                        )
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 7, left: 7),
                margin: const EdgeInsets.only(top: 10),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text("MON COMPTE",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(right: 7, left: 7),
                child: const Row(
                  children: [
                    Icon(
                      Icons.emoji_people,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Parrainage"),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      )
                    ),
                  ]
                ),
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(right: 7, left: 7),
                child: const Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Filleul"),
                      Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          )
                      ),
                    ]
                ),
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(right: 7, left: 7),
                child: const Row(
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Bonus"),
                      Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          )
                      ),
                    ]
                ),
              )
            ],
          ),
        )
    );
  }
}
