import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hadith/pages/hadiths_page.dart';
import 'package:http/http.dart' as http;

class ChaptersList extends StatefulWidget {
  final String? bookName;
  final String? bookKey;

  const ChaptersList({
    Key? key,
    required String this.bookName,
    required this.bookKey,
  }) : super(key: key);

  @override
  _ChaptersListState createState() => _ChaptersListState();
}

class _ChaptersListState extends State<ChaptersList> {
  late Future<List> chaptersListFuture;

  Future<List> getChaptersList() async {
    var response = await http.get(
      Uri.parse("http://alquranbd.com/api/hadith/${widget.bookKey}"),
    );
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
    chaptersListFuture = getChaptersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName!),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder(
          future: chaptersListFuture,
          builder: (BuildContext context, AsyncSnapshot<List> sn) {
            if (sn.hasData) {
              //List<dynamic>? data = sn.data;
              return ListView.builder(
                itemCount: sn.data!.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HadithPage(
                        chapterSerial: sn.data![index]["chSerial"],
                        chapterNameBengali: sn.data![index]["nameBengali"],
                        bookKey: widget.bookKey!,
                      )),
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
                        child: Text(sn.data![index]["chSerial"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      ),
                      title: Text(sn.data![index]["nameBengali"], style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(sn.data![index]["nameEnglish"]),
                    ),
                  ),
                ),
              );
            }else if(sn.hasError){
              return Text("Problem Showing Data");
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
