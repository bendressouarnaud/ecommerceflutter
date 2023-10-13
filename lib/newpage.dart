import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newecommerce/beanproduit.dart';
import 'package:newecommerce/skeleton.dart';
import 'package:shimmer/shimmer.dart';
import 'carouselcustom.dart';
import 'constants.dart';
import 'package:http/http.dart';

import 'ecrancompte.dart';
import 'httpbeans/beanarticledetail.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // A t t r i b u t e s  :
  late Future<List<Produit>> futureProduit;
  late Future<List<Beanarticledetail>> futureBeanarticle;
  late bool _isLoading;
  int callNumber = 0;
  int currentPageIndex = 0;


  // M e t h o d  :
  @override
  void initState() {
    _isLoading = true;
    //futureProduit = produitLoading();
    //futureBeanarticle = recentProduitLoading();
    /*Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });*/
    super.initState();
  }

  // Get Products :
  Future<List<Produit>> produitLoading() async {
    final url = Uri.parse('http://10.1.4.102:8080/backendcommerce/getmobileAllProduits');
    Response response = await get(url);
    if(response.statusCode == 200){
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body = jsonDecode(response.body);
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

  // Get Recent Added Products :
  Future<List<Beanarticledetail>> recentProduitLoading() async {
    final url = Uri.parse('http://10.1.4.102:8080/backendcommerce/getmobilerecentarticles');
    final response = await get(url);
    if(response.statusCode == 200){
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body = jsonDecode(response.body);
      List<Beanarticledetail> posts = body
          .map(
            (dynamic item) => Beanarticledetail.fromJson(item),
      )
          .toList();
      return posts;
      //return Beanarticledetail.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          )
        ),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[300],
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket),
            label: 'Commande',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.account_box),
            label: 'Compte',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      ),
      body: <Widget>[
        SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([produitLoading(), recentProduitLoading()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                List<Produit> pt =  snapshot.data[0];
                List<Beanarticledetail> bl =  snapshot.data[1];
                return Column(
                  children: [
                    CarouselInterface(liste: pt),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: const Text("Produit",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
                      child: ProduitInterface(liste: pt),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: const Text("Derniers produits ajoutés",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 510,
                      width: MediaQuery.of(context).size.width,
                      child: GridViewLastProduct(liste: bl),
                    )
                  ],
                );
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) => const NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: defaultPadding),
                );
              }
            },
          ),
        ),
        Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: const Text('Page 1'),
        ),
        const EcranCompte(),
      ][currentPageIndex]
      /*SingleChildScrollView(
        child: FutureBuilder(
          future: Future.wait([produitLoading(), recentProduitLoading()]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              List<Produit> pt =  snapshot.data[0];
              List<Beanarticledetail> bl =  snapshot.data[1];

              return Column(
                children: [
                  CarouselInterface(liste: pt),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: const Text("Produit",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: ProduitInterface(liste: pt),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: const Text("Derniers produits ajoutés",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 510,
                    width: MediaQuery.of(context).size.width,
                    child: GridViewLastProduct(liste: bl),
                  )
                ],
              );
            } else {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) => const NewsCardSkelton(),
                separatorBuilder: (context, index) =>
                const SizedBox(height: defaultPadding),
              );
            }
          },
        ),
      ),*/
    );
  }
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey[500]!,
      child: const Row(
        children: [
          Skeleton(height: 120, width: 120),
          SizedBox(width: defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 80),
                SizedBox(height: defaultPadding / 2),
                Skeleton(),
                SizedBox(height: defaultPadding / 2),
                Skeleton(),
                SizedBox(height: defaultPadding / 2),
                Row(
                  children: [
                    Expanded(
                      child: Skeleton(),
                    ),
                    SizedBox(width: defaultPadding),
                    Expanded(
                      child: Skeleton(),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      )
      );
}
