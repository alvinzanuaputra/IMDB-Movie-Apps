import 'package:imdbmoviesapps/Scripts/UrlPack.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Widgets/SliderList.dart';
import 'package:imdbmoviesapps/Widgets/RepeatedText.dart';

class Upcomming extends StatefulWidget {
  const Upcomming({super.key});

  @override
  State<Upcomming> createState() => _UpcommingState();
}

class _UpcommingState extends State<Upcomming> {
  List<Map<String, dynamic>> getUpcomminglist = [];
  late Future<void> _upcomingFuture;

  Future<void> getUpcomming() async {
    getUpcomminglist.clear();
    var url = Uri.parse(UrlPack.upcomingMovies);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      for (var i = 0; i < json['results'].length; i++) {
        getUpcomminglist.add({
          "poster_path": json['results'][i]['poster_path'],
          "name": json['results'][i]['title'],
          "vote_average": json['results'][i]['vote_average'],
          "Date": json['results'][i]['release_date'],
          "id": json['results'][i]['id'],
        });
      }
    } else {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
    _upcomingFuture = getUpcomming();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isEnglish,
      builder: (context, english, _) {
        return FutureBuilder(
            future: _upcomingFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    sliderlist(
                      getUpcomminglist,
                      english ? 'Upcoming' : 'Segera Hadir',
                      'movie',
                      getUpcomminglist.length,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 16, bottom: 40),
                      child: tittletext(
                        english
                            ? 'More titles coming soon...'
                            : 'Banyak Lagi Segera Hadir...',
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.orange));
              }
            });
      },
    );
  }
}
