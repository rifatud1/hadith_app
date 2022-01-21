import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadith/pages/chapters_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List> booksListFuture;

  Future<List> getBooks() async {
    var response = await http.get(Uri.parse("http://alquranbd.com/api/hadith"));
    if (response.statusCode == 200) {
      List resData = jsonDecode(response.body);
      return resData;
    } else {
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booksListFuture = getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hadith"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder(
            future: booksListFuture,
            builder: (BuildContext context, AsyncSnapshot<List> sn) {
              if (sn.hasData) {
                //List? bigData = sn.data;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: sn.data!.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChaptersList(
                            bookName: sn.data![index]["nameBengali"],
                            bookKey: sn.data![index]["book_key"],
                          ),
                        ),
                      );
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        shadowColor: Colors.blueAccent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: Image.asset('assets/images/$index.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                sn.data![index]["nameBengali"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ],
                        )
                        /*ListTile(
                          leading: CircleAvatar(
                            child: Text(data[index]["id"]),
                          ),
                          title: Text(data[index]["nameBengali"]),
                          subtitle: Text(data[index]["book_key"]),
                        ),*/
                        ),
                  ),
                );
              } else if (sn.hasError) {
                return Text("Problem Loading Data");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
