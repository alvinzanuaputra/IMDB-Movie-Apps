import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Core/App/AppMeta.dart';
import 'package:imdbmoviesapps/Screens/Details/Checker.dart';
import 'package:imdbmoviesapps/Screens/Home/Sections/Movie.dart';
import 'package:imdbmoviesapps/Screens/Home/Sections/TvSeries.dart';
import 'package:imdbmoviesapps/Screens/Home/Sections/Upcoming.dart';
import 'package:imdbmoviesapps/Scripts/UrlPack.dart';
import 'package:imdbmoviesapps/Widgets/CustomDrawer.dart';
import 'package:imdbmoviesapps/Widgets/SearchBarFunc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _trending = [];
  late Future<void> _trendingFuture;

  String _txt(String id, String en, bool english) => english ? en : id;

  Future<void> _loadTrending() async {
    _trending.clear();

    final response = await http.get(Uri.parse(UrlPack.trendingAllWeek));
    if (response.statusCode != 200) return;

    final temp = jsonDecode(response.body);
    final items = temp['results'] as List<dynamic>;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item['poster_path'] != null && item['media_type'] != null) {
        _trending.add({
          'id': item['id'],
          'poster_path': item['poster_path'],
          'vote_average': item['vote_average'],
          'media_type': item['media_type'],
          'indexno': i,
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _trendingFuture = _loadTrending();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 700;
    final isDesktop = screenWidth >= 1100;
    final horizontalPadding = isDesktop ? 20.0 : (isTablet ? 16.0 : 14.0);
    final titleSize = isDesktop ? 30.0 : (isTablet ? 27.0 : 24.0);
    final carouselHeight = isDesktop ? 320.0 : (isTablet ? 280.0 : 250.0);
    final viewportFraction = isDesktop ? 0.6 : (isTablet ? 0.72 : 0.82);
    final contentMaxWidth = isDesktop ? 1180.0 : 980.0;

    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isEnglish,
      builder: (context, english, _) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: const drawerfunc(),
            backgroundColor:
                isDark ? const Color(0xFF0B111B) : const Color(0xFFF3F6FC),
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Row(
                          children: [
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer(),
                                  icon: Icon(
                                    Icons.menu_rounded,
                                    color: isDark
                                        ? const Color(0xFFF7F8FA)
                                        : const Color(0xFF0E1320),
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: Text(
                                'CineVerse',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFFF7F8FA)
                                      : const Color(0xFF0E1320),
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0E4FE5),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFFFFC857), width: 1.3),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _langButton(
                                    label: 'ID',
                                    selected: !english,
                                    onTap: () => AppSettings.setLanguage(false),
                                  ),
                                  _langButton(
                                    label: 'EN',
                                    selected: english,
                                    onTap: () => AppSettings.setLanguage(true),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<void>(
                        future: _trendingFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return SizedBox(
                              height: carouselHeight,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0E4FE5),
                                ),
                              ),
                            );
                          }

                          if (_trending.isEmpty) {
                            return SizedBox(
                              height: carouselHeight,
                              child: Center(
                                child: Text(
                                  _txt('Data tren tidak tersedia',
                                      'Trending data unavailable', english),
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFE5EAF4)
                                        : const Color(0xFF334155),
                                  ),
                                ),
                              ),
                            );
                          }

                          return CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: viewportFraction,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              enlargeCenterPage: true,
                              height: carouselHeight,
                            ),
                            items: _trending.map((i) {
                              final posterUrl =
                                  UrlPack.imageUrl(i['poster_path'].toString());
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => descriptioncheckui(
                                        i['id'],
                                        i['media_type'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    image: DecorationImage(
                                      image: NetworkImage(posterUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0E4FE5)
                                            .withValues(alpha: 0.22),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.78),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#${i['indexno'] + 1} ${_txt('Populer', 'Trending', english)}',
                                          style: const TextStyle(
                                            color: Color(0xFF35B6FF),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (i['media_type']?.toString() ??
                                                      '-')
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Color(0xFFE5EAF4),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0D1624)
                                                    .withValues(alpha: 0.75),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.star_rounded,
                                                      color: Color(0xFFFFC857),
                                                      size: 14),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    '${i['vote_average'] ?? '-'}',
                                                    style: const TextStyle(
                                                      color: Color(0xFFF7F8FA),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 14 : 12),
                        child: const searchbarfun(),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: isTablet ? 14 : 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF141E2D) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF0E4FE5),
                            border: Border.all(
                              color: const Color(0xFFFFC857),
                              width: 1.6,
                            ),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 26 : (isTablet ? 20 : 12),
                          ),
                          dividerColor: Colors.transparent,
                          labelColor: const Color(0xFFFAFBFF),
                          unselectedLabelColor: isDark
                              ? const Color(0xFFCED5E2)
                              : const Color(0xFF64748B),
                          tabs: [
                            Tab(text: _txt('Serial TV', 'TV Series', english)),
                            Tab(text: _txt('Film', 'Movies', english)),
                            Tab(text: _txt('Segera', 'Soon', english)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            TvSeries(),
                            Movie(),
                            Upcomming(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 2),
                        child: Text(
                          copyrightLine(),
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF8EA0BE)
                                : const Color(0xFF54657F),
                            fontSize: isTablet ? 12.5 : 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _langButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFC857) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF0D1320) : const Color(0xFFF4F7FF),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
