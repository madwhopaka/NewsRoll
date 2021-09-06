import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container( alignment: Alignment.center,
                child: Text(
                  "NewsRoll",
                  style: GoogleFonts.lobster(fontSize: 60, color: Colors.grey),
                ),
              ),
              Container(
                  height: 400,
                  width: 500,
                  child: Image(
                    image: AssetImage('assets/splashscr.jpg'),
                  )),
              Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Text("Made by Madwho ",
                        style: GoogleFonts.roboto(
                            fontSize: 20, color: Colors.black)),
                    Icon(
                      Icons.headphones,
                      color: Color.fromRGBO(92, 107, 192, 1.0),
                    ),
                  ])),
            ]));
  }
}
