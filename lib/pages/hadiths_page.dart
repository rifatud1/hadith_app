import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadith/pages/hadith_page_solo.dart';
import 'package:http/http.dart' as http;

class HadithPage extends StatefulWidget {
  final String? chapterSerial;
  final String? chapterNameBengali;
  final String? bookKey;

  const HadithPage({
    Key? key,
    required String? this.chapterSerial,
    required String? this.chapterNameBengali,
    required String this.bookKey,
  }) : super(key: key);

  @override
  _HadithPageState createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  late Future<List> hadithfuture;

  Future<List> getHadithsList() async {
    var response = await http.get(Uri.parse(
        "http://alquranbd.com/api/hadith/${widget.bookKey}/${widget
            .chapterSerial}"));
    if (response.statusCode == 200) {
      var resData = jsonDecode(response.body);
      return resData;
    } else {
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hadithfuture = getHadithsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterNameBengali!),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder(
          future: hadithfuture,
          builder: (BuildContext context, AsyncSnapshot<List> sn) {
            if (sn.hasData) {
              return ListView.builder(
                itemCount: sn.data!.length,
                itemBuilder: (context, index) =>
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              HadithPageSolo(
                                  hadith: sn.data![index]["hadithBengali"],
                                  hadithTitle: sn.data![index]["rabiNameBn"],
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
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            child: Text(sn.data![index]["hadithNo"],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),),
                          ),
                          title: Text(sn.data![index]["topicName"],
                            style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(sn.data![index]["rabiNameBn"],
                            style: TextStyle(fontStyle: FontStyle.italic),),
                        ),
                      ),
                    ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
