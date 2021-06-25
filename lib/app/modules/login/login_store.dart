import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;
abstract class _LoginStoreBase with Store {

  FirebaseAuth _firebaseAuth;
  _LoginStoreBase(this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen(_onAuthChange);
  }

  @observable
  late User? user = _firebaseAuth.currentUser;

  @observable
  bool loading = false;

  @action
  void _onAuthChange(User? user) {
    this.user = user;
  }

  @action
  Future<void> loginWith({required String email, required String password}) async {
    if (email.isEmpty || email.indexOf('@') == -1 || password.isEmpty) {
      return;
    }
    loading = true;
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    loading = false;
  }

  @action
  Future<void> resetPassword({required String email}) async {
    loading = true;
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    loading = false;
  }

}
