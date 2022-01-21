import 'package:flutter/material.dart';

class HadithPageSolo extends StatefulWidget {
  final String? hadith;
  final String? hadithTitle;

  const HadithPageSolo({
    Key? key,
    required String? this.hadith,
    required String? this.hadithTitle,
  }) : super(key: key);

  @override
  State<HadithPageSolo> createState() => _HadithPageSoloState();
}

class _HadithPageSoloState extends State<HadithPageSolo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hadithTitle!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(widget.hadith!, style: TextStyle(fontSize: 22),textAlign: TextAlign.justify,),

        ),
      ),
    );
  }
}
