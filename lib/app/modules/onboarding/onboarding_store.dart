import 'package:instaflutter/app/constants.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_store.g.dart';

class OnboardingStore = _OnboardingStoreBase with _$OnboardingStore;
abstract class _OnboardingStoreBase with Store {

  SharedPreferences _sharedPreferences;
  _OnboardingStoreBase(this._sharedPreferences);


  @action
  markOnboardingDone() {
    _sharedPreferences.setBool(Constants.SPK_ONBOARDING_DONE, true);
  }

  @action
  markRegisterDone() {
    _sharedPreferences.setBool(Constants.SPK_REGISTER_DONE, true);
  }

}
