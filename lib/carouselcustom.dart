import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'beanproduit.dart';
import 'httpbeans/beanarticledetail.dart';

class CarouselInterface extends StatelessWidget{
  const CarouselInterface({super.key, required this.liste});

  final List<Produit> liste;

  @override
  Widget build(BuildContext context){
    return CarouselSlider.builder(
      itemCount: liste.length,
      itemBuilder: (BuildContext context, int itemIndex, int t) => Container(
        margin: const EdgeInsets.all(6.0),
        child: CachedNetworkImage(
          imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[itemIndex].lienweb}?alt=media",
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
    );
  }
}

class ProduitInterface extends StatelessWidget{

  const ProduitInterface({super.key, required this.liste});
  final List<Produit> liste;

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: liste.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(10),
          width: 130,
          height: 120,
          //color: Colors.red,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[index].lienweb}?alt=media"
                        ),
                        fit: BoxFit.fill
                    )
                ),
              ),
              Expanded(
                  child: Text(liste[index].libelle,
                  )
              )
            ],
          ),
        );
      });
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
          childAspectRatio: 0.80,
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
                ),
                Expanded(
                  child: SizedBox(
                    child: Container(
                      //margin: const EdgeInsets.only(top: 10),
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("${liste[index].articlerestant} élément(s) restant(s)",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 12
                          ),
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
