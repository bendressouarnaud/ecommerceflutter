import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:newecommerce/sousproduit.dart';
import 'package:http/http.dart' as https;

class SearchEcran extends StatefulWidget {

  // Attribute
  final https.Client client;

  const SearchEcran({Key? key, required this.client}) : super(key: key);

  @override
  State<SearchEcran> createState() => _NewSearch();
}

class _NewSearch extends State<SearchEcran> {

  // A T T R I B U T E S
  late https.Client client;

  // M E T H O D S
  @override
  void initState() {
    client = widget.client;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Recherche", textAlign: TextAlign.start, ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
          ),
          actions: [
            /*IconButton(
                onPressed: (){},
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black,)
            ),*/
            IconButton(
                onPressed: (){
                  showSearch(
                    context: context,
                    delegate: LookDelegate.setClient(client)
                  );
                },
                icon: const Icon(Icons.search, color: Colors.black)
            )
          ],
        ),
      body: Container(),
    );
  }
}


//
class LookDelegate extends SearchDelegate{
  
  //
  late https.Client client;

  LookDelegate.setClient(this.client);

  // Dummy list
  List<String> searchList = [
    "Apple",
    "Banana",
    "Cherry",
    "Date",
    "Fig",
    "Grapes",
    "Kiwi",
    "Lemon",
    "Mango",
    "Orange",
    "Papaya",
    "Raspberry",
    "Strawberry",
    "Tomato",
    "Watermelon",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          if(query.isEmpty){
            close(context, null);
          }
          else {
            query = '';
          }
        },
        icon: const Icon(
            Icons.clear
        )
    )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      },
      icon: const Icon(
       Icons.arrow_back
      )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> searchResults = searchList
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            // Handle the selected search result.
            close(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> liste = [];
    return FutureBuilder(
      future:Future.wait([getDataRequested(query)]),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          liste = snapshot.data[0];
        }

        return ListView.builder(
          itemCount: liste.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(liste[index]),
              onTap: () {
                query = liste[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Sousproduitecran.setParams(5, 0, liste[index], client);
                  })
                );
                // Show the search results based on the selected suggestion.
              },
            );
          },
        );
      }
    );
  }

  // Get SUB-Product :
  Future<List<String>> getDataRequested(String query) async {
    if(query.isEmpty || (query.length < 2)) return [];
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/lookforuserrequest');
    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "lib": query,
          "id": 0
        }));
    if(response.statusCode == 200){
      //response.body
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<String> posts = body.map((dynamic item) => item as String).toList();
      if(posts.isNotEmpty) {
        searchList = posts;
      }
      return posts;
    } else {
      return [];
    }
  }

}