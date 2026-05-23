import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/livre_bloc.dart';
import 'bloc/livre_event.dart';
import 'database/database_helper.dart';
import 'repositories/livre_repository.dart';
import 'screens/splash_screen.dart';

void main() {
  final repository = LivreRepository(
    databaseHelper: DatabaseHelper.instance,
  );

  runApp(
    MyApp(repository: repository),
  );
}

class MyApp extends StatelessWidget {
  final LivreRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          LivreBloc(repository)..add(LoadLivres()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BiblioApp',

        theme: ThemeData(
          useMaterial3: true,

          scaffoldBackgroundColor:
              const Color(0xFFF8F5F2),

          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E1E2E),
            brightness: Brightness.light,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor:
                Color(0xFFF8F5F2),
            foregroundColor:
                Color(0xFF1E1E2E),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF1E1E2E),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(24),
            ),
          ),

          inputDecorationTheme:
              InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),

            enabledBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),

            focusedBorder:
                OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: Color(0xFFF6B17A),
                width: 1.5,
              ),
            ),
          ),

          elevatedButtonTheme:
              ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFF6B17A),

              foregroundColor:
                  const Color(0xFF1E1E2E),

              elevation: 0,

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),

              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(
            backgroundColor:
                Color(0xFFF6B17A),

            foregroundColor:
                Color(0xFF1E1E2E),
          ),

          chipTheme: ChipThemeData(
            backgroundColor: Colors.white,

            selectedColor:
                const Color(0xFFF6B17A),

            labelStyle: const TextStyle(
              color: Color(0xFF1E1E2E),
              fontWeight: FontWeight.w600,
            ),

            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(50),
            ),
          ),

          textTheme: const TextTheme(
            headlineMedium: TextStyle(
              color: Color(0xFF1E1E2E),
              fontWeight: FontWeight.bold,
            ),

            bodyMedium: TextStyle(
              color: Color(0xFF444444),
              fontSize: 15,
            ),
          ),
        ),

        home: const SplashScreen(),
      ),
    );
  }
}