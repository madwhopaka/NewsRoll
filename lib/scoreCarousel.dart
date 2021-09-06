import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'livescore_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async_loader/async_loader.dart';
import 'package:url_launcher/url_launcher.dart';

class carouselSlider extends StatefulWidget {
  @override
  _carouselSliderState createState() => _carouselSliderState();
}

class _carouselSliderState extends State<carouselSlider> {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  void initState() {
    super.initState();
    getCricData();
  }

  var cric_api_key =
      'dba53bd54a1735b45edb0256390e8cd4169a0391db77d939ad7283e5c312f772';
  var livescore_list = [];

  void goToUrl(c1, c2) async {
    var myurl =
        'https://www.google.com/search?q=${c1}+${c2}+match&rlz=1C1VDKB_enIN928IN929&oq=india+england+match+&aqs=chrome..69i57j0i131i433i512l7j0i512j0i131i433i512.10692j0j4&sourceid=chrome&ie=UTF-8';
    if (await canLaunch(myurl)) {
      await launch(myurl, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not lauch the url';
    }
  }

  Future<List> getCricData() async {
    var url =
        'https://api.api-cricket.com/cricket/?method=get_livescore&APIkey=${cric_api_key}';
    var requ_resp = await http.get(Uri.parse(url));
    var jsonRes = jsonDecode(requ_resp.body);
    print(jsonRes);
    if (jsonRes['success'] == 1 && jsonRes['result'] != null) {
      jsonRes['result'].forEach((element) {
        LiveScore livescore = LiveScore(
          event_home_country: element['event_home_team'],
          event_away_country: element['event_away_team'],
          start: element['event_date_start'],
          end: element['event_date_stop'],
          event_status_info: element['event_status_info'],
          event_status: element['event_status'],
          event_service_away: element['event_service_away'],
          event_service_home: element['event_service_home'],
          event_home_final_result: element['event_home_final_result'],
          event_away_final_result: element['event_away_final_result'],
          event_home_team_logo: element['event_home_team_logo'],
          event_away_team_logo: element['event_away_team_logo'],
          event_live: element['event_live'],
        );
        // livescore_list.add(livescore);
      });
    }

    return livescore_list;
  }

  Widget getCarousel(data) {
    print(livescore_list.isNotEmpty);
    return livescore_list.isNotEmpty
        ? CarouselSlider.builder(
            options: CarouselOptions(height: 230, autoPlay: false),
            itemCount: data.length,
            itemBuilder: (context, intindex, realIndex) {
              var current = data[intindex];
              var start_month = current.start.substring(5, 7);
              var end_month = current.end.substring(5, 7);
              var start = current.start.substring(9, 10);
              var end = current.end.substring(9, 10);
              start_month = int.parse(start_month) - 1;
              end_month = int.parse(end_month) - 1;

              var months = [
                'Jan',
                "Feb",
                'Mar',
                "Apr",
                "May",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Oct",
                "Nov",
                "Dec"
              ];
              start_month = months[start_month];
              end_month = months[end_month];
              if (current.event_home_country.length > 10) {
                current.event_home_country =
                    current.event_home_country.substring(0, 5);
              }
              if (current.event_away_country.length > 10) {
                current.event_away_country =
                    current.event_away_country.substring(0, 5);
              }
              return Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      image: DecorationImage(
                          image: AssetImage('scoreboardbg.jpg'),
                          fit: BoxFit.cover)),
                  width: 300,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 20),
                  child: Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text("Current Cricket Matches",
                          style: GoogleFonts.rubik(color: Colors.white)),
                    ),
                    GestureDetector(
                      onTap: () => goToUrl(current.event_home_country,
                          current.event_away_country),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: Colors.white54,
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 150,
                              child: Column(children: <Widget>[
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          start +
                                              " " +
                                              start_month +
                                              " - " +
                                              end +
                                              " " +
                                              end_month,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black54)),
                                      current.event_live == '1'
                                          ? Text('Live',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black54))
                                          : Text('Not Live',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.black54))
                                    ]),
                                Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.blue)),
                                                  height: 30,
                                                  width: 30,
                                                  child: Image(
                                                      image: NetworkImage(current
                                                          .event_away_team_logo))),
                                              Text(current.event_away_country)
                                            ]),
                                            Text(
                                                current.event_away_final_result)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(current
                                                .event_home_final_result),
                                            Column(children: <Widget>[
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.blue)),
                                                  height: 30,
                                                  width: 30,
                                                  child: Image(
                                                      image: NetworkImage(current
                                                          .event_home_team_logo))),
                                              Text(current.event_home_country),
                                            ])
                                          ],
                                        )
                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: Center(
                                      child: current.event_status_info != null
                                          ? Text(current.event_status_info,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.9))
                                          : Text("Status not available")),
                                )
                              ]))),
                    )
                  ]));
            })
        : Container(
            decoration: BoxDecoration(
                color: Colors.pink[200],
                image: DecorationImage(
                    image: AssetImage('scoreboardbg.jpg'), fit: BoxFit.cover)),
            width: 300,
            height: 200,
            margin: EdgeInsets.fromLTRB(5, 10, 5, 20),
            child: Center(
                child: Text("Couldn't fetch the livescore !",
                    style: GoogleFonts.lato(
                        fontSize: 19, color: Colors.white))));
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getCricData(),
      renderLoad: () => Container(
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
      renderError: ([error]) => Container(
          decoration: BoxDecoration(
              color: Colors.blue[200],
              image: DecorationImage(
                  image: AssetImage('scoreboardbg.jpg'), fit: BoxFit.cover)),
          width: 300,
          margin: EdgeInsets.fromLTRB(5, 10, 5, 20),
          child: Center(
              child: Text("Couldn't fetch the LiveScore !",
                  style:
                      GoogleFonts.lato(fontSize: 19, color: Colors.white60)))),
      renderSuccess: ({data}) => getCarousel(data),
    );

    return Container(child: _asyncLoader);
  }
}
