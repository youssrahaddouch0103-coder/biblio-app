import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/livre_bloc.dart';
import 'bloc/livre_event.dart';
import 'database/database_helper.dart';
import 'repositories/livre_repository.dart';
import 'screens/liste_livres_screen.dart';

void main() {
  final repository = LivreRepository(
    databaseHelper: DatabaseHelper.instance,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final LivreRepository repository;

  const MyApp({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF25316D);
    const secondaryColor = Color(0xFFFFB84C);
    const backgroundColor = Color(0xFFF7F3EA);

    return BlocProvider(
      create: (_) => LivreBloc(repository)..add(LoadLivres()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BiblioApp',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColor,
            primary: primaryColor,
            secondary: secondaryColor,
            surface: Colors.white,
          ),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: backgroundColor,
            foregroundColor: primaryColor,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: primaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
        home: const ListeLivresScreen(),
      ),
    );
  }
}