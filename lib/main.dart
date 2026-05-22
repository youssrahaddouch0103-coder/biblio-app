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
    return BlocProvider(
      create: (_) => LivreBloc(repository)..add(LoadLivres()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BiblioApp',

        theme: ThemeData(
          useMaterial3: true,

          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.light,
          ),

          scaffoldBackgroundColor: Colors.grey[100],

          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),

          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),

          cardTheme: CardThemeData(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              borderSide: BorderSide(
                color: Colors.indigo,
                width: 2,
              ),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        home: const ListeLivresScreen(),
      ),
    );
  }
}