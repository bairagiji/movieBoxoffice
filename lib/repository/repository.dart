import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:jaikisan_movie_app/model/cast_response.dart';
import 'package:jaikisan_movie_app/model/genre_response.dart';
import 'package:jaikisan_movie_app/model/movie_detail_response.dart';
import 'package:jaikisan_movie_app/model/movie_response.dart';
import 'package:jaikisan_movie_app/model/movie_reviews.dart';
import 'package:jaikisan_movie_app/model/video_response.dart';

class MovieRepository {
  final String apiKey = "<<ADD YOUR TMDB KEY HERE>>";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();

  //TODO Best popular movies
  var getPopularUrl = '$mainUrl/movie/top_rated';

  //TODO movies based on genres
  var getMoviesUrl = '$mainUrl/discover/movie';

  //TODO get the genres list
  var getGenresUrl = "$mainUrl/genre/movie/list";

  //TODO Show movies as editor's choice
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var movieUrl = "$mainUrl/movie";

  //To get the ISO 3166-1 code
  // PlatformDispatcher.instance.locale.countryCode};
  // PlatformDispatcher.instance.locale.languageCode};
  // PlatformDispatcher.instance.locale.toLanguageTag()};

  Future<MovieResponse> getMovies() async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
      "region": PlatformDispatcher.instance.locale.countryCode,
      "page": 2
    };
    try {
      Response response =
          await _dio.get(getPopularUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getPlayingMovies() async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
      "region": PlatformDispatcher.instance.locale.countryCode,
      "page": 1
    };
    try {
      Response response =
          await _dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<GenreResponse> getGenres() async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.languageCode
    };
    try {
      Response response = await _dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return GenreResponse.withError("$error");
    }
  }

  Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
      "region": PlatformDispatcher.instance.locale.countryCode,
      "watch_region": PlatformDispatcher.instance.locale.countryCode,
      "page": 2,
      "with_genres": id
    };
    try {
      Response response = await _dio.get(getMoviesUrl, queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
    };
    try {
      Response response =
          await _dio.get(movieUrl + "/$id", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieDetailResponse.withError("$error");
    }
  }

  Future<VideoResponse> getMovieVideos(int id) async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
    };
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/videos",
          queryParameters: params);
      return VideoResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return VideoResponse.withError("$error");
    }
  }

  Future<MovieResponse> getSimilarMovies(int id) async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
    };
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/similar",
          queryParameters: params);
      return MovieResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieResponse.withError("$error");
    }
  }

  Future<CastResponse> getCasts(int id) async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
    };
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/credits",
          queryParameters: params);
      return CastResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return CastResponse.withError("$error");
    }
  }

  Future<MovieReviewsResponse> getMoviesReviews(int id) async {
    var params = {
      "api_key": apiKey,
      "language": PlatformDispatcher.instance.locale.toLanguageTag(),
    };
    try {
      Response response = await _dio.get(movieUrl + "/$id" + "/reviews",
          queryParameters: params);
      return MovieReviewsResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieReviewsResponse.withError("$error");
    }
  }
}
