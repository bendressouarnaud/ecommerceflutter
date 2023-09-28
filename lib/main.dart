import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // https://medium.flutterdevs.com/explore-shimmer-animation-effect-in-flutter-7b0e46a9c722
  // https://www.digitalocean.com/community/tutorials/flutter-flutter-http
  // https://docs.flutter.dev/cookbook/networking/send-data

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              const CarouselInterface(),
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 170,
                child: ProduitInterface(),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text("Derniers produits ajoutés",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      color: Colors.black
                  ),
                ),
              ),
              SizedBox(
                height: 510,
                width: MediaQuery.of(context).size.width,
                child: const GridViewLastProduct(),
              )
            ],
          ),
        ),
      ),

    );
  }
}


class CarouselInterface extends StatelessWidget{
  const CarouselInterface({super.key});

  @override
  Widget build(BuildContext context){
    return CarouselSlider(
      items: [
        //1st Image of Slider
        Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: const DecorationImage(
              image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/17fa4813-b5f5-4847-a7f6-5bbaee6ad505.jpg?alt=media"),
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
              image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/54929894-5db4-4157-be07-cbd3b97af70b.jpg?alt=media"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        //3nd Image of Slider
        Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: const DecorationImage(
              image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/ac1a9855-da04-45d6-abeb-f1fb540a331c.jpeg?alt=media"),
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
                const Text("Viande",
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
  const GridViewLastProduct({super.key});

  // Attributes  :
  final customColor = const Color(0xFFDEDDE3);


  @override
  Widget build(BuildContext context){
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: 0.85,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(3),
          color: customColor,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                height: 160,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/547a5f22-9600-417d-8585-b2513af99cde.png?alt=media"
                        ),
                        fit: BoxFit.fill
                    )
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Kunding PLus Tea",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("8250",
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(3),
          color: customColor,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                height: 160,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/adb285fb-f9c8-4987-8f06-37848eca6ade.png?alt=media"
                        ),
                        fit: BoxFit.fill
                    )
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Wake JQQ Fresh Drink",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("9600",
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[300],
          child: const Text('Sound of screams but the'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[400],
          child: const Text('Who scream'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[500],
          child: const Text('Revolution is coming...'),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[600],
          child: const Text('Revolution, they...'),
        ),
      ],
    );
  }
}