import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:newecommerce/repositories/user_repository.dart';

import 'article.dart';
import 'constants.dart';
import 'httpbeans/beancustomercreation.dart';
import 'httpbeans/beanresumearticledetail.dart';
import 'httpbeans/commune.dart';
import 'models/user.dart';
import 'newpage.dart';

class Sousproduitecran extends StatefulWidget {

  // Attribute
  int mode = 0;
  int iddet = 0;
  String lib = "";

  Sousproduitecran({Key? key}) : super(key: key);
  Sousproduitecran.setId(this.mode, this.iddet, this.lib);

  @override
  State<Sousproduitecran> createState() => _NewSousproduit();
}

class _NewSousproduit extends State<Sousproduitecran> {

  // LINK :
  // https://api.flutter.dev/flutter/material/AlertDialog-class.html

  // A t t r i b u t e s  :
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  late bool _isLoading;
  // Initial value :
  var dropdownvalue = "Koumassi";
  String defaultGenre = "M";
  final lesGenres = ["M", "F"];
  final _userRepository = UserRepository();
  late BuildContext dialogContext;
  bool flagSendData = false;

  //
  late int mode;
  late int iddet;
  late  String lib;




  // M e t h o d  :
  @override
  void initState() {
    super.initState();

    mode = widget.mode;
    iddet = widget.iddet;
    lib = widget.lib;
  }


  // Get VILLE :
  Future<List<BeanResumeArticleDetail>> processus() async {

    switch(mode){
      case 2:
        // SOUS-PRODUIT :
        //viewmodel.setLibSousProduit( extras.getString("lib"));
        //getarticlesBasedonLib();
        break;

      case 3:
      // DETAIL
        return await getarticlesbasedoniddet();
        break;

      case 4:
        // Display All PROMOTED ARTICLE
        //getpromotedarticles();
        break;

      case 5:
        // Display Porduct whose name is familiar to the one requested by user :
        //lookforwhatuserrequested();
        break;

      default:
        // DETAIL
        //iddet = extras.getInt("id", 0);
        //getarticlesbasedoniddet(iddet);
        break;
    }

    return [];
  }

  Future<List<BeanResumeArticleDetail>> getarticlesbasedoniddet() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getarticlesbasedoniddet');

    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": iddet
        }));

    if(response.statusCode == 200){
      _isLoading = true;
      List<dynamic> body = jsonDecode(response.body);
      List<BeanResumeArticleDetail> posts = body
          .map(
            (dynamic item) => BeanResumeArticleDetail.fromJson(item),
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(lib, textAlign: TextAlign.start, ),
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
            future: Future.wait([processus()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                List<BeanResumeArticleDetail> liste =  snapshot.data[0];
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: liste.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // Display
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ArticleEcran.setId(liste[index].beanarticle.idart, 0, 0);
                          }
                          )
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        color: cardviewsousproduit,
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 110,
                                height: 110,
                                //color: Colors.green,
                                margin: const EdgeInsets.only(left: 5, top: 5),
                                child: CachedNetworkImage(
                                  alignment: Alignment.topCenter,
                                  width: 100,
                                  height: 100,
                                  imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[index].beanarticle.lienweb}?alt=media",
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
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(liste[index].beanarticle.libelle,
                                            style: TextStyle(

                                            )
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('${liste[index].beanarticle.prix} FCFA',
                                            style: TextStyle(

                                            )
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            Text('${liste[index].beanarticle.prix} FCFA',
                                                style: TextStyle(

                                                )
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('- 40%',
                                                style: TextStyle(

                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('${liste[index].beanarticle.articlerestant} article(s) restant(s)',
                                            style: TextStyle(
                                                color: Colors.grey
                                            )
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                                Icons.star_outline
                                            ),
                                            Icon(
                                                Icons.star_outline
                                            ),
                                            Icon(
                                                Icons.star_outline
                                            ),
                                            Icon(
                                                Icons.star_outline
                                            ),
                                            Icon(
                                                Icons.star_outline
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: butcardviewsousproduit,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.all(16.0),
                                              textStyle: const TextStyle(fontSize: 20),
                                            ),
                                            onPressed: () {},
                                            child: const Text('Achetez'),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
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