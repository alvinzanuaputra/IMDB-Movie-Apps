import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imdbmoviesapps/Core/Database/NoteDbHelper.dart';
import 'package:imdbmoviesapps/Widgets/RepeatedText.dart';
import 'package:url_launcher/url_launcher.dart';

class addtofavoriate extends StatefulWidget {
  var id, type, Details;
  addtofavoriate({
    super.key,
    this.id,
    this.type,
    this.Details,
  });

  @override
  State<addtofavoriate> createState() => _addtofavoriateState();
}

class _addtofavoriateState extends State<addtofavoriate> {
  bool _isFavorite = false;
  late Future<void> _favoriteFuture;

  String get _title => widget.Details[0]['title'].toString();
  String get _rating => widget.Details[0]['vote_average'].toString();
  String get _tmdbUrl =>
      'https://www.themoviedb.org/${widget.type}/${widget.id}';

  Future<void> _loadFavoriteStatus() async {
    final value = await FavMovielist().search(
      widget.id.toString(),
      _title,
      widget.type,
    );
    _isFavorite = value != 0;
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavMovielist().deletespecific(widget.id.toString(), widget.type);
      setState(() {
        _isFavorite = false;
      });
      Fluttertoast.showToast(
        msg: 'Dihapus dari Favorit',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFD14A4A),
        textColor: Colors.white,
      );
      return;
    }

    await FavMovielist().insert({
      'tmdbid': widget.id.toString(),
      'tmdbtype': widget.type,
      'tmdbname': _title,
      'tmdbrating': _rating,
    });
    setState(() {
      _isFavorite = true;
    });
    Fluttertoast.showToast(
      msg: 'Ditambahkan ke Favorit',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF1F9D67),
      textColor: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();
    _favoriteFuture = _loadFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _favoriteFuture,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _toggleFavorite,
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isFavorite
                          ? const Color(0xFFFF6A3D).withOpacity(0.2)
                          : const Color(0xFF172338),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _isFavorite
                            ? const Color(0xFFFF6A3D)
                            : const Color(0xFF35B6FF).withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: _isFavorite
                              ? const Color(0xFFFF6A3D)
                              : const Color(0xFFE5EAF4),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isFavorite ? 'Tersimpan' : 'Tambah Favorit',
                          style: const TextStyle(
                            color: Color(0xFFF7F8FA),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _showShareSheet(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF172338),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF35B6FF).withOpacity(0.25),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share_rounded,
                            color: Color(0xFF35B6FF), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Bagikan',
                          style: TextStyle(
                            color: Color(0xFFF7F8FA),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showShareSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF141E2D),
          title: const Text(
            'Bagikan',
            style: TextStyle(color: Color(0xFFF7F8FA)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _shareIcon(
                    color: const Color(0xFF1877F2),
                    icon: Icons.facebook_rounded,
                    onTap: () => launchUrl(Uri.parse(
                        'https://www.facebook.com/sharer/sharer.php?u=$_tmdbUrl')),
                  ),
                  _shareIcon(
                    color: const Color(0xFF25D366),
                    icon: Icons.chat_rounded,
                    onTap: () => launchUrl(Uri.parse(
                        'https://wa.me/?text=Check%20out%20this%20link:%20$_tmdbUrl')),
                  ),
                  _shareIcon(
                    color: const Color(0xFF0A66C2),
                    icon: Icons.business_center_rounded,
                    onTap: () => launchUrl(Uri.parse(
                        'https://www.linkedin.com/shareArticle?mini=true&url=$_tmdbUrl')),
                  ),
                  _shareIcon(
                    color: const Color(0xFF1DA1F2),
                    icon: Icons.alternate_email_rounded,
                    onTap: () => launchUrl(Uri.parse(
                        'https://twitter.com/intent/tweet?text=Check%20out%20this%20link:%20$_tmdbUrl')),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: _tmdbUrl));
                  if (!mounted) return;
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Link berhasil disalin',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  );
                },
                icon: const Icon(Icons.copy_rounded),
                label: normaltext('Salin Tautan'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shareIcon({
    required Color color,
    required IconData icon,
    required Future<void> Function() onTap,
  }) {
    return InkWell(
      onTap: () async {
        await onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
