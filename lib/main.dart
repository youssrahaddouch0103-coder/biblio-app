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

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LivreBloc(repository)..add(LoadLivres()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BiblioApp',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const ListeLivresScreen(),
      ),
    );
  }
}