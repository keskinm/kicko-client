import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kicko/user/ui/register_page.dart';
import 'package:kicko/user/domain/login_logic.dart';
import 'package:kicko/styles/login_style.dart';
import 'package:kicko/appbar.dart';
import 'package:kicko/syntax.dart';

class LoginPage extends StatefulWidget {
  final String userGroup;
  const LoginPage({Key? key, required this.userGroup}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginLogic logic = LoginLogic();
  LoginStyle style = LoginStyle();

  @override
  Widget build(BuildContext context) {
    String title = userGroupSyntax.titleMap[widget.userGroup];
    return Scaffold(
      appBar: simpleAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 90),
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText("Connexion espace $title",
                          textStyle: style.colorizeTitleTextStyle,
                          colors: style.colorizeColors,
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(60),
                  child: Form(
                    key: logic.formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) =>
                              logic.validateUsername(value: value),
                          decoration: style.inputDecoration(
                              hintText: 'Nom d\'utilisateur'),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.purple),
                                  top: BorderSide(color: Colors.purple))),
                          child: TextFormField(
                            validator: (value) =>
                                logic.validatePassword(value: value),
                            decoration:
                                style.inputDecoration(hintText: 'Mot de passe'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () => logic.validateLogin(
                      context: context, userGroup: widget.userGroup),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            colors: [Colors.purple, Colors.red])),
                    child: const Center(
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  padding: const EdgeInsets.all(40),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mot de passe oublié')),
                    );
                  },
                  child: const Text(
                    'Mot de passe oublié?',
                    style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                  ),
                ),
                AnimatedTextKit(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterPage(userGroup: widget.userGroup);
                    }));
                  },
                  repeatForever: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      "Pas encore de compte ? S'inscrire",
                      textStyle: style.colorizeTextStyle,
                      colors: style.colorizeColors,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
