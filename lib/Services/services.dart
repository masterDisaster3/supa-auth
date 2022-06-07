import 'package:auth/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';


class Services extends InheritedWidget{

  final AuthService  authService;

  const Services._({required this.authService, required Widget child}) : super(child: child);

  factory Services({required Widget child}) {
    
    final client = SupabaseClient("YOUR SUPABASE URL", "YOUR SUPABASE ANNON KEY");

    final authService = AuthService(client.auth);

    return Services._(authService: authService, child: child);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Services of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>()!;
  }
  
}