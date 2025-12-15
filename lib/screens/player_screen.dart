import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PlayerScreen extends StatefulWidget {
  final List<int> movementSequence;
  const PlayerScreen({super.key, required this.movementSequence});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    setState(() => _isLoading = true);
    
    // In a real app, look up the URL from the ID.
    // Here we construct the mocked URL based on the README.
    // For demo purposes (making it work), we use a placeholder if needed.
    // final movementId = widget.movementSequence[_currentIndex];
    // final url = 'https://stream.gringo-qigong.app/movement-$movementId.m3u8';
    
    // DEMO VIDEO URL (to ensure it plays)
    const url = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'; 

    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));

    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoController.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            'Video Error: $errorMessage',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );

    setState(() => _isLoading = false);
    
    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        _onVideoFinished();
      }
    });
  }

  void _onVideoFinished() {
    if (_currentIndex < widget.movementSequence.length - 1) {
      // Go to next video
      _videoController.dispose();
      _chewieController?.dispose();
      setState(() {
        _currentIndex++;
      });
      _initializePlayer();
    } else {
      // Session Complete
      Navigator.of(context).pop(); // Or go to Feedback screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session Complete! Good job.')),
      );
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Movement ${widget.movementSequence[_currentIndex]}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Chewie(controller: _chewieController!),
      ),
    );
  }
}
