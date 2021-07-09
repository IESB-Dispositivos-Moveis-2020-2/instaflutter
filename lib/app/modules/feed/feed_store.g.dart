// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FeedStore on _FeedStoreBase, Store {
  final _$postsAtom = Atom(name: '_FeedStoreBase.posts');

  @override
  Stream<QuerySnapshot<Object?>> get posts {
    _$postsAtom.reportRead();
    return super.posts;
  }

  @override
  set posts(Stream<QuerySnapshot<Object?>> value) {
    _$postsAtom.reportWrite(value, super.posts, () {
      super.posts = value;
    });
  }

  final _$_loadFeedAsyncAction = AsyncAction('_FeedStoreBase._loadFeed');

  @override
  Future<void> _loadFeed() {
    return _$_loadFeedAsyncAction.run(() => super._loadFeed());
  }

  @override
  String toString() {
    return '''
posts: ${posts}
    ''';
  }
}
