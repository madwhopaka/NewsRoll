import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'article_model.dart';
import 'dart:convert';
import 'newstile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'splashScreen.dart';
import 'scoreCarousel.dart';
import 'package:async_loader/async_loader.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'newsroll',
        theme: ThemeData(brightness: Brightness.light),
        home: Intro());
  }
}

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Skeleton())));
  }

  @override
  Widget build(BuildContext context) {
    return SplashScr();
  }
}

class Skeleton extends StatefulWidget {
  const Skeleton({Key? key}) : super(key: key);

  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  var api_key = "9a3e20839aea4d4c82a480adc0f92ec1";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              titleSpacing: 0.0,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/logo.png'), height: 50),
                    Center(
                      child: Text("NewsRoll",
                          style: GoogleFonts.lobster(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                    ),
                  ]),
              bottom: TabBar(
                  unselectedLabelColor: Color.fromRGBO(92, 107, 192, 1.0),
                  indicatorWeight: 2,
                  isScrollable: true,
                  labelPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  tabs: [
                    Text("LATEST",
                        style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(92, 107, 192, 1.0),
                            fontWeight: FontWeight.w800)),
                    Text("BUSINESS",
                        style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(92, 107, 192, 1.0),
                            fontWeight: FontWeight.w800)),
                    Text("TECHNOLOGY",
                        style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(92, 107, 192, 1.0),
                            fontWeight: FontWeight.w800)),
                    Text("BOLLYWOOD",
                        style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(92, 107, 192, 1.0),
                            fontWeight: FontWeight.w800)),
                    Text("WORLD",
                        style: GoogleFonts.playfairDisplay(
                            color: Color.fromRGBO(92, 107, 192, 1.0),
                            fontWeight: FontWeight.w800))
                  ])),
          body: TabBarView(children: [
            LatestPage(
                taburl:
                    'https://newsapi.org/v2/top-headlines?country=in&apiKey=${api_key}',
                cricScore: 1),
            LatestPage(
                taburl:
                    'https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=${api_key}'),
            LatestPage(
                taburl:
                    'https://newsapi.org/v2/everything?q=technology&apiKey=${api_key}'),
            LatestPage(
                taburl:
                    'https://newsapi.org/v2/top-headlines?country=in&category=entertainment&apiKey=${api_key}'),
            LatestPage(
                taburl:
                    'https://newsapi.org/v2/everything?q=international&apiKey=${api_key}'),
          ])),
    );
  }
}

class LatestPage extends StatefulWidget {
  const LatestPage({this.taburl, this.cricScore});

  final cricScore;
  final taburl;

  @override
  _LatestPageState createState() => _LatestPageState();
}

class _LatestPageState extends State<LatestPage> {
  List<Article> news = [];

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

////////////////////// GO INTO THE BROWSER
  void goToUrl(url) async {
    var myurl = url;
    if (await canLaunch(url)) {
      await launch(myurl, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not lauch the url';
    }
  }

// // // // // // // // // // // // // ///          GET THE DATA FROM THE API

  Future<List> getData() async {
    var response = await http.get(Uri.parse(widget.taburl));
    var jsonData = jsonDecode(response.body);
    setState(() {
      if (jsonData['status'] == 'ok') {
        jsonData["articles"].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            Article article = Article(
                title: element['title'],
                author: element['author'],
                desc: element['description'],
                url: element['url'],
                urlToImage: element['urlToImage'],
                publishedAt: DateTime.parse(element['publishedAt']),
                content: element['content'],
                source_name: element['source']['name']);
            news.add(article);
          }
        });
      }
    });
    return news;
  }

  Widget getListView(news) {
    return ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          var art = news[index];

          return NewsTile(
            title: art.title,
            author: art.author,
            description: art.desc,
            linktoSite: art.url,
            imageUrl: art.urlToImage,
            publishedAt: art.publishedAt,
            content: art.content,
            source: art.source_name,
            urlGetter: goToUrl,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getData(),
      renderLoad: () => new Center(
        child: Container(
            height: 30, width: 30, child: CircularProgressIndicator()),
      ),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => getListView(data),
    );
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.cricScore == 1 ? carouselSlider() : Container(),
          Container(
            height: 30,
            child: Text("Headlines",
                style: GoogleFonts.lobster(
                  fontSize: 25,
                )),
          ),
          Expanded(child: _asyncLoader)
        ],
      ),
    );
  }
}
