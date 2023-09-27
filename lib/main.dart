import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("GOUABO", textAlign: TextAlign.start, ),
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
        body: Container(
          color: Colors.grey,
          /*height: 500,*/
          child: Column(
            children: [
              CarouselSlider(
                items: [
                  //1st Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: NetworkImage("https://wallpaperaccess.com/full/2637581.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //2nd Image of Slider
                  Container(
                    margin: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: const DecorationImage(
                        image: NetworkImage("https://wallpaperaccess.com/full/2637581.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                ],

                //Slider Container properties
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
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text("Produit",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    color: Colors.black
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          color: Colors.blueGrey,
                          width: 130,
                          height: 120,
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
                                            "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/cb1fb208-686b-446d-b0a0-7f67602fa08f.png?alt=media"
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              const Text("Viande",
                              )
                            ],
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey,
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
                                            "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/9bdd7a39-e1b9-47ee-9752-2a5970705578.jpg?alt=media"
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              const Text("Viande",
                              )
                            ],
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey,
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
                                            "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/a7a04516-8840-49fc-83ac-6fd39b48a376.jpg?alt=media"
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              const Text("Viande",
                              )
                            ],
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey,
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
                                            "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/8840636d-025f-48c4-aead-6c59061e822a.jpg?alt=media"
                                        ),
                                        fit: BoxFit.contain
                                    )
                                ),
                              ),
                              const Text("Viande",
                              )
                            ],
                          ),
                        )
                      ]
                  ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text("Produit",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      color: Colors.black
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}