import 'package:encontraste/views/screens/onboard_team/onboard_controller.dart';
import 'package:encontraste/views/widgets/berea_onbord_button.dart';
import 'package:encontraste/views/widgets/berea_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardInputPhone extends StatelessWidget {
  final _formKeyNumber = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    OnboardController state = Provider.of<OnboardController>(context);
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
              child: Text(state.widgetOnboard.title,
                  style: TextStyle(color: Colors.white, fontSize: 40)),
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            child: Form(
              key: _formKeyNumber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  BereaTextFormField( 
                      textController: state.telController,
                      label: "Celular",
                      keyboardType: TextInputType.phone),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Center(
              child: Text(state.widgetOnboard.info,
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
                          if (_formKeyNumber.currentState.validate()) {
                               state.setPhone();
                             state.nextWidget();
                          }
                        },
                        text: "Confirmar",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: BereaOnboardButton(
                        onPressed: () {
                                      state.nextWidget(
                                          thisWidgetComplet: false);},
                        
                        text: "Saltar",
                      ),
                    ),
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
