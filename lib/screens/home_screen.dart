import 'package:flutter/material.dart';
import 'package:jaikisan_movie_app/style/theme.dart' as Style;
import 'package:jaikisan_movie_app/widgets/best_movies.dart';
import 'package:jaikisan_movie_app/widgets/genres.dart';
import 'package:jaikisan_movie_app/widgets/now_playing.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.Colors.mainColor,
        appBar: AppBar(
          backgroundColor: Style.Colors.mainColor,
          centerTitle: true,
          title: Text("JK Movie App"),
        ),
        body: ListView(
          children: <Widget>[
            NowPlaying(),
            GenresScreen(),
            BestMovies(),
          ],
        ));
  }
}

/*
return ListView(
children: <Widget>[
NowPlaying(),
GenresScreen(),
BestMovies(),
],
);*/
