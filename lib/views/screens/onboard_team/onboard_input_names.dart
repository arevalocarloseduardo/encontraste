import 'package:encontraste/views/screens/onboard_team/onboard_controller.dart';
import 'package:encontraste/views/widgets/berea_onbord_button.dart';
import 'package:encontraste/views/widgets/berea_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardInputNames extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    OnboardController state = Provider.of<OnboardController>(context);
    var secondOption = false;
    var title = "Registrate!";
    var info = "Indicá tú nombre y seguí completando para continuar.";
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            child: Center(
              child: Text(title,
                  style: TextStyle(color: Colors.white, fontSize: 40)),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                BereaTextFormField(
                    textController: state.nombres, label: "Nombres"),
                SizedBox(height: 16),
                BereaTextFormField(
                    textController: state.apellidos, label: "Apellidos"),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Center(
              child: Text(info,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 26)),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: BereaOnboardButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            state.setNames();
                            state.nextWidget();
                          }
                        },
                        text: "Continuar",
                      ),
                    ),
                    secondOption
                        ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: BereaOnboardButton(
                              onPressed: () {},
                              text: "null",
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
