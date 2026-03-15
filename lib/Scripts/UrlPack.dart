import 'package:imdbmoviesapps/Core/Api/ApiKey.dart';

class UrlPack {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Movies
  static String movieDetails(var id) => '$baseUrl/movie/$id?api_key=$apikey';
  static String movieReviews(var id) =>
      '$baseUrl/movie/$id/reviews?api_key=$apikey';
  static String movieSimilar(var id) =>
      '$baseUrl/movie/$id/similar?api_key=$apikey';
  static String movieRecommendations(var id) =>
      '$baseUrl/movie/$id/recommendations?api_key=$apikey';
  static String movieVideos(var id) =>
      '$baseUrl/movie/$id/videos?api_key=$apikey';

  static String get popularMovies => '$baseUrl/movie/popular?api_key=$apikey';
  static String get nowPlayingMovies =>
      '$baseUrl/movie/now_playing?api_key=$apikey';
  static String get topRatedMovies =>
      '$baseUrl/movie/top_rated?api_key=$apikey';
  static String get latestMovies => '$baseUrl/movie/latest?api_key=$apikey';
  static String get upcomingMovies => '$baseUrl/movie/upcoming?api_key=$apikey';

  // TV Series
  static String tvDetails(var id) => '$baseUrl/tv/$id?api_key=$apikey';
  static String tvReviews(var id) => '$baseUrl/tv/$id/reviews?api_key=$apikey';
  static String tvSimilar(var id) => '$baseUrl/tv/$id/similar?api_key=$apikey';
  static String tvRecommendations(var id) =>
      '$baseUrl/tv/$id/recommendations?api_key=$apikey';
  static String tvVideos(var id) => '$baseUrl/tv/$id/videos?api_key=$apikey';

  static String get popularTv => '$baseUrl/tv/popular?api_key=$apikey';
  static String get topRatedTv => '$baseUrl/tv/top_rated?api_key=$apikey';
  static String get onTheAirTv => '$baseUrl/tv/on_the_air?api_key=$apikey';

  // Trending & Search
  static String get trendingAllWeek =>
      '$baseUrl/trending/all/week?api_key=$apikey';
  static String get trendingAllDay =>
      '$baseUrl/trending/all/day?api_key=$apikey';
  static String multiSearch(String query) =>
      '$baseUrl/search/multi?api_key=$apikey&query=$query';

  // Images
  static String imageUrl(String path) => '$imageBaseUrl$path';
}
