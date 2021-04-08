import 'package:flutter/material.dart';
import 'package:jaikisan_movie_app/bloc/get_now_playing_bloc.dart';
import 'package:jaikisan_movie_app/model/movie.dart';
import 'package:jaikisan_movie_app/model/movie_response.dart';
import 'package:jaikisan_movie_app/screens/detail_screen.dart';
import 'package:jaikisan_movie_app/style/theme.dart' as Style;
import 'package:page_indicator/page_indicator.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    nowPlayingMoviesBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingMoviesBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return _buildErrorWidget(snapshot.data.error);
          }
          return _buildHomeWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Container(
      height: 220.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          ),
          SizedBox(
            height: 25.0,
            width: 25.0,
          ),
          Text(
            "Loading Movies..",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildHomeWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else
      return Container(
        height: 220.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: movies.take(movies.length).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.titleColor,
          indicatorSelectorColor: Style.Colors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(movies.length).length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  //TODO
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movie: movies[index]),
                    ),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 220.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(movies[index].backPoster ==
                                        null
                                    ? "https://image.tmdb.org/t/p/original/" +
                                        movies[index].poster
                                    : "https://image.tmdb.org/t/p/original/" +
                                        movies[index].backPoster)),
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                              0.0,
                              0.9
                            ],
                            colors: [
                              Style.Colors.mainColor.withOpacity(1.0),
                              Style.Colors.mainColor.withOpacity(0.0)
                            ]),
                      ),
                    ),
                    Positioned(
                        bottom: 30.0,
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                movies[index].title,
                                style: TextStyle(
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              );
            },
          ),
        ),
      );
  }
}
