import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imdbmoviesapps/Core/App/AppBreakpoints.dart';
import 'package:imdbmoviesapps/Core/App/AppSettings.dart';
import 'package:imdbmoviesapps/Screens/Home/Sections/FavoriteList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class drawerfunc extends StatefulWidget {
  const drawerfunc({super.key});

  @override
  State<drawerfunc> createState() => _drawerfuncState();
}

class _drawerfuncState extends State<drawerfunc> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final sp = await SharedPreferences.getInstance();
    final path = sp.getString('imagepath');
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        setState(() {
          _image = file;
        });
      }
    }
  }

  String _txt(String id, String en, bool english) => english ? en : id;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final horizontalPadding = isDesktop ? 18.0 : (isTablet ? 16.0 : 14.0);
    final profileRadius = isDesktop ? 34.0 : (isTablet ? 31.0 : 28.0);
    final nameSize = isDesktop ? 18.0 : (isTablet ? 17.0 : 16.0);
    final subtitleSize = isDesktop ? 13.0 : 12.0;
    final socialButtonSize = isDesktop ? 46.0 : (isTablet ? 44.0 : 40.0);
    final socialIconSize = isDesktop ? 20.0 : 18.0;

    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.isEnglish,
      builder: (context, english, _) {
        return Drawer(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [Color(0xFF111B2B), Color(0xFF0B111B)]
                    : const [Color(0xFFF8FBFF), Color(0xFFEFF4FC)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: 12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF172338)
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              const Color(0xFF35B6FF).withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: profileRadius,
                            backgroundColor: const Color(0xFF27344A),
                            backgroundImage: _image == null
                                ? const AssetImage('assets/icons/logo.png')
                                    as ImageProvider
                                : FileImage(_image!),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _txt('Selamat datang', 'Welcome back',
                                      english),
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFE5EAF4)
                                        : const Color(0xFF475569),
                                    fontSize: subtitleSize,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _txt('Pengguna Baru', 'New User', english),
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFFF7F8FA)
                                        : const Color(0xFF0E1320),
                                    fontSize: nameSize,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          _DrawerTile(
                            icon: const Icon(Icons.favorite_rounded),
                            title: _txt('Favorit', 'Favorites', english),
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FavoriateMovies(),
                                ),
                              );
                            },
                          ),
                          _DrawerTile(
                            icon: const FaIcon(FontAwesomeIcons.blogger),
                            title: _txt('Blog', 'Blog', english),
                            isDark: isDark,
                            onTap: () => _openWebView(
                              context,
                              title: _txt('Blog', 'Blog', english),
                              url: 'https://alvinzanuaputra.blogspot.com',
                            ),
                          ),
                          _DrawerTile(
                            icon: const Icon(Icons.language_rounded),
                            title: _txt('Situs Web', 'Website', english),
                            isDark: isDark,
                            onTap: () => _openWebView(
                              context,
                              title: _txt('Situs Web', 'Website', english),
                              url: 'https://alvinzanuaputra.vercel.app',
                            ),
                          ),
                          _DrawerTile(
                            icon: const Icon(Icons.info_outline_rounded),
                            title:
                                _txt('Tentang Aplikasi', 'About App', english),
                            isDark: isDark,
                            onTap: () => _showAbout(context, english),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF172338)
                            : const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF35B6FF).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _socialButton(
                                icon: const FaIcon(FontAwesomeIcons.github),
                                size: socialButtonSize,
                                iconSize: socialIconSize,
                                onTap: () => _openWebView(
                                  context,
                                  title: 'GitHub',
                                  url: 'https://github.com/alvinzanuaputra',
                                ),
                              ),
                              _socialButton(
                                icon: const FaIcon(FontAwesomeIcons.linkedin),
                                size: socialButtonSize,
                                iconSize: socialIconSize,
                                onTap: () => _openWebView(
                                  context,
                                  title: 'LinkedIn',
                                  url:
                                      'https://www.linkedin.com/in/alvinzanuaputra',
                                ),
                              ),
                              _socialButton(
                                icon: const FaIcon(FontAwesomeIcons.instagram),
                                size: socialButtonSize,
                                iconSize: socialIconSize,
                                onTap: () => _openWebView(
                                  context,
                                  title: 'Instagram',
                                  url: 'https://instagram.com/alvinzanuaputra',
                                ),
                              ),
                              _socialButton(
                                icon: const FaIcon(FontAwesomeIcons.xTwitter),
                                size: socialButtonSize,
                                iconSize: socialIconSize,
                                onTap: () => _openWebView(
                                  context,
                                  title: 'X',
                                  url: 'https://www.x.com/AlvinZanua',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => SystemNavigator.pop(),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFD14A4A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.exit_to_app_rounded),
                              label: Text(_txt('Keluar dari Aplikasi',
                                  'Exit Application', english)),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _socialButton({
    required Widget icon,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF0E4FE5),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: size,
          height: size,
          child: IconTheme(
            data: IconThemeData(color: Colors.white, size: iconSize),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context, bool english) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF141E2D) : const Color(0xFFFFFFFF),
          title: Text(
            _txt('Tentang', 'About', english),
            style: TextStyle(
              color: isDark ? const Color(0xFFF7F8FA) : const Color(0xFF0E1320),
            ),
          ),
          content: Text(
            _txt(
              'Aplikasi ini dibuat oleh Alvin Zanua Putra untuk eksplorasi film dan serial menggunakan TMDB API.',
              'This app was built by Alvin Zanua Putra to explore movies and TV series using TMDB API.',
              english,
            ),
            style: TextStyle(
              color: isDark ? const Color(0xFFE5EAF4) : const Color(0xFF475569),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_txt('Tutup', 'Close', english)),
            ),
          ],
        );
      },
    );
  }

  void _openWebView(BuildContext context,
      {required String title, required String url}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0B111B) : const Color(0xFFF3F6FC),
          appBar: AppBar(
            title: Text(title),
            backgroundColor:
                isDark ? const Color(0xFF0B111B) : const Color(0xFFF3F6FC),
          ),
          body: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(Uri.parse(url)),
          ),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDark,
    this.trailing,
  });

  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool isDark;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isTablet = AppBreakpoints.isTablet(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final iconBoxSize = isDesktop ? 38.0 : (isTablet ? 36.0 : 34.0);
    final iconSize = isDesktop ? 20.0 : 18.0;
    final titleSize = isDesktop ? 15.0 : (isTablet ? 14.5 : 14.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: isDark ? const Color(0xFF172338) : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E4FE5).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                        color: const Color(0xFF0E4FE5), size: iconSize),
                    child: Center(child: icon),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFE5EAF4)
                          : const Color(0xFF0E1320),
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
