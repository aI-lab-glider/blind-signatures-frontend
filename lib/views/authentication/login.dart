import 'package:flutter/material.dart';
import '../../data/model/user.dart';
import '../../login/providers/authorisation.dart';
import '../../login/providers/user_provider.dart';
import '../../login/utils/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

   late String _email, _publicKey;

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
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
      onSaved: (value) => _publicKey = value!,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Authenticating ... Please wait")
      ],
    );

    final registerButton = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );

    var doLogin = () {
      final form = formKey.currentState;

        form!.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(_email, _publicKey);

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/homeScreen');
          }
          else {
            SnackBar snackBar = SnackBar(content: Text("Failed to log in. Check the data provided and try again. If don't have an account, please sign up."));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        });
    };

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            body: Container(
              padding: EdgeInsets.all(40.0),
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
                    auth.loggedInStatus == Status.authenticating
                        ? loading
                        : longButtons("Login", doLogin),
                    const SizedBox(height: 5.0),
                    registerButton
                  ],
                ),
              ),
            ),
          ),
        )
      );
  }
}
