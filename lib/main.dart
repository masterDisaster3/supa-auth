import 'package:auth/pages/home_page.dart';
import 'package:auth/pages/notes_page.dart';
import 'package:auth/utilities/supagreen.dart';
import 'package:flutter/material.dart';

import 'Services/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Services(
      child: MaterialApp(
          title: 'SupaAuth',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: supaGreenMaterialColor,
          ),
          home: Builder(builder: (context) {
            return FutureBuilder<bool>(
                builder: (context, snapshot) {
                  final sessionRecovered = snapshot.data ?? false;
                  return sessionRecovered ? const Notespage() : const HomePage();
                },
                future: Services.of(context).authService.recoverSession());
          })),
    );
  }
}




//TODO implement email confirmation
