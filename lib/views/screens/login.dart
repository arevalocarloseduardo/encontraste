import 'package:encontraste/controllers/auth_controller.dart';
import 'package:encontraste/views/widgets/berea_button.dart';
import 'package:encontraste/views/widgets/berea_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    bool onlyGoogle = false;
    final user = Provider.of<AuthController>(context);
    return Scaffold(
      key: _key,
      body: Form(
        key: _formKey,
        child: user.status == Status.Authenticating
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    onlyGoogle
                        ? Container()
                        : BereaTextFormField(
                            textController: _email, label: "Correo"),
                    onlyGoogle
                        ? Container()
                        : BereaTextFormField(
                            textController: _password, label: "Contraseña"),
                    onlyGoogle ? Container() : SizedBox(height: 20),
                    onlyGoogle
                        ? Container()
                        : BereaButton(
                            text: "Ingresar con correo",
                            onPressed: () async =>
                                await user.signIn(_email.text, _password.text)),
                    onlyGoogle ? Container() : SizedBox(height: 20),
                    onlyGoogle ? Container() : Center(child: Text("O")),
                    onlyGoogle ? Container() : SizedBox(height: 20),
                    BereaButton(
                        text: "Ingresar con Google",
                        onPressed: () async => await user.signInWithGoogle())
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
