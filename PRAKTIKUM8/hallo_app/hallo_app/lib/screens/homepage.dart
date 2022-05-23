import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hallo_app/screens/product_detail.dart';
import 'package:http/http.dart' as http;

import 'edit_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String? url = 'http://10.0.127.246:8000/api/authors';

  //android emulator http://10.0.2.2
  Future getProducts() async {
    var response = await http.get(Uri.parse(url!));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future deleteProduct(String product) async {
    String url = "http://10.0.127.246:8000/api/authors" + product;
    
    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Rollo Store'),
        ),
        body: FutureBuilder(
          future: getProducts(),
          builder: (context,AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
              return Container(
                height: 180,
                child: Card(
                    elevation: 5,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context)=>
                                      ProductDetail(product: snapshot.data['data']
                                          [index],
                                    )));
                            },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 120,
                            width: 120,
                            child: Image.network(
                              snapshot.data[index]['name'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: 
                                  MainAxisAlignment.spaceAround,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    snapshot.data[index]['name'],
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(snapshot.data[index]
                                    ['email']),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                    children: [
                                      GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              EditProduct(product: snapshot
                                                                      .data
                                                              [index],
                                              )));
                                      },
                                      child: Icon(Icons.edit)),
                                      GestureDetector(
                                      onTap: (){
                                        deleteProduct(snapshot
                                                  .data[index]
                                                            ['id']
                                                  .toString())
                                            .then((value){
                                          setState(() {});
                                          ScaffoldMessenger.of(
                                                    context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Produk berhasil di hapus"),
                      ));
                                          });
                                      },
                                      child: Icon(Icons.delete)),
                                    ]
                                    ),
                                    Text(snapshot.data[index]
                                            ['github']
                                        .toString())
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            } else {
                return Text('Data ERROR');
              }
            }));
  
  }
}