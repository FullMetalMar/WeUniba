import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'home_page_weuniba.dart';

class WeUnibaTransitionScreen extends StatefulWidget {
  const WeUnibaTransitionScreen({super.key});

  @override
  State<WeUnibaTransitionScreen> createState() =>
      _WeUnibaTransitionScreenState();
}

class _WeUnibaTransitionScreenState extends State<WeUnibaTransitionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Riproduci suono "woosh"
    _audioPlayer.play(AssetSource('audio/woosh.mp3'));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 900), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePageWeUniba(username: "esempio"),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Hero(
            tag: 'weuniba-logo',
            child: Image.asset(
              'assets/logo/weuniba_logo.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
