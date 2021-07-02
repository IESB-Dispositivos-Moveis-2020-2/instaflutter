abstract class Constants {

  //SPK = Shared Preferences Key
  static const SPK_ONBOARDING_DONE = 'OnboardingDone';
  static const SPK_REGISTER_DONE = 'RegisterDone';

  static final Routes = _Routes();
  static final Pictures = _Pictures();

}

class _Routes {

  final HOME = '/home';
  final ONBOARDING = '/onboarding';
  final REGISTER = '/register';
  final LOGIN = '/login';
  final FORGOT_PASSWORD = '/login/forgot-password';

  final FEED = '/feed';
  final SEARCH = '/search';
  final PROFILE = '/profile';
  final EDIT = '/edit';

}

class _Pictures {

  final LOGIN = 'assets/login.png';
  final FORGOT_PASSWORD = 'assets/forgot_password.png';

}
