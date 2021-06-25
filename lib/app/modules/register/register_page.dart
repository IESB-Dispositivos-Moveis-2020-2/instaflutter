import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/constants.dart';
import 'package:instaflutter/app/modules/register/register_store.dart';
import 'package:mobx/mobx.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key? key, this.title = 'Faça seu cadastro!'}) : super(key: key);
  @override
  RegisterPageState createState() => RegisterPageState();
}
class RegisterPageState extends ModularState<RegisterPage, RegisterStore> {

  late PageController _pageController;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _disposer = when(
      (_) => store.user != null,
      () => Modular.to.pushReplacementNamed(Constants.Routes.HOME)
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  late final Widget _form = PageView(
    controller: _pageController,
    scrollDirection: Axis.vertical,
    physics: NeverScrollableScrollPhysics(),
    children: [
      _FormField(
        controller: _nameController,
        label: 'Qual é o seu nome?',
        showsBackButton: false,
        onNext: () {
          _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
      ),
      _FormField(
        controller: _emailController,
        label: 'Qual é o seu melhor e-mail?',
        onNext: () {
          _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
        onBack: () {
          _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
      ),
      _FormField(
        controller: _passwordController,
        label: 'Crie uma senha',
        isPassword: true,
        onNext: () {
          store.registerUser(
              name: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text
          );
        },
        onBack: () {
          _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Observer(
        builder: (_) {
          if (store.loading) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Aguarde... salvando seu cadastro...')
                ],
              ),
            );
          }
          return _form;
        },
      ),
    );
  }
}

class _FormField extends StatelessWidget {

  final String label;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool showsBackButton;
  final bool isPassword;
  final TextEditingController controller;

  _FormField({
    required this.label,
    required this.onNext,
    this.onBack,
    this.showsBackButton = true,
    this.isPassword = false,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showsBackButton ? _backButton() : SizedBox.fromSize(size: Size.zero),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 40),
                    maxLines: 1,
                  ),
                ),
                TextFormField(
                  controller: controller,
                  onEditingComplete: onNext,
                  style: TextStyle(fontSize: 32),
                  obscureText: isPassword,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _backButton() {
    return IconButton(onPressed: onBack, icon: Icon(Icons.arrow_upward));
  }

}
