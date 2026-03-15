import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class trailerwatch extends StatefulWidget {
  var trailerytid;
  trailerwatch({super.key, this.trailerytid});

  @override
  State<trailerwatch> createState() => _trailerwatchState();
}

class _trailerwatchState extends State<trailerwatch> {
  late YoutubePlayerController _controller;
  String _videoId = '';
  bool _isMuted = true;

  String _resolveVideoId(String? source) {
    if (source == null || source.trim().isEmpty) {
      return 'aJ0cZTcTh90';
    }
    final raw = source.trim();
    final converted = YoutubePlayer.convertUrlToId(raw);
    if (converted != null && converted.isNotEmpty) {
      return converted;
    }
    // TMDB video endpoint returns a key, not a full YouTube URL.
    return raw;
  }

  @override
  void initState() {
    super.initState();
    _videoId = _resolveVideoId(widget.trailerytid?.toString());
    _controller = YoutubePlayerController(
      initialVideoId: _videoId,
      flags: const YoutubePlayerFlags(
        enableCaption: false,
        autoPlay: true,
        mute: true,
        controlsVisibleAtStart: true,
        forceHD: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      thumbnail: Image.network(
        'https://img.youtube.com/vi/$_videoId/hqdefault.jpg',
        fit: BoxFit.cover,
      ),
      controlsTimeOut: const Duration(milliseconds: 1800),
      aspectRatio: 16 / 9,
      controller: _controller,
      showVideoProgressIndicator: true,
      bufferIndicator: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
      progressIndicatorColor: Colors.blue,
      bottomActions: [
        const CurrentPosition(),
        const SizedBox(width: 8),
        const ProgressBar(
          isExpanded: true,
          colors: ProgressBarColors(
            playedColor: Colors.white,
            handleColor: Colors.blue,
          ),
        ),
        const RemainingDuration(),
        _actionButton(
          icon: _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          onTap: () {
            setState(() {
              _isMuted = !_isMuted;
            });
            if (_isMuted) {
              _controller.mute();
            } else {
              _controller.unMute();
            }
          },
        ),
        const FullScreenButton(),
      ],
    );
  }

  Widget _actionButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
