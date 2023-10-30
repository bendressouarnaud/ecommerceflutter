import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/produit.dart';

import 'article.dart';
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
          placeholder: (context, url) => const CircularProgressIndicator(
            color: Colors.amber,
          ),
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
        return GestureDetector(
          onTap: () {
            //Get.to(ProduitEcran.setId(liste[index].idprd, liste[index].libelle));
            // Display
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ProduitEcran.setId(liste[index].idprd, liste[index].libelle);
              }
            ));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 130,
            height: 120,
            //color: Colors.red,

            child: Column(
              children: [
                Container(
                  //padding: const EdgeInsets.all(20),
                  //color: Colors.blueGrey[100],
                  width: 130,
                  height: 120,

                  child: CachedNetworkImage(
                    width: 110,
                    height: 110,
                    //fit: BoxFit.fill,
                    imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[index].lienweb}?alt=media",
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
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[index].lienweb}?alt=media"
                          ),
                          fit: BoxFit.fill
                      )
                  ),*/
                ),
                Expanded(
                    child: Text(liste[index].libelle,
                    )
                )
              ],
            ),
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


  // METHOD :
  String formatPrice(int price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price.toDouble()
    );
    //
    return fmf.output.withoutFractionDigits;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      physics: const NeverScrollableScrollPhysics(),
      maxCrossAxisExtent: 200.0, // maximum item width
      mainAxisSpacing: 8.0, // spacing between rows
      crossAxisSpacing: 8.0, // spacing between columns
      childAspectRatio: MediaQuery.of(context).size.width /  (MediaQuery.of(context).size.height / 1.6),
      padding: const EdgeInsets.all(8.0), // padding around the grid
      children: liste.map((item) {
        return GestureDetector(
          onTap: () {
            // Display
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
            color: customColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
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
                  child: Text(item.libelle.length > 23 ?
                  "${item.libelle.substring(0,17)} ..." : item.libelle,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold
                      )
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${formatPrice(item.prix)} FCFA",
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("${item.articlerestant} élément(s) restant(s)",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        );
      }).toList(),

      /*itemCount: liste.length,
      itemBuilder: (BuildContext ctx, index) {
          return ;
        }*/
    );
  }
}
