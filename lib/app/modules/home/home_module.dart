import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import '../home/home_store.dart';
import 'package:instaflutter/app/modules/feed/feed_module.dart';
import 'package:instaflutter/app/modules/search/search_module.dart';
import 'package:instaflutter/app/modules/profile/profile_module.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore(i.get<FirebaseAuth>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) => HomePage(),
      children: [
        ModuleRoute(Constants.Routes.FEED, module: FeedModule(), transition: TransitionType.fadeIn),
        ModuleRoute(Constants.Routes.SEARCH, module: SearchModule(), transition: TransitionType.fadeIn),
        ModuleRoute(Constants.Routes.PROFILE, module: ProfileModule(), transition: TransitionType.fadeIn),
      ]
    ),
  ];
}
