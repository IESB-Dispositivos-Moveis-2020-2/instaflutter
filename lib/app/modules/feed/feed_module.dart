import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaflutter/app/modules/feed/feed_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'feed_page.dart';

class FeedModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => FeedStore(
      firebaseAuth: i.get<FirebaseAuth>(),
      firebaseFirestore: i.get<FirebaseFirestore>()
    )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => FeedPage()),
  ];
}
