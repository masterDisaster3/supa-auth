import 'package:auth/pages/home_page.dart';
import 'package:auth/utilities/snacks.dart';
import 'package:flutter/material.dart';

import '../Services/services.dart';

class Notespage extends StatefulWidget {
  const Notespage({Key? key}) : super(key: key);

  @override
  State<Notespage> createState() => _NotespageState();
}

class _NotespageState extends State<Notespage> {
  Future<void> _signOut(BuildContext context) async {
    final success = await Services.of(context).authService.signout();
    if (success) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(snacks("Signing Out.."));

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await _signOut(context);
              },
              child: const Text("Sign Out for now"))
        ],
      )),
    );
  }
}
