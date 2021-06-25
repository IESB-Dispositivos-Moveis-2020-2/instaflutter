
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppRouteGuard extends RouteGuard {

  FirebaseAuth _firebaseAuth;
  AppRouteGuard(this._firebaseAuth): super(null) {
    _firebaseAuth.authStateChanges().listen(_setCurrentUser);
  }

  late User? _currentUser = _firebaseAuth.currentUser;

  void _setCurrentUser(User? user) {
    _currentUser = user;
  }

  @override
  Future<bool> canActivate(String path, ModularRoute router) {

    if (_currentUser == null) {
      return Future.value(false);
    }

    return Future.value(!(_currentUser?.isAnonymous ?? true));

  }

}
