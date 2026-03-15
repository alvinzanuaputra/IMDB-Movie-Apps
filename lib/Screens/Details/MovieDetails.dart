import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:imdbmoviesapps/Screens/Home/HomePage.dart';
import 'package:imdbmoviesapps/Scripts/UrlPack.dart';
import 'package:imdbmoviesapps/Widgets/FavoriteAndShare.dart';
import 'package:imdbmoviesapps/Widgets/RepeatedText.dart';
import 'package:imdbmoviesapps/Widgets/ReviewUi.dart';
import 'package:imdbmoviesapps/Widgets/SliderList.dart';
import 'package:imdbmoviesapps/Widgets/TrailerUi.dart';

class MovieDetails extends StatefulWidget {
  var id;
  MovieDetails({super.key, this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  List<Map<String, dynamic>> MovieDetails = [];
  List<Map<String, dynamic>> UserREviews = [];
  List<Map<String, dynamic>> similarmovieslist = [];
  List<Map<String, dynamic>> recommendedmovieslist = [];
  List<Map<String, dynamic>> movietrailerslist = [];
  late Future<void> _movieDetailsFuture;

  List MoviesGeneres = [];

  Future<void> Moviedetails() async {
    MovieDetails.clear();
    UserREviews.clear();
    similarmovieslist.clear();
    recommendedmovieslist.clear();
    movietrailerslist.clear();
    MoviesGeneres.clear();

    final moviedetailurl = UrlPack.movieDetails(widget.id);
    final userReviewurl = UrlPack.movieReviews(widget.id);
    final similarmoviesurl = UrlPack.movieSimilar(widget.id);
    final recommendedmoviesurl = UrlPack.movieRecommendations(widget.id);
    final movietrailersurl = UrlPack.movieVideos(widget.id);

    final moviedetailresponse = await http.get(Uri.parse(moviedetailurl));
    if (moviedetailresponse.statusCode == 200) {
      final moviedetailjson = jsonDecode(moviedetailresponse.body);
      MovieDetails.add({
        'backdrop_path': moviedetailjson['backdrop_path'],
        'title': moviedetailjson['title'],
        'vote_average': moviedetailjson['vote_average'],
        'overview': moviedetailjson['overview'],
        'release_date': moviedetailjson['release_date'],
        'runtime': moviedetailjson['runtime'],
        'budget': moviedetailjson['budget'],
        'revenue': moviedetailjson['revenue'],
      });
      for (var i = 0; i < moviedetailjson['genres'].length; i++) {
        MoviesGeneres.add(moviedetailjson['genres'][i]['name']);
      }
    }

    final userReviewresponse = await http.get(Uri.parse(userReviewurl));
    if (userReviewresponse.statusCode == 200) {
      final userReviewjson = jsonDecode(userReviewresponse.body);
      for (var i = 0; i < userReviewjson['results'].length; i++) {
        UserREviews.add({
          'name': userReviewjson['results'][i]['author'],
          'review': userReviewjson['results'][i]['content'],
          'rating':
              userReviewjson['results'][i]['author_details']['rating'] == null
                  ? 'Not Rated'
                  : userReviewjson['results'][i]['author_details']['rating']
                      .toString(),
          'avatarphoto': userReviewjson['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
              : UrlPack.imageBaseUrl +
                  userReviewjson['results'][i]['author_details']['avatar_path'],
          'creationdate':
              userReviewjson['results'][i]['created_at'].substring(0, 10),
          'fullreviewurl': userReviewjson['results'][i]['url'],
        });
      }
    }

    final similarmoviesresponse = await http.get(Uri.parse(similarmoviesurl));
    if (similarmoviesresponse.statusCode == 200) {
      final similarmoviesjson = jsonDecode(similarmoviesresponse.body);
      for (var i = 0; i < similarmoviesjson['results'].length; i++) {
        similarmovieslist.add({
          'poster_path': similarmoviesjson['results'][i]['poster_path'],
          'name': similarmoviesjson['results'][i]['title'],
          'vote_average': similarmoviesjson['results'][i]['vote_average'],
          'Date': similarmoviesjson['results'][i]['release_date'],
          'id': similarmoviesjson['results'][i]['id'],
        });
      }
    }

    final recommendedmoviesresponse =
        await http.get(Uri.parse(recommendedmoviesurl));
    if (recommendedmoviesresponse.statusCode == 200) {
      final recommendedmoviesjson = jsonDecode(recommendedmoviesresponse.body);
      for (var i = 0; i < recommendedmoviesjson['results'].length; i++) {
        recommendedmovieslist.add({
          'poster_path': recommendedmoviesjson['results'][i]['poster_path'],
          'name': recommendedmoviesjson['results'][i]['title'],
          'vote_average': recommendedmoviesjson['results'][i]['vote_average'],
          'Date': recommendedmoviesjson['results'][i]['release_date'],
          'id': recommendedmoviesjson['results'][i]['id'],
        });
      }
    }

    final movietrailersresponse = await http.get(Uri.parse(movietrailersurl));
    if (movietrailersresponse.statusCode == 200) {
      final movietrailersjson = jsonDecode(movietrailersresponse.body);
      for (var i = 0; i < movietrailersjson['results'].length; i++) {
        final item = movietrailersjson['results'][i];
        final type = item['type']?.toString() ?? '';
        final site = item['site']?.toString() ?? '';
        final key = item['key']?.toString() ?? '';

        if (site == 'YouTube' &&
            (type == 'Trailer' || type == 'Teaser' || type == 'Clip') &&
            key.isNotEmpty) {
          movietrailerslist.add({'key': key});
        }
      }
      if (movietrailerslist.isEmpty) {
        movietrailerslist.add({'key': 'aJ0cZTcTh90'});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = Moviedetails();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 700;
    final isDesktop = screenWidth >= 1100;
    final contentMaxWidth = isDesktop ? 980.0 : 860.0;
    final horizontalPadding = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);
    final appBarHeight = isDesktop
        ? 340.0
        : (isTablet ? 300.0 : MediaQuery.of(context).size.height * 0.38);

    return Scaffold(
      backgroundColor: const Color(0xFF0B111B),
      body: FutureBuilder(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              MovieDetails.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6A3D)),
            );
          }

          final details = MovieDetails[0];

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF0B111B),
                pinned: true,
                expandedHeight: appBarHeight,
                leading: _headerIcon(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: [SystemUiOverlay.bottom]);
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  _headerIcon(
                    icon: Icons.home_rounded,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: trailerwatch(
                    trailerytid: movietrailerslist.isNotEmpty
                        ? movietrailerslist[0]['key']
                        : '',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 8, horizontalPadding, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ultratittletext(details['title'].toString()),
                          const SizedBox(height: 12),
                          _ratingCard(details['vote_average'].toString()),
                          addtofavoriate(
                            id: widget.id,
                            type: 'movie',
                            Details: MovieDetails,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final genre in MoviesGeneres)
                                _pill(genre.toString()),
                              _pill('${details['runtime']} menit'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          tittletext('Alur Cerita'),
                          const SizedBox(height: 8),
                          overviewtext(details['overview'].toString()),
                          const SizedBox(height: 18),
                          _metaRow('Tanggal Rilis', details['release_date']),
                          const SizedBox(height: 8),
                          _metaRow('Anggaran', details['budget'].toString()),
                          const SizedBox(height: 8),
                          _metaRow('Pendapatan', details['revenue'].toString()),
                          const SizedBox(height: 16),
                          ReviewUI(revdeatils: UserREviews),
                          const SizedBox(height: 10),
                          sliderlist(
                            similarmovieslist,
                            'Film Serupa',
                            'movie',
                            similarmovieslist.length,
                          ),
                          sliderlist(
                            recommendedmovieslist,
                            'Recommended Movies',
                            'movie',
                            recommendedmovieslist.length,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _headerIcon({required IconData icon, required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      color: const Color(0xFFF7F8FA),
      iconSize: 22,
    );
  }

  Widget _ratingCard(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF172338),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF35B6FF).withOpacity(0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFC857), size: 18),
          const SizedBox(width: 6),
          normaltext(rating),
        ],
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141E2D),
        borderRadius: BorderRadius.circular(999),
      ),
      child: genrestext(text),
    );
  }

  Widget _metaRow(String label, Object? value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141E2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFFBFC7D7)),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFFF7F8FA),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
