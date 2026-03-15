import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Screens/Details/Checker.dart';
import 'package:imdbmoviesapps/Scripts/UrlPack.dart';

class searchbarfun extends StatefulWidget {
  const searchbarfun({super.key});

  @override
  State<searchbarfun> createState() => _searchbarfunState();
}

class _searchbarfunState extends State<searchbarfun> {
  final TextEditingController _searchController = TextEditingController();

  void _submitSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      final english = AppSettings.isEnglish.value;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      Fluttertoast.showToast(
        msg: english
            ? 'Please enter a search keyword'
            : 'Masukkan kata kunci pencarian',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor:
            isDark ? const Color(0xFF141E2D) : const Color(0xFFFFFFFF),
        textColor: isDark ? const Color(0xFFF7F8FA) : const Color(0xFF0E1320),
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isEnglish,
      builder: (context, english, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final fieldBg =
            isDark ? const Color(0xFF141E2D) : const Color(0xFFFFFFFF);
        final hintColor = isDark
            ? Colors.white.withValues(alpha: 0.36)
            : const Color(0xFF64748B);
        final textColor =
            isDark ? const Color(0xFFF7F8FA) : const Color(0xFF0E1320);

        return Padding(
          padding: const EdgeInsets.only(left: 2, top: 8, bottom: 8, right: 2),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: fieldBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF35B6FF).withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
              border: Border.all(
                color: const Color(0xFF35B6FF).withValues(alpha: 0.2),
              ),
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _submitSearch(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFF35B6FF)),
                hintText: english
                    ? 'Search movies or series'
                    : 'Cari film atau serial',
                hintStyle: TextStyle(color: hintColor),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: _submitSearch,
                  icon: const Icon(Icons.arrow_forward_rounded,
                      color: Color(0xFF35B6FF)),
                ),
              ),
              style: TextStyle(color: textColor),
            ),
          ),
        );
      },
    );
  }
}

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.query});

  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late Future<List<Map<String, dynamic>>> _resultsFuture;

  String _mediaTypeLabel(String mediaType, bool english) {
    switch (mediaType.toLowerCase()) {
      case 'movie':
        return english ? 'MOVIE' : 'FILM';
      case 'tv':
        return english ? 'TV SERIES' : 'SERIAL TV';
      default:
        return mediaType.toUpperCase();
    }
  }

  Future<List<Map<String, dynamic>>> _search() async {
    final response =
        await http.get(Uri.parse(UrlPack.multiSearch(widget.query)));
    if (response.statusCode != 200) {
      return [];
    }

    final tempData = jsonDecode(response.body);
    final searchJson = tempData['results'] as List<dynamic>;

    final results = <Map<String, dynamic>>[];
    for (final item in searchJson) {
      if (item['id'] != null &&
          item['poster_path'] != null &&
          item['vote_average'] != null &&
          item['media_type'] != null) {
        results.add({
          'id': item['id'],
          'poster_path': item['poster_path'],
          'vote_average': item['vote_average'],
          'media_type': item['media_type'],
          'display_title': (item['title'] ??
                  item['name'] ??
                  item['original_title'] ??
                  item['original_name'] ??
                  '-')
              .toString(),
          'popularity': item['popularity'] ?? 0,
          'overview': item['overview'] ?? '-',
        });
      }
      if (results.length == 20) break;
    }

    return results;
  }

  @override
  void initState() {
    super.initState();
    _resultsFuture = _search();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isEnglish,
      builder: (context, english, _) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final isTablet = screenWidth >= 700;
        final isDesktop = screenWidth >= 1100;
        final listMaxWidth =
            isDesktop ? 980.0 : (isTablet ? 860.0 : screenWidth);
        final cardHeight = isDesktop ? 154.0 : (isTablet ? 142.0 : 130.0);
        final posterWidth = isDesktop ? 132.0 : (isTablet ? 122.0 : 115.0);
        final titleSize = isDesktop ? 13.0 : 12.0;
        final bodySize = isDesktop ? 13.0 : 12.0;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final pageBg =
            isDark ? const Color(0xFF0B111B) : const Color(0xFFF3F6FC);
        final surfaceBg =
            isDark ? const Color(0xFF141E2D) : const Color(0xFFFFFFFF);
        final primaryText =
            isDark ? const Color(0xFFF7F8FA) : const Color(0xFF0E1320);
        final secondaryText =
            isDark ? const Color(0xFFBFC7D7) : const Color(0xFF475569);

        return Scaffold(
          backgroundColor: pageBg,
          appBar: AppBar(
            backgroundColor: pageBg,
            title: Text(
              english
                  ? 'Search Results: ${widget.query}'
                  : 'Hasil Pencarian: ${widget.query}',
              style: TextStyle(color: primaryText),
            ),
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: _resultsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0E4FE5)),
                );
              }

              final data = snapshot.data ?? [];
              if (data.isEmpty) {
                return Center(
                  child: Text(
                    english ? 'No results found' : 'Tidak ada hasil ditemukan',
                    style: TextStyle(color: secondaryText),
                  ),
                );
              }

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: listMaxWidth),
                  child: ListView.builder(
                    itemCount: data.length,
                    padding: const EdgeInsets.all(12),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => descriptioncheckui(
                                item['id'],
                                item['media_type'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: cardHeight,
                          decoration: BoxDecoration(
                            color: surfaceBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF35B6FF)
                                  .withValues(alpha: 0.18),
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(14),
                                ),
                                child: Image.network(
                                  UrlPack.imageUrl(
                                      item['poster_path'].toString()),
                                  width: posterWidth,
                                  height: cardHeight,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['display_title'].toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: primaryText,
                                          fontWeight: FontWeight.w700,
                                          fontSize: isDesktop ? 15 : 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _mediaTypeLabel(
                                          item['media_type'].toString(),
                                          english,
                                        ),
                                        style: TextStyle(
                                          color: const Color(0xFF35B6FF),
                                          fontWeight: FontWeight.w700,
                                          fontSize: titleSize,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded,
                                              color: Color(0xFFFFC857),
                                              size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item['vote_average']}',
                                            style: TextStyle(
                                              color: primaryText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(Icons.people_alt_rounded,
                                              color: Color(0xFF35B6FF),
                                              size: 14),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${item['popularity']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: secondaryText,
                                                fontSize: bodySize,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Text(
                                          item['overview'].toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: secondaryText,
                                            fontSize: bodySize,
                                            height: 1.25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
