import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/livre_bloc.dart';
import 'database/database_helper.dart';
import 'repositories/livre_repository.dart';
import 'screens/liste_livres_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation de la base de données locale
  final databaseHelper = DatabaseHelper();

  runApp(MainApp(databaseHelper: databaseHelper));
}

class MainApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MainApp({super.key, required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      // CORRECTION : Injection obligatoire du paramètre databaseHelper
      create: (context) => LivreRepository(databaseHelper: databaseHelper),
      child: BlocProvider(
        create: (context) => LivreBloc(
          livreRepository: RepositoryProvider.of<LivreRepository>(context),
        )..add(const ObtenirLivresEvent()), // Assurez-vous du nom de votre Event
        child: MaterialApp(
          title: 'Bibliothèque Moderne',
          debugShowCheckedModeBanner: false,
          
          // APPLICATION DE LA NOUVELLE CHARTE GRAPHIQUE UNIQUE
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212), // Fond principal
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9D4EDD),   // Violet Néon
              secondary: Color(0xFFBB86FC), // Accent clair
              surface: Color(0xFF1E1E1E),   // Cartes et conteneurs
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121212),
              elevation: 0,
              centerTitle: false, // Titre asymétrique à gauche (Style Épuré)
              titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          home: const ListeLivresScreen(),
        ),
      ),
    );
  }
}