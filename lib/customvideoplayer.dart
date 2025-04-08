import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:async';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late AnimationController _glowController;
  bool _isVideoPlaying = false;
  double _currentVideoPosition = 0;
  double _videoDuration = 0;
  Timer? _positionTimer;
  final int _skipDuration = 10;

  @override
  void initState() {
    super.initState();

    // Initialize glowing animation controller
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    final videoId = YoutubePlayerController.convertUrlToId(widget.url);

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: true,
        enableJavaScript: true,
        playsInline: true,
      ),
    );

    _controller.listen((event) {
      if (event.playerState == PlayerState.playing) {
        setState(() => _isVideoPlaying = true);
        _startPositionTimer();
      } else if (event.playerState == PlayerState.paused) {
        setState(() => _isVideoPlaying = false);
      }
    });

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final duration = await _controller.duration;
    setState(() {
      _videoDuration = duration.toDouble();
    });
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (mounted) {
        final position = await _controller.currentTime;
        setState(() => _currentVideoPosition = position.toDouble());
      }
    });
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.round());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _toggleVideoPlayback() async {
    if (_isVideoPlaying) {
      await _controller.pauseVideo();
      _positionTimer?.cancel();
    } else {
      await _controller.playVideo();
      _startPositionTimer();
    }
    setState(() => _isVideoPlaying = !_isVideoPlaying);
  }

  Future<void> _skipForward() async {
    final current = await _controller.currentTime;
    final duration = await _controller.duration;
    final newTime = (current + _skipDuration).clamp(0, duration).toDouble();
    await _controller.seekTo(seconds: newTime);
  }

  Future<void> _skipBackward() async {
    final current = await _controller.currentTime;
    final newTime = (current - _skipDuration).clamp(0, _videoDuration).toDouble();
    await _controller.seekTo(seconds: newTime);
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _glowController.dispose();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.green.shade700,
          title: const Text('Yoga Video'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _controller.pauseVideo();
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(_glowController.value),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: YoutubePlayer(controller: _controller),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_formatDuration(_currentVideoPosition)),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.green,
                        inactiveColor: Colors.green.shade100,
                        value: _currentVideoPosition.clamp(0.0, _videoDuration),
                        min: 0.0,
                        max: _videoDuration,
                        onChanged: (value) async {
                          setState(() {
                            _currentVideoPosition = value;
                          });
                          await _controller.seekTo(seconds: value.toDouble());
                        },
                      ),
                    ),
                    Text(_formatDuration(_videoDuration)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _iconButton(Icons.replay_10, _skipBackward),
                    const SizedBox(width: 10),
                    _iconButton(_isVideoPlaying ? Icons.pause : Icons.play_arrow, _toggleVideoPlayback, size: 48),
                    const SizedBox(width: 10),
                    _iconButton(Icons.forward_10, _skipForward),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onPressed, {double size = 36}) {
    return IconButton(
      icon: Icon(icon, color: Colors.green.shade800),
      onPressed: onPressed,
      iconSize: size,
      tooltip: icon == Icons.pause ? "Pause" : icon == Icons.play_arrow ? "Play" : null,
    );
  }
}
