import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'beanproduit.dart';
import 'httpbeans/beanarticledetail.dart';

class CarouselInterface extends StatelessWidget{
  const CarouselInterface({super.key, required this.liste});

  final List<Produit> liste;
  // https://pub.dev/packages/cached_network_image

  @override
  Widget build(BuildContext context){
    return CarouselSlider.builder(
      itemCount: liste.length,
      itemBuilder: (BuildContext context, int itemIndex, int t) => Container(
        margin: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: CachedNetworkImage("https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[itemIndex].lienweb}?alt=media"),
            fit: BoxFit.cover,
          ),
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
    );
  }
}

class ProduitInterface extends StatelessWidget{
  const ProduitInterface({super.key});

  @override
  Widget build(BuildContext context){
    return ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: 130,
            height: 120,
            color: Colors.red,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/17fa4813-b5f5-4847-a7f6-5bbaee6ad505.jpg?alt=media"
                          ),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                const Expanded(
                    child: Text("Viande",
                    )
                )
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            width: 130,
            height: 120,
            child: Column(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/54929894-5db4-4157-be07-cbd3b97af70b.jpg?alt=media"
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                const Text("Diététique",
                )
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            width: 130,
            height: 120,
            child: Column(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/ac1a9855-da04-45d6-abeb-f1fb540a331c.jpeg?alt=media"
                          ),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                const Text("Epicerie",
                )
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(10),
            width: 130,
            height: 120,
            child: Column(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/f82cb469-b9c6-4f1c-a3de-ecaa3fa4bac9.jpg?alt=media"
                          ),
                          fit: BoxFit.contain
                      )
                  ),
                ),
                const Text("Vêtement",
                )
              ],
            ),
          )
        ]
    );
  }
}


class GridViewLastProduct extends StatelessWidget{
  const GridViewLastProduct({super.key, required this.liste});

  // Attributes  :
  final customColor = const Color(0xFFDEDDE3);
  final List<Beanarticledetail> liste;


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: liste.length,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            padding: const EdgeInsets.all(3),
            color: customColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[index].lienweb}?alt=media"
                          ),
                          fit: BoxFit.fill
                      )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(liste[index].libelle.length > 23 ?
                   "${liste[index].libelle.substring(0,17)} ..." : liste[index].libelle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${liste[index].prix} FCFA",
                    textAlign: TextAlign.start,
                  ),
                )
              ],
            ),
          );
        });
  }
}