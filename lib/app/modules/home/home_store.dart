import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {

  FirebaseAuth _firebaseAuth;
  HomeStoreBase(this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen(_onAuthChange);
  }

  @observable
  late User? user = _firebaseAuth.currentUser;

  @action
  void _onAuthChange(User? user) {
    this.user = user;
  }

  @action
  Future<void> logff() async {
    await _firebaseAuth.signOut();
  }

}
