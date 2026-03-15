import 'package:flutter/material.dart';
import 'package:imdbmoviesapps/Core/App/AppBreakpoints.dart';
import 'package:imdbmoviesapps/Widgets/RepeatedText.dart';

class ReviewUI extends StatefulWidget {
  List revdeatils = [];
  ReviewUI({super.key, required this.revdeatils});

  @override
  State<ReviewUI> createState() => _ReviewUIState();
}

class _ReviewUIState extends State<ReviewUI> {
  bool showall = false;

  @override
  Widget build(BuildContext context) {
    List REviewDetails = widget.revdeatils;
    if (REviewDetails.isEmpty) {
      return const SizedBox.shrink();
    }

    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final sectionTitleSize = isDesktop ? 24.0 : (isTablet ? 22.0 : 20.0);
    final cardPadding = isDesktop ? 16.0 : 14.0;
    final avatarRadius = isDesktop ? 24.0 : (isTablet ? 23.0 : 22.0);
    final nameSize = isDesktop ? 15.0 : 14.0;
    final dateSize = isDesktop ? 12.0 : 11.0;
    final ratingSize = isDesktop ? 13.0 : 12.0;
    final toggleLabelSize = isDesktop ? 14.0 : 13.0;

    final visibleItems = showall ? REviewDetails : [REviewDetails.first];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ulasan Pengguna',
                style: TextStyle(
                  color: Color(0xFFF7F8FA),
                  fontSize: sectionTitleSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  showall = !showall;
                });
              },
              icon: Icon(
                showall
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF35B6FF),
              ),
              label: Text(
                showall ? 'Tampilkan Sedikit' : 'Semua Ulasan',
                style: TextStyle(
                  color: const Color(0xFF35B6FF),
                  fontSize: toggleLabelSize,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: visibleItems.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = visibleItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: const Color(0xFF141E2D),
                borderRadius: BorderRadius.circular(14),
                border:
                    Border.all(color: const Color(0xFF35B6FF).withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: avatarRadius,
                        backgroundImage: NetworkImage(item['avatarphoto']),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFFF7F8FA),
                                fontSize: nameSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              item['creationdate'],
                              style: TextStyle(
                                color: Color(0xFFA7B0C0),
                                fontSize: dateSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F1724),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFFFC857), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              item['rating'],
                              style: TextStyle(
                                color: Color(0xFFF7F8FA),
                                fontSize: ratingSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  overviewtext(item['review']),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
