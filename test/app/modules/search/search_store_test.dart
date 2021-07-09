import 'package:flutter_test/flutter_test.dart';
import 'package:instaflutter/app/modules/search/search_store.dart';
 
void main() {
  late SearchStore store;

  setUpAll(() {
    store = SearchStore();
  });

  test('increment count', () async {
    expect(store.value, equals(0));
    store.increment();
    expect(store.value, equals(1));
  });
}