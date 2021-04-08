import 'reviews.dart';

class MovieReviewsResponse {
  final List<Reviews> reviews;
  final String error;

  MovieReviewsResponse(this.reviews, this.error);

  MovieReviewsResponse.fromJson(Map<String, dynamic> json)
      : reviews = (json["results"] as List)
            .map((i) => new Reviews.fromJson(i))
            .toList(),
        error = "";

  MovieReviewsResponse.withError(String errorValue)
      : reviews = [],
        error = errorValue;
}
