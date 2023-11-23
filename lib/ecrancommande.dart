
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/repositories/user_repository.dart';

import 'constants.dart';
import 'detailcommande.dart';
import 'httpbeans/beancommandeprojection.dart';
import 'models/user.dart';
import 'newpage.dart';
import 'package:http/http.dart' as https;

class CommandeEcran extends StatelessWidget {
  CommandeEcran({super.key});
  CommandeEcran.setcli(this.client);

  // A T T R I B U T E S
  https.Client? client;
  final UserRepository _userRepository = UserRepository();


  // Send Account DATA :
  Future<List<BeanCommandeProjection>> historicalcommande() async {

    // Pick User Id :
    User? usr = await _userRepository.getConnectedUser();

    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobilehistoricalcommande');
    var response = await client!.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": usr!.idcli
        }));

    // Checks :
    List<BeanCommandeProjection> posts = [];
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      posts = body.map(
        (dynamic item) => BeanCommandeProjection.fromJson(item),
      ).toList();
    }

    return posts;
  }

  //
  String formatPrice(int price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price.toDouble()
    );
    //
    return fmf.output.withoutFractionDigits;
  }

  String procesState(int traite, int emission,int livre){
    String ret = "";
    if(traite == 1) ret = "Validée";
    else ret = "En attente";
    if(emission == 1) ret = "Livraison en cours ...";
    if(livre == 1) ret = "Livrée";
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([historicalcommande()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            List<BeanCommandeProjection> lt = snapshot.data[0];
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: lt.length,
              itemBuilder: (BuildContext contextList, int index) {
                return GestureDetector(
                  onTap: () {
                    // Display
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context){
                            return DetailCommandeEcran.setAll(lt[index].dates, lt[index].heure, client);
                          }
                        )
                    );
                  },
                  child: Container(
                    height: 130,
                    margin: EdgeInsets.all(4),
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey[50],
                    ),
                    //width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.brown[500],
                                size: 25,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(lt[index].dates,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(procesState(lt[index].traites, lt[index].emissions, lt[index].livres),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.brown[500],
                                  size: 25,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(lt[index].heure,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          height: 30,
                          child: Row(
                              children: [
                                Text('${lt[index].nbrearticle} article(s) restant(s)',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text('${formatPrice(lt[index].montant)} FCFA',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                    )
                                )
                              ],
                            )
                        )
                      ],
                    ),
                  )
                );
              }
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