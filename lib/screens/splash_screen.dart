import 'dart:async';

import 'package:flutter/material.dart';

import 'liste_livres_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  static const Color primaryColor =
      Color(0xFF1E1E2E);

  static const Color secondaryColor =
      Color(0xFF2D3250);

  static const Color accentColor =
      Color(0xFFF6B17A);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1400),
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
          builder: (_) =>
              const ListeLivresScreen(),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: FadeTransition(
          opacity: _fadeAnimation,

          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              ScaleTransition(
                scale: _scaleAnimation,

                child: Container(
                  width: 125,
                  height: 125,

                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: 0.08),

                    borderRadius:
                        BorderRadius.circular(36),

                    border: Border.all(
                      color: Colors.white
                          .withValues(alpha: 0.10),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.22),

                        blurRadius: 30,
                        offset:
                            const Offset(0, 16),
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: accentColor,
                    size: 66,
                  ),
                ),
              ),

              const SizedBox(height: 34),

              const Text(
                'BiblioApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Votre espace de lecture moderne',
                style: TextStyle(
                  color:
                      Colors.white.withValues(
                    alpha: 0.72,
                  ),
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 52),

              const SizedBox(
                width: 36,
                height: 36,

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