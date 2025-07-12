import 'package:country_api/screens/country_screen.dart';
import 'package:country_api/screens/registre_screen.dart';
import 'package:country_api/service/firebase_auth_service.dart';
import 'package:country_api/utils/results.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool enableVisibility = false;

  changeVisibility() {
    setState(() {
      enableVisibility = !enableVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Home Country"),),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<Results>(
          stream: _auth.resultsLogin,
          builder: (context, snapshot) {
            ErrorResult result = ErrorResult(code: "");
            if (snapshot.data is ErrorResult) {
              result = snapshot.data as ErrorResult;
            }
            if (snapshot.data is LoadingResult) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data is SuccessResult) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountriesScreen(title: "Home")
                  ),
                );
              });
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:40.0),
                  child: TextField(

                    controller: _emailController,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)
                      ),
                        labelText: 'Email'),
                    style: TextStyle(fontFamily: "Arial", fontSize: 20.0),

                  ),
                ),
                TextField(
                  style: TextStyle(fontFamily: "Arial", fontSize: 20.0),
                  controller: _passwordController,
                  obscureText: enableVisibility,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        changeVisibility();
                      },
                      icon: enableVisibility
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String email = _emailController.text;
                    final String password = _passwordController.text;
                    _auth.signIn(email, password);
                  },
                  child: const Text("Logar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Registre-se"),
                ),
                if (result.code.isNotEmpty)
                  switch(result.code) {
                    "invalid-email" => Text("Autenticacao Invalida"),
                    "wrong-password" => Text("Autenticacao Invalida"),
                    _ => Text("Error")
                  }

              ],
            );
          },
        ),
      ),
    );
  }
}