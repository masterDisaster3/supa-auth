
import 'package:auth/utilities/supagreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../Services/services.dart';
import '../utilities/snacks.dart';
import 'notes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool _isSigningUp = false;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _rePassController = TextEditingController();
  
  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final success = await Services.of(context)
          .authService
          .signIn(_emailController.text, _passController.text);

      if (success) {
        setState(() {
          _isLoading = false;
          _emailController.clear();
          _passController.clear();
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(snacks("Login Successful!!"));

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((_) => const Notespage())));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snacks("Error logging In!"));
      }
    }
    setState(() {
      _emailController.clear();
      _passController.clear();
      _isSigningUp = false;
    });
  }

  void _signUp() async {
    setState(() {
      _isSigningUp = true;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final success = await Services.of(context)
          .authService
          .signUp(_emailController.text, _rePassController.text);

      if (success) {
        setState(() {
           _isLoading = false;
          _emailController.clear();
          _passController.clear();
          _rePassController.clear();
          _isSigningUp = false;
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(snacks("Sign Up successful! Now Login!"));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snacks("Sign Up Failed!"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: supaGreenMaterialColor,
          title: const Text("SupaAuth")),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 100,
            ),
            Text(
              !_isSigningUp ? "SIGNING IN" : "SIGNING UP",
              style: TextStyle(fontSize: 20, color: supaGreenColor),
            ),
            if (_isLoading)
              CircularProgressIndicator(
                color: supaGreenColor,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !EmailValidator.validate(_emailController.text)) {
                    return "Please enter correct email @address!";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Enter email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: supaGreenColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: supaGreenMaterialColor.shade200),
                      borderRadius: BorderRadius.circular(15),
                    )),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return "Password is too weak!!";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    labelText: 'Enter password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: supaGreenColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 3, color: supaGreenMaterialColor.shade200),
                      borderRadius: BorderRadius.circular(15),
                    )),
                controller: _passController,
                obscureText: true,
              ),
            ),
            if (_isSigningUp)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value != _passController.text) {
                      return "Password don't match!";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Re - Enter password',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: supaGreenColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: supaGreenMaterialColor.shade200),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  controller: _rePassController,
                  obscureText: true,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: _signIn,
                label: const Text("Sign In"),
                icon: const Icon(Icons.login_rounded),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: _signUp,
                label: const Text("Sign Up"),
                icon: const Icon(Icons.app_registration_rounded),
              ),
            )
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _rePassController.dispose();
    super.dispose();
  }
}
