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

  late String _email, _publicKey;

  @override
  Widget build(BuildContext context) {
    AuthorisationProvider auth = Provider.of<AuthorisationProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    Future<void> _showDialogWithKeys() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('This are your public and private keys. Save private key in a safe place and do not show anyone.\nNotice: if you lost your key, you would not be able to restore it and login!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Public ...'),
                  Text('Private ...'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Done.'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/homeScreen');
                },
              ),
            ],
          );
        },
      );
    }

    var doRegister = () {
      final form = formKey.currentState;
       form!.save();

       final Future successfulMessage =
      auth.register(_email, _publicKey);

      successfulMessage.then((response) {
          if (response['status']) {
            User user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            _showDialogWithKeys();
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
