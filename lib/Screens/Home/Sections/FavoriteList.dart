import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:imdbmoviesapps/Core/Database/NoteDbHelper.dart';
import 'package:imdbmoviesapps/Screens/Details/Checker.dart';
import 'package:imdbmoviesapps/Scripts/UrlPack.dart';

class FavoriateMovies extends StatefulWidget {
  const FavoriateMovies({super.key});

  @override
  State<FavoriateMovies> createState() => _FavoriateMoviesState();
}

class _FavoriateMoviesState extends State<FavoriateMovies> {
  int svalue = 1;
  final Map<String, Future<String?>> _posterFutures = {};

  Future<String?> _fetchPosterPath(String tmdbId, String tmdbType) {
    final key = '$tmdbType-$tmdbId';
    return _posterFutures.putIfAbsent(key, () async {
      final url = tmdbType == 'tv'
          ? UrlPack.tvDetails(tmdbId)
          : UrlPack.movieDetails(tmdbId);

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body);
      return json['poster_path']?.toString();
    });
  }

  Future<List<Map<String, dynamic>>> SortByChecker(int sortvalue) {
    if (sortvalue == 1) {
      return FavMovielist().queryAllSortedDate();
    } else if (sortvalue == 2) {
      return FavMovielist().queryAllSorted();
    } else if (sortvalue == 3) {
      return FavMovielist().queryAllSortedRating();
    }
    return FavMovielist().queryAllSortedDate();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 700;
    final isDesktop = screenWidth >= 1100;
    final contentMaxWidth =
        isDesktop ? 980.0 : (isTablet ? 860.0 : screenWidth);
    final posterSize = isDesktop ? 88.0 : (isTablet ? 80.0 : 70.0);
    final rowGap = isTablet ? 12.0 : 10.0;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0B111B) : const Color(0xFFF3F6FC),
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF0B111B) : const Color(0xFFF3F6FC),
        title: Text(
          'Daftar Favorit',
          style: TextStyle(
            color: isDark ? const Color(0xFFF7F8FA) : const Color(0xFF0E1320),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF141E2D) : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton(
                value: svalue,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                dropdownColor:
                    isDark ? const Color(0xFF141E2D) : const Color(0xFFFFFFFF),
                iconEnabledColor: const Color(0xFF35B6FF),
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFE5EAF4)
                      : const Color(0xFF0E1320),
                ),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Urutkan: Terbaru')),
                  DropdownMenuItem(value: 2, child: Text('Urutkan: Nama')),
                  DropdownMenuItem(value: 3, child: Text('Urutkan: Rating')),
                ],
                onChanged: (value) {
                  setState(() {
                    svalue = value as int;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: SortByChecker(svalue),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6A3D)),
                  );
                }

                final items = snapshot.data!;
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada favorit',
                      style: TextStyle(color: Color(0xFFE5EAF4)),
                    ),
                  );
                }

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Dismissible(
                          key: ValueKey(item['id']),
                          background: Container(
                            margin: EdgeInsets.only(bottom: rowGap),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD14A4A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 18),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            FavMovielist().delete(item['id']);
                            Fluttertoast.showToast(
                              msg: 'Dihapus dari Favorit',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: isDark
                                  ? const Color(0xFF141E2D)
                                  : const Color(0xFFFFFFFF),
                              textColor: isDark
                                  ? const Color(0xFFF7F8FA)
                                  : const Color(0xFF0E1320),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: rowGap),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => descriptioncheckui(
                                      item['tmdbid'].toString(),
                                      item['tmdbtype'].toString(),
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF141E2D)
                                      : const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF35B6FF)
                                        .withOpacity(0.12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FutureBuilder<String?>(
                                        future: _fetchPosterPath(
                                          item['tmdbid'].toString(),
                                          item['tmdbtype'].toString(),
                                        ),
                                        builder: (context, snapshot) {
                                          final path = snapshot.data;
                                          if (path == null || path.isEmpty) {
                                            return Container(
                                              width: posterSize,
                                              height: posterSize,
                                              color: const Color(0xFF0F1724),
                                              child: const Icon(
                                                Icons
                                                    .image_not_supported_rounded,
                                                color: Color(0xFF8FA2BE),
                                              ),
                                            );
                                          }

                                          return Image.network(
                                            UrlPack.imageUrl(path),
                                            width: posterSize,
                                            height: posterSize,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: rowGap),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['tmdbname'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDark
                                                  ? const Color(0xFFF7F8FA)
                                                  : const Color(0xFF0E1320),
                                              fontWeight: FontWeight.w600,
                                              fontSize: isTablet ? 15 : 14,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              const Icon(Icons.star_rounded,
                                                  color: Color(0xFFFFC857),
                                                  size: 14),
                                              const SizedBox(width: 4),
                                              Text(
                                                item['tmdbrating'],
                                                style: TextStyle(
                                                  color: isDark
                                                      ? const Color(0xFFBFC7D7)
                                                      : const Color(0xFF475569),
                                                  fontSize: isTablet ? 13 : 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0F1724),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        item['tmdbtype']
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: const Color(0xFF35B6FF),
                                          fontSize: isTablet ? 12 : 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
