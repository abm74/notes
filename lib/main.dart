import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/bloc/notes_bloc_bloc.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/pages/home_page.dart';
import 'package:notes/repository/notes_repository.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider(
        create: (context) => NotesRepository(),
        child: BlocProvider(
          create: (context) =>
              NotesBloc(notesRepository: context.read<NotesRepository>())
                ..add(LoadNotes()),
          child: const HomePage(),
        ),
      ),
    );
  }
}
