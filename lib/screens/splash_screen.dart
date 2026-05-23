import 'dart:async';

import 'package:flutter/material.dart';

import 'liste_livres_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  static const Color primaryColor = Color(0xFF25316D);
  static const Color accentColor = Color(0xFFFFB84C);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const ListeLivresScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor,
              Color(0xFF3949AB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 115,
                  height: 115,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.local_library_rounded,
                    color: primaryColor,
                    size: 62,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'BiblioApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Votre bibliothèque personnelle',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 42),
              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}