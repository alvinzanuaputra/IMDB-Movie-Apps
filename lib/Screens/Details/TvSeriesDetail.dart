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

class TvSeriesDetails extends StatefulWidget {
  var id;
  TvSeriesDetails({super.key, this.id});

  @override
  State<TvSeriesDetails> createState() => _TvSeriesDetailsState();
}

class _TvSeriesDetailsState extends State<TvSeriesDetails> {
  List<Map<String, dynamic>> TvSeriesDetails = [];
  List<Map<String, dynamic>> TvSeriesREview = [];
  List<Map<String, dynamic>> similarserieslist = [];
  List<Map<String, dynamic>> recommendserieslist = [];
  List<Map<String, dynamic>> seriestrailerslist = [];

  List<String> _genres = [];
  List<Map<String, dynamic>> _creators = [];
  int _seasonCount = 0;

  late Future<void> _tvDetailsFuture;

  Future<void> tvseriesdetailfunc() async {
    TvSeriesDetails.clear();
    TvSeriesREview.clear();
    similarserieslist.clear();
    recommendserieslist.clear();
    seriestrailerslist.clear();
    _genres.clear();
    _creators.clear();
    _seasonCount = 0;

    final tvseriesdetailurl = UrlPack.tvDetails(widget.id);
    final tvseriesreviewurl = UrlPack.tvReviews(widget.id);
    final similarseriesurl = UrlPack.tvSimilar(widget.id);
    final recommendseriesurl = UrlPack.tvRecommendations(widget.id);
    final seriestrailersurl = UrlPack.tvVideos(widget.id);

    final tvseriesdetailresponse = await http.get(Uri.parse(tvseriesdetailurl));
    if (tvseriesdetailresponse.statusCode == 200) {
      final tvseriesdetaildata = jsonDecode(tvseriesdetailresponse.body);
      TvSeriesDetails.add({
        'backdrop_path': tvseriesdetaildata['backdrop_path'],
        'title': tvseriesdetaildata['original_name'],
        'vote_average': tvseriesdetaildata['vote_average'],
        'overview': tvseriesdetaildata['overview'],
        'status': tvseriesdetaildata['status'],
        'releasedate': tvseriesdetaildata['first_air_date'],
      });

      for (final genre in tvseriesdetaildata['genres']) {
        _genres.add(genre['name'].toString());
      }

      for (final creator in tvseriesdetaildata['created_by']) {
        _creators.add({
          'creator': creator['name'],
          'creatorprofile': creator['profile_path'],
        });
      }

      _seasonCount = (tvseriesdetaildata['seasons'] as List).length;
    }

    final tvseriesreviewresponse = await http.get(Uri.parse(tvseriesreviewurl));
    if (tvseriesreviewresponse.statusCode == 200) {
      final tvseriesreviewdata = jsonDecode(tvseriesreviewresponse.body);
      for (var i = 0; i < tvseriesreviewdata['results'].length; i++) {
        TvSeriesREview.add({
          'name': tvseriesreviewdata['results'][i]['author'],
          'review': tvseriesreviewdata['results'][i]['content'],
          'rating': tvseriesreviewdata['results'][i]['author_details']
                      ['rating'] ==
                  null
              ? 'Not Rated'
              : tvseriesreviewdata['results'][i]['author_details']['rating']
                  .toString(),
          'avatarphoto': tvseriesreviewdata['results'][i]['author_details']
                      ['avatar_path'] ==
                  null
              ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
              : UrlPack.imageBaseUrl +
                  tvseriesreviewdata['results'][i]['author_details']
                      ['avatar_path'],
          'creationdate':
              tvseriesreviewdata['results'][i]['created_at'].substring(0, 10),
          'fullreviewurl': tvseriesreviewdata['results'][i]['url'],
        });
      }
    }

    final similarseriesresponse = await http.get(Uri.parse(similarseriesurl));
    if (similarseriesresponse.statusCode == 200) {
      final similarseriesdata = jsonDecode(similarseriesresponse.body);
      for (var i = 0; i < similarseriesdata['results'].length; i++) {
        similarserieslist.add({
          'poster_path': similarseriesdata['results'][i]['poster_path'],
          'name': similarseriesdata['results'][i]['original_name'],
          'vote_average': similarseriesdata['results'][i]['vote_average'],
          'id': similarseriesdata['results'][i]['id'],
          'Date': similarseriesdata['results'][i]['first_air_date'],
        });
      }
    }

    final recommendseriesresponse =
        await http.get(Uri.parse(recommendseriesurl));
    if (recommendseriesresponse.statusCode == 200) {
      final recommendseriesdata = jsonDecode(recommendseriesresponse.body);
      for (var i = 0; i < recommendseriesdata['results'].length; i++) {
        recommendserieslist.add({
          'poster_path': recommendseriesdata['results'][i]['poster_path'],
          'name': recommendseriesdata['results'][i]['original_name'],
          'vote_average': recommendseriesdata['results'][i]['vote_average'],
          'id': recommendseriesdata['results'][i]['id'],
          'Date': recommendseriesdata['results'][i]['first_air_date'],
        });
      }
    }

    final tvseriestrailerresponse =
        await http.get(Uri.parse(seriestrailersurl));
    if (tvseriestrailerresponse.statusCode == 200) {
      final tvseriestrailerdata = jsonDecode(tvseriestrailerresponse.body);
      for (var i = 0; i < tvseriestrailerdata['results'].length; i++) {
        final item = tvseriestrailerdata['results'][i];
        final type = item['type']?.toString() ?? '';
        final site = item['site']?.toString() ?? '';
        final key = item['key']?.toString() ?? '';
        if (site == 'YouTube' &&
            (type == 'Trailer' || type == 'Teaser' || type == 'Clip') &&
            key.isNotEmpty) {
          seriestrailerslist.add({'key': key});
        }
      }
      if (seriestrailerslist.isEmpty) {
        seriestrailerslist.add({'key': 'aJ0cZTcTh90'});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tvDetailsFuture = tvseriesdetailfunc();
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
        : (isTablet ? 300.0 : MediaQuery.of(context).size.height * 0.36);
    final creatorCardWidth = isDesktop ? 130.0 : (isTablet ? 118.0 : 110.0);
    final creatorListHeight = isDesktop ? 144.0 : 130.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B111B),
      body: FutureBuilder(
        future: _tvDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              TvSeriesDetails.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6A3D)),
            );
          }

          final details = TvSeriesDetails[0];

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF0B111B),
                expandedHeight: appBarHeight,
                pinned: true,
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
                    trailerytid: seriestrailerslist.isNotEmpty
                        ? seriestrailerslist[0]['key']
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
                          const SizedBox(height: 10),
                          _ratingCard(details['vote_average'].toString()),
                          addtofavoriate(
                            id: widget.id,
                            type: 'tv',
                            Details: TvSeriesDetails,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final genre in _genres) _pill(genre),
                              _pill('Status: ${details['status']}'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          tittletext('Ringkasan Serial'),
                          const SizedBox(height: 8),
                          overviewtext(details['overview'].toString()),
                          const SizedBox(height: 16),
                          _metaRow('Total Musim', _seasonCount.toString()),
                          const SizedBox(height: 8),
                          _metaRow('Tanggal Rilis', details['releasedate']),
                          const SizedBox(height: 16),
                          if (_creators.isNotEmpty) ...[
                            tittletext('Dibuat Oleh'),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: creatorListHeight,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _creators.length,
                                itemBuilder: (context, index) {
                                  final creator = _creators[index];
                                  final profile = creator['creatorprofile'];
                                  final imageUrl = profile == null
                                      ? 'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'
                                      : UrlPack.imageUrl(profile.toString());

                                  return Container(
                                    width: creatorCardWidth,
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF141E2D),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: isDesktop ? 34 : 30,
                                          backgroundImage:
                                              NetworkImage(imageUrl),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          creator['creator'].toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFFE5EAF4),
                                            fontSize: isDesktop ? 13 : 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          ReviewUI(revdeatils: TvSeriesREview),
                          const SizedBox(height: 10),
                          sliderlist(
                            similarserieslist,
                            'Serial Serupa',
                            'tv',
                            similarserieslist.length,
                          ),
                          sliderlist(
                            recommendserieslist,
                            'Recommended Series',
                            'tv',
                            recommendserieslist.length,
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
