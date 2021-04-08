import 'package:flutter/material.dart';
import 'package:jaikisan_movie_app/model/movie_reviews.dart';
import 'package:jaikisan_movie_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesReviewsBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieReviewsResponse> _subject =
      BehaviorSubject<MovieReviewsResponse>();

  getMoviesReview(int id) async {
    MovieReviewsResponse response = await _repository.getMoviesReviews(id);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  BehaviorSubject<MovieReviewsResponse> get subject => _subject;
}

final moviesReviewBloc = MoviesReviewsBloc();
