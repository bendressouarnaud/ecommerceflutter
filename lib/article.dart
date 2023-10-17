import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'constants.dart';
import 'httpbeans/beanarticledatahistory.dart';
import 'newpage.dart';

class ArticleEcran extends StatefulWidget {

  // Attribute
  int idart = 0;
  int fromadapter = 0;
  int qte = 0;

  ArticleEcran({Key? key}) : super(key: key);
  ArticleEcran.setId(this.idart, this.fromadapter, this.qte);

  @override
  State<ArticleEcran> createState() => _NewArticle();
}

class _NewArticle extends State<ArticleEcran> {

  // A T T R I B U T E S
  late int idart;


  // M E T H O D S
  @override
  void initState() {
    super.initState();

    idart = widget.idart;
  }

  Future<Beanarticledatahistory> getmobilearticleinformationbyidart() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobilearticleinformationbyidart');

    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idart": idart,
          "iduser": 0,
        }));

    if(response.statusCode == 200){
      return Beanarticledatahistory.fromJson(jsonDecode(response.body));
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
        body: FutureBuilder(
            future: Future.wait([getmobilearticleinformationbyidart()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                Beanarticledatahistory article =  snapshot.data[0];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: CarouselSlider.builder(
                          itemCount: article.images.length,
                          itemBuilder: (BuildContext context, int itemIndex, int t) => Container(
                            margin: const EdgeInsets.all(6.0),
                            child: CachedNetworkImage(
                              imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${article.images[itemIndex].lienweb}?alt=media",
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          options: CarouselOptions(
                            height: 200.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                            viewportFraction: 0.8,
                          ),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Text(article.article,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10, top: 10),
                        child: Row(
                          children: [
                            Text("Entreprise : ",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                            Text(article.entreprise.toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                color: entreprisename
                              ),
                            )
                          ],
                        ),
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
        )
    );
  }

}