import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jaikisan_movie_app/bloc/get_movie_reviews_bloc.dart';
import 'package:jaikisan_movie_app/model/movie_reviews.dart';
import 'package:jaikisan_movie_app/model/reviews.dart';
import 'package:jaikisan_movie_app/style/theme.dart' as Style;

class MoviesReviews extends StatefulWidget {
  final int id;

  MoviesReviews({Key key, @required this.id}) : super(key: key);

  @override
  _MoviesReviewsState createState() => _MoviesReviewsState(id);
}

class _MoviesReviewsState extends State<MoviesReviews> {
  final int id;

  _MoviesReviewsState(this.id);

  @override
  void initState() {
    super.initState();
    moviesReviewBloc..getMoviesReview(id);
  }

  @override
  void dispose() {
    moviesReviewBloc..drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "REVIEWS",
            style: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieReviewsResponse>(
          stream: moviesReviewBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieReviewsResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return _buildErrorWidget(snapshot.data.error);
              }
              return _buildHomeWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
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
        )
      ],
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

  Widget _buildHomeWidget(MovieReviewsResponse data) {
    List<Reviews> reviews = data.reviews;
    if (reviews.length == 0) {
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
        height: 270.0,
        padding: EdgeInsets.only(left: 10.0),
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0),
              child: ExpansionTile(
                trailing: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                initiallyExpanded: false,
                children: [
                  Text(
                    reviews[index].content,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
                leading: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      // borderRadius:
                      // BorderRadius.all(Radius.circular(10.0)),
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: reviews[index].author_details["avatar_path"] ==
                                  null
                              ? NetworkImage(
                                  "https://cdn0.iconfinder.com/data/icons/set-ui-app-android/32/8-512.png")
                              : NetworkImage(
                                  "https://image.tmdb.org/t/p/w200/" +
                                      reviews[index]
                                          .author_details["avatar_path"])),
                    )),
                title: Text(
                  reviews[index].author ??
                      reviews[index].author_details["username"],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: RatingBarIndicator(
                  rating: reviews[index].author_details["rating"] ?? 0.0,
                  itemBuilder: (context, index) => Icon(
                    EvaIcons.star,
                    color: Style.Colors.primaryColor,
                  ),
                  itemCount: 10,
                  itemSize: 8.0,
                  unratedColor: Colors.white,
                  direction: Axis.horizontal,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
          ),
        ),
      );
  }
}
