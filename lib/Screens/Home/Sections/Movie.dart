import 'package:imdbmoviesapps/Scripts/UrlPack.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Widgets/SliderList.dart';

class Movie extends StatefulWidget {
  const Movie({super.key});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  List<Map<String, dynamic>> popularmovies = [];
  List<Map<String, dynamic>> nowplayingmovies = [];

  List<Map<String, dynamic>> topratedmovies = [];
  List<Map<String, dynamic>> latestmovies = [];
  late Future<void> _moviesFuture;

  Future<void> moviesfunction() async {
    popularmovies.clear();
    nowplayingmovies.clear();
    topratedmovies.clear();
    latestmovies.clear();

    var popularmoviesurl = UrlPack.popularMovies;
    var nowplayingmoviesurl = UrlPack.nowPlayingMovies;
    var topratedmoviesurl = UrlPack.topRatedMovies;
    var latestmoviesurl = UrlPack.latestMovies;

    var popularmoviesresponse = await http.get(Uri.parse(popularmoviesurl));
    if (popularmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(popularmoviesresponse.body);
      var popularmoviesjson = tempdata['results'];
      for (var i = 0; i < popularmoviesjson.length; i++) {
        popularmovies.add({
          "name": popularmoviesjson[i]["title"],
          "poster_path": popularmoviesjson[i]["poster_path"],
          "vote_average": popularmoviesjson[i]["vote_average"],
          "Date": popularmoviesjson[i]["release_date"],
          "id": popularmoviesjson[i]["id"],
        });
      }
    } else {
      print(popularmoviesresponse.statusCode);
    }
    /////////////////////////////////////////////
    var nowplayingmoviesresponse =
        await http.get(Uri.parse(nowplayingmoviesurl));
    if (nowplayingmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(nowplayingmoviesresponse.body);
      var nowplayingmoviesjson = tempdata['results'];
      for (var i = 0; i < nowplayingmoviesjson.length; i++) {
        nowplayingmovies.add({
          "name": nowplayingmoviesjson[i]["title"],
          "poster_path": nowplayingmoviesjson[i]["poster_path"],
          "vote_average": nowplayingmoviesjson[i]["vote_average"],
          "Date": nowplayingmoviesjson[i]["release_date"],
          "id": nowplayingmoviesjson[i]["id"],
        });
      }
    } else {
      print(nowplayingmoviesresponse.statusCode);
    }
    /////////////////////////////////////////////
    var topratedmoviesresponse = await http.get(Uri.parse(topratedmoviesurl));
    if (topratedmoviesresponse.statusCode == 200) {
      var tempdata = jsonDecode(topratedmoviesresponse.body);
      var topratedmoviesjson = tempdata['results'];
      for (var i = 0; i < topratedmoviesjson.length; i++) {
        topratedmovies.add({
          "name": topratedmoviesjson[i]["title"],
          "poster_path": topratedmoviesjson[i]["poster_path"],
          "vote_average": topratedmoviesjson[i]["vote_average"],
          "Date": topratedmoviesjson[i]["release_date"],
          "id": topratedmoviesjson[i]["id"],
        });
      }
    } else {
      print(topratedmoviesresponse.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    _moviesFuture = moviesfunction();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isEnglish,
      builder: (context, english, _) {
        return FutureBuilder(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Colors.orange.shade400));
              } else {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    sliderlist(
                      popularmovies,
                      english ? 'Popular Now' : 'Populer Saat Ini',
                      'movie',
                      popularmovies.length,
                    ),
                    sliderlist(
                      nowplayingmovies,
                      english ? 'Now Playing' : 'Sedang Tayang',
                      'movie',
                      nowplayingmovies.length,
                    ),
                    sliderlist(
                      topratedmovies,
                      english ? 'Top Rated' : 'Peringkat Atas',
                      'movie',
                      topratedmovies.length,
                    ),
                  ],
                );
              }
            });
      },
    );
  }
}
