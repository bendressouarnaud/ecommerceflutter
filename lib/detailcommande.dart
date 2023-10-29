
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/repositories/user_repository.dart';

import 'constants.dart';
import 'httpbeans/beanarticlehistocommande.dart';
import 'httpbeans/beancommandeprojection.dart';
import 'models/user.dart';
import 'newpage.dart';

class DetailCommandeEcran extends StatelessWidget {

  // A T T R I B U T E S
  final UserRepository _userRepository = UserRepository();
  String dates="", heure="";


  // M E T H O D S :
  DetailCommandeEcran({super.key});
  DetailCommandeEcran.setPeriod(this.dates, this.heure);


  // Send Account DATA :
  Future<BeanArticleHistoCommande?> getcustomercommandearticle() async {
    // Pick User Id :
    User? usr = await _userRepository.getConnectedUser();
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getcustomercommandearticle');
    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "dates": dates,
          "heure": heure,
          "idcli": usr!.idcli
        }));
    // Checks :
    if(response.statusCode == 200){
      return BeanArticleHistoCommande.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  //
  String formatPrice(int price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price.toDouble()
    );
    //
    return fmf.output.withoutFractionDigits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: Future.wait([getcustomercommandearticle()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                BeanArticleHistoCommande cmd = snapshot.data[0];
                return SingleChildScrollView(
                  //physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 70),
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        //color: Colors.amber[50],
                        child: Icon(
                          Icons.card_giftcard,
                          color: Colors.brown[500],
                          size: 70,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 7, left: 7, right: 7),
                        child: Row(
                          children: [
                            Text(dates,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(heure,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('Total article : ${cmd.totalarticle}',
                            style: const TextStyle(
                                fontSize: 16
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 2, left: 7, right: 7),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('${formatPrice(cmd.totalprix)} FCFA',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: cmd.listearticle.length,
                          itemBuilder: (BuildContext contextList, int index) {
                            return GestureDetector(
                                onTap: () {

                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 2, left: 7, right: 7),
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  color: cardviewsousproduit,  // Colors.blueGrey
                                  child: Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: 110,
                                          height: 110,
                                          margin: const EdgeInsets.only(left: 5, top: 5),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${cmd.listearticle[index].lienweb}?alt=media",
                                            imageBuilder: (context, imageProvider) => Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                      cmd.listearticle[index].libelle.toLowerCase().length > 25 ?
                                                      "${cmd.listearticle[index].libelle.substring(0,20)} ..." :
                                                      cmd.listearticle[index].libelle,
                                                      style: const TextStyle(
                                                          fontSize: 18
                                                      )
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('${formatPrice(cmd.listearticle[index].prix)} FCFA',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                )
                            );
                          }
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