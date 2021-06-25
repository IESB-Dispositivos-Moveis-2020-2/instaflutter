// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginStore on _LoginStoreBase, Store {
  final _$userAtom = Atom(name: '_LoginStoreBase.user');

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$loadingAtom = Atom(name: '_LoginStoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$loginWithAsyncAction = AsyncAction('_LoginStoreBase.loginWith');

  @override
  Future<void> loginWith({required String email, required String password}) {
    return _$loginWithAsyncAction
        .run(() => super.loginWith(email: email, password: password));
  }

  final _$resetPasswordAsyncAction =
      AsyncAction('_LoginStoreBase.resetPassword');

  @override
  Future<void> resetPassword({required String email}) {
    return _$resetPasswordAsyncAction
        .run(() => super.resetPassword(email: email));
  }

  final _$_LoginStoreBaseActionController =
      ActionController(name: '_LoginStoreBase');

  @override
  void _onAuthChange(User? user) {
    final _$actionInfo = _$_LoginStoreBaseActionController.startAction(
        name: '_LoginStoreBase._onAuthChange');
    try {
      return super._onAuthChange(user);
    } finally {
      _$_LoginStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
loading: ${loading}
    ''';
  }
}
