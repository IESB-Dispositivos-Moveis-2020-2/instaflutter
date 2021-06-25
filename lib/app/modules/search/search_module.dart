import 'package:flutter_modular/flutter_modular.dart';
import 'search_page.dart';

class SearchModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SearchPage()),
  ];

}
