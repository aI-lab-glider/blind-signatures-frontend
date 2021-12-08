import 'package:flutter/material.dart';
import 'package:test_app/core/rsa.dart';
import 'package:test_app/login/utils/preferences.dart';
import '../../data/model/user.dart';
import '../../login/providers/authorisation.dart';
import '../../login/providers/user_provider.dart';
import '../../login/utils/widgets.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();

  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    AuthorisationProvider auth = Provider.of<AuthorisationProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter password";
        }
        if (value.length < 8) {
          return "Password should contain at least 8 characters.";
        }
        if (!RegExp(".*[a-z].*", caseSensitive: true).hasMatch(value)) {
          return "Password must contain a lowercase letter.";
        }
        if (!RegExp(".*[A-Z].*", caseSensitive: true).hasMatch(value)) {
          return "Password must contain an uppercase letter.";
        }
      },
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    final loginButton = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Log In", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );

    var doRegister = () {
      final form = formKey.currentState;
      form!.save();
      if (formKey.currentState!.validate()) {
        var pair = generateRSAkeyPair(exampleSecureRandom());
        final _public = pair.publicKey.modulus;
        final _private = pair.privateKey.privateExponent;

        var prefs = UserPreferences();
        prefs.saveKeys(_public!, _private!);

        final Future successfulMessage =
        auth.register(_email, _password, _public.toString());

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/homeScreen');
          }
          else {
            SnackBar snackBar = SnackBar(content: Text(
                "Registration failed. Check the data provided and try again. If you already have account, please go back to Login page."));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
      }
    };

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                label("Email"),
                const SizedBox(height: 5.0),
                emailField,
                const SizedBox(height: 20.0),
                label("Password"),
                const SizedBox(height: 5.0),
                passwordField,
                const SizedBox(height: 20.0),
                auth.loggedInStatus == Status.registering
                    ? loading
                    : longButtons("Register", doRegister),
                const SizedBox(height: 5.0),
                loginButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
