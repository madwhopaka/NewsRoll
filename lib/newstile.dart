import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsTile extends StatelessWidget {
  final Function urlGetter;
  final title;
  final author;
  final description;
  final publishedAt;
  final linktoSite;
  final imageUrl;
  final content;
  final source;
  const NewsTile({
    this.title,
    this.author,
    this.description,
    this.publishedAt,
    this.linktoSite,
    this.imageUrl,
    this.content,
    this.source,
    required this.urlGetter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)))),
      child: Column(children: <Widget>[
        GestureDetector(
          onTap: this.linktoSite!=''? ()=>{print(this.linktoSite) , this.urlGetter(this.linktoSite)} : ()=>{} ,
          child: Card(
              borderOnForeground: true,
              elevation: 4.3,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        Container(child: Image(image: NetworkImage(imageUrl))),
                  ),
                ],
              )),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 30),
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Container(
                  child: Text(this.title,
                      style: GoogleFonts.openSans(
                          fontSize: 17, fontWeight: FontWeight.w600)),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Source: " + this.source,
                            style: TextStyle(
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            )),
                        Text("Published: " + this.publishedAt.toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                            )),
                      ],
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    margin: EdgeInsets.only(top: 10),
                    child: Text(this.description,
                        style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        )))
              ],
            ))
      ]),
    );
  }
}
