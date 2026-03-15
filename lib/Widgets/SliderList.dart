import 'package:imdbmoviesapps/Scripts/UrlPack.dart';
import 'package:flutter/material.dart';
import 'package:imdbmoviesapps/Widgets/RepeatedText.dart';
import 'package:imdbmoviesapps/Screens/Details/MovieDetails.dart';
import 'package:imdbmoviesapps/Screens/Details/TvSeriesDetail.dart';

Widget sliderlist(
    List firstlistname, String categorytittle, String type, int itemlength) {
  if (itemlength == 0) {
    return const SizedBox.shrink();
  }

  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 20, bottom: 12),
        child: tittletext(categorytittle)),
    LayoutBuilder(builder: (context, constraints) {
      final width = MediaQuery.sizeOf(context).width;
      final isTablet = width >= 700;
      final isDesktop = width >= 1100;
      final cardWidth = isDesktop ? 182.0 : (isTablet ? 168.0 : 148.0);
      final sliderHeight = isDesktop ? 250.0 : (isTablet ? 236.0 : 220.0);
      final overlayHeight = isDesktop ? 92.0 : (isTablet ? 88.0 : 84.0);

      return SizedBox(
          height: sliderHeight,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: itemlength,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      if (type == 'movie') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieDetails(
                                      id: firstlistname[index]['id'],
                                    )));
                      } else if (type == 'tv') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TvSeriesDetails(
                                    id: firstlistname[index]['id'])));
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFF35B6FF).withOpacity(0.16),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 8))
                            ],
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.18),
                                    BlendMode.darken),
                                image: NetworkImage(UrlPack.imageUrl(
                                    firstlistname[index]['poster_path']
                                        .toString())),
                                fit: BoxFit.cover)),
                        margin: EdgeInsets.only(
                            left: index == 0 ? 16 : 8,
                            right: index == itemlength - 1 ? 16 : 8,
                            bottom: 10),
                        width: cardWidth,
                        child: Stack(children: [
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  height: overlayHeight,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(18),
                                          bottomRight: Radius.circular(18)),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.92),
                                            Colors.transparent
                                          ])))),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF111B2B)
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: datetext(
                                    firstlistname[index]['Date']?.toString() ??
                                        '')),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF111B2B)
                                        .withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(6)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: Row(children: [
                                  const Icon(Icons.star,
                                      color: Color(0xFFFFC857), size: 14),
                                  const SizedBox(width: 4),
                                  ratingtext(firstlistname[index]
                                          ['vote_average']
                                      .toString())
                                ])),
                          )
                        ])));
              }));
    }),
    const SizedBox(height: 10)
  ]);
}
