import 'package:flutter/material.dart';
import '../../login/user/user.dart';
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
      validator: (value) => value!.isEmpty ? "Please enter password" : null,
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

    var doRegister = () {
      final form = formKey.currentState;
       form!.save();

       final Future<Map<String, dynamic>> successfulMessage =
      auth.login(_email, _password);

      successfulMessage.then((response) {
          if (response['status']) {
            User user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/homeScreen');
          }
        });
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
