import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobx/mobx.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;
abstract class _ProfileStoreBase with Store {

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  FirebaseStorage firebaseStorage;

  _ProfileStoreBase({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage
  }) {
    firebaseAuth.userChanges().listen(_onUserChange);
  }

  @observable
  late User? user = firebaseAuth.currentUser;

  @observable
  String? bio;

  @observable
  int? following;

  @observable
  int? followers;

  @observable
  int? postsCount;

  @observable
  bool loading = false;

  @observable
  FirebaseException? error;

  @computed
  Stream<QuerySnapshot> get posts {
    return firebaseFirestore.collection('post')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy('dateTime', descending: true)
        .snapshots();
  }

  @action
  void _onUserChange(User? user) {
    this.user = user;
    if (user != null) {
      firebaseFirestore.doc('user/${user.uid}').snapshots()
          .listen(_listenUser);
    }
  }

  @action
  void _listenUser(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (snapshot.exists) {
      final data = snapshot.data() ?? {};
      bio = data['bio'] as String;
      following = data.containsKey('following') ? data['following'].length : 0;
      followers = data.containsKey('followers') ? data['followers'].length : 0;
    }
  }

  @action
  Future<void> updateProfile({required String displayName, required String bio}) async {
    if (user == null) {
      return;
    }

    try {
      loading = true;

      await firebaseFirestore.doc('user/${user!.uid}').set(
          {
            'diplayName': displayName,
            'bio': bio
          },
          SetOptions(merge: true)
      );

      await firebaseAuth.currentUser!.updateDisplayName(displayName);

    }on FirebaseException catch (e) {
      error = e;
      log('Erro salvar edição de perfil', error: e);
    }finally {
      loading = false;
    }
  }

  @action
  Future<void> updateProfilePicture(String filePath) async {
    loading = true;

    final userRef = await firebaseFirestore.doc('user/${user!.uid}');

    final file = File(filePath);
    final task = await firebaseStorage.ref('${user!.uid}/profilePicture.jpg').putFile(file);
    final url = await task.ref.getDownloadURL();

    firebaseAuth.currentUser!.updatePhotoURL(url);

    await userRef.set({
      'profilePicture': url
    }, SetOptions(merge: true));

    loading = false;
  }


  @action
  Future<void> postPicture(String filePath) async {
    loading = true;

    final userRef = await firebaseFirestore.doc('user/${user!.uid}');

    final file = File(filePath);
    final task = await firebaseStorage.ref('${user!.uid}/uploads/post_${DateTime.now().millisecondsSinceEpoch}').putFile(file);
    final url = await task.ref.getDownloadURL();
    
    await firebaseFirestore.collection('post').add({
      'userId': user!.uid,
      'dateTime': DateTime.now().toIso8601String(),
      'url': url,
    });

    loading = false;
  }

  @action
  Future<void> logoff() {
    return firebaseAuth.signOut();
  }

  @action
  void setPostsCount(int count) {
    postsCount = count;
  }

}
