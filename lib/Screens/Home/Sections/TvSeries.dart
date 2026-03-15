import 'package:imdbmoviesapps/Scripts/UrlPack.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Widgets/SliderList.dart';

class TvSeries extends StatefulWidget {
  const TvSeries({super.key});

  @override
  State<TvSeries> createState() => _TvSeriesState();
}

class _TvSeriesState extends State<TvSeries> {
  List<Map<String, dynamic>> populartvseries = [];
  List<Map<String, dynamic>> topratedtvseries = [];
  List<Map<String, dynamic>> onairtvseries = [];
  var populartvseriesurl = UrlPack.popularTv;
  var topratedtvseriesurl = UrlPack.topRatedTv;
  var onairtvseriesurl = UrlPack.onTheAirTv;
  late Future<void> _tvSeriesFuture;

  Future<void> tvseriesfunction() async {
    populartvseries.clear();
    topratedtvseries.clear();
    onairtvseries.clear();

    /////////////////////////////////////////////
    var populartvresponse = await http.get(Uri.parse(populartvseriesurl));
    if (populartvresponse.statusCode == 200) {
      var tempdata = jsonDecode(populartvresponse.body);
      var populartvjson = tempdata['results'];
      for (var i = 0; i < populartvjson.length; i++) {
        populartvseries.add({
          "name": populartvjson[i]["name"],
          "poster_path": populartvjson[i]["poster_path"],
          "vote_average": populartvjson[i]["vote_average"],
          "Date": populartvjson[i]["first_air_date"],
          "id": populartvjson[i]["id"],
        });
      }
    } else {
      print(populartvresponse.statusCode);
    }
    /////////////////////////////////////////////
    var topratedtvresponse = await http.get(Uri.parse(topratedtvseriesurl));
    if (topratedtvresponse.statusCode == 200) {
      var tempdata = jsonDecode(topratedtvresponse.body);
      var topratedtvjson = tempdata['results'];
      for (var i = 0; i < topratedtvjson.length; i++) {
        topratedtvseries.add({
          "name": topratedtvjson[i]["name"],
          "poster_path": topratedtvjson[i]["poster_path"],
          "vote_average": topratedtvjson[i]["vote_average"],
          "Date": topratedtvjson[i]["first_air_date"],
          "id": topratedtvjson[i]["id"],
        });
      }
    } else {
      print(topratedtvresponse.statusCode);
    }
    /////////////////////////////////////////////
    var onairtvresponse = await http.get(Uri.parse(onairtvseriesurl));
    if (onairtvresponse.statusCode == 200) {
      var tempdata = jsonDecode(onairtvresponse.body);
      var onairtvjson = tempdata['results'];
      for (var i = 0; i < onairtvjson.length; i++) {
        onairtvseries.add({
          "name": onairtvjson[i]["name"],
          "poster_path": onairtvjson[i]["poster_path"],
          "vote_average": onairtvjson[i]["vote_average"],
          "Date": onairtvjson[i]["first_air_date"],
          "id": onairtvjson[i]["id"],
        });
      }
    } else {
      print(onairtvresponse.statusCode);
    }
    /////////////////////////////////////////////
  }

  @override
  void initState() {
    super.initState();
    _tvSeriesFuture = tvseriesfunction();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isEnglish,
      builder: (context, english, _) {
        return FutureBuilder(
            future: _tvSeriesFuture,
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
                      populartvseries,
                      english ? 'Popular Now' : 'Populer Saat Ini',
                      'tv',
                      populartvseries.length,
                    ),
                    sliderlist(
                      onairtvseries,
                      english ? 'On Air Now' : 'Sedang Tayang',
                      'tv',
                      onairtvseries.length,
                    ),
                    sliderlist(
                      topratedtvseries,
                      english ? 'Top Rated' : 'Peringkat Atas',
                      'tv',
                      topratedtvseries.length,
                    ),
                  ],
                );
              }
            });
      },
    );
  }
}
