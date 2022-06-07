import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';

class AuthService {

  static const _supabaseSessionKey = "supabase_session";

  final GoTrueClient _client;

  AuthService(this._client);

  Future<bool> signUp(String email, String password) async {
    final response = await _client.signUp(email, password);

    if (response.error == null) {
      log("Sign up success! ${response.user!.id}");
      _persistSession(response.data!);
      return true;
    }
    log("Sign Up error!! ${response.error!.message}");

    return false;
  }

  Future<bool> signIn(String email, String password) async {

    final response = await _client.signIn(email: email, password: password);

    if(response.error == null){
      log("Sign In success!! ${response.user!.id}");
      _persistSession(response.data!);
      return true;
    }

    log("Sign In error!! ${response.error!.message}");
    return false;
  }

  Future<bool> signout() async {
    final response = await _client.signOut();

    if(response.error == null){
      final pref = await SharedPreferences.getInstance();
      pref.remove(_supabaseSessionKey);
      log("Sign Out success!!");
      return true;
    }

    log("Sign out failed!! ${response.error!.message}");
    return false;
  }

  Future<void> _persistSession(Session session)async{

    final pref = await SharedPreferences.getInstance();
    log("Persisting seession string");
    await pref.setString(_supabaseSessionKey, session.persistSessionString);
  }

  Future<bool> recoverSession( ) async{
    final pref = await SharedPreferences.getInstance();

    if(pref.containsKey(_supabaseSessionKey)){
      log("Found persistence session string, now trying to recover the session");
      final jsonStr = pref.getString(_supabaseSessionKey)!;
      final response = await _client.recoverSession(jsonStr);
      if(response.error == null){
        log("Session successfully recovered");
        _persistSession(response.data!);
        return true;
      }
    }
    return false;
  }
}
