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
          scaffoldBackgroundColor: const Color(0xFFF8F5F2),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E1E2E),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF8F5F2),
            foregroundColor: Color(0xFF1E1E2E),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF1E1E2E),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFF6B17A),
            foregroundColor: Color(0xFF1E1E2E),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}