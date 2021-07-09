// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchStore on _SearchStoreBase, Store {
  Computed<Stream<QuerySnapshot<Object?>>>? _$postsComputed;

  @override
  Stream<QuerySnapshot<Object?>> get posts => (_$postsComputed ??=
          Computed<Stream<QuerySnapshot<Object?>>>(() => super.posts,
              name: '_SearchStoreBase.posts'))
      .value;

  final _$searchResultAtom = Atom(name: '_SearchStoreBase.searchResult');

  @override
  Stream<QuerySnapshot<Object?>> get searchResult {
    _$searchResultAtom.reportRead();
    return super.searchResult;
  }

  @override
  set searchResult(Stream<QuerySnapshot<Object?>> value) {
    _$searchResultAtom.reportWrite(value, super.searchResult, () {
      super.searchResult = value;
    });
  }

  final _$searchAsyncAction = AsyncAction('_SearchStoreBase.search');

  @override
  Future<void> search(String query) {
    return _$searchAsyncAction.run(() => super.search(query));
  }

  final _$addAsyncAction = AsyncAction('_SearchStoreBase.add');

  @override
  Future<void> add(String userId) {
    return _$addAsyncAction.run(() => super.add(userId));
  }

  @override
  String toString() {
    return '''
searchResult: ${searchResult},
posts: ${posts}
    ''';
  }
}
