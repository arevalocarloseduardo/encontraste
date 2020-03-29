import 'package:encontraste/views/screens/onboard_team/onboard_controller.dart';
import 'package:encontraste/views/widgets/berea_onbord_button.dart';
import 'package:encontraste/views/widgets/berea_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardInputTeam extends StatelessWidget {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                BereaSwitch(
                  value: state.person.idEquipo == null
                      ? true
                      : state.person.idEquipo == "0OtwyNJ5VMlYrhjKWLjd", 
                  textOn: 'Celeste',
                  textOff: 'Naranja',
                  colorOn: Colors.lightBlue[600],
                  colorOff: Colors.orange[300],
                  iconOn: Icons.done,
                  iconOff: Icons.done,
                  textSize: 24.0,
                  onChanged: (bool value) {
                    print(value);
                    print(value ? "celeste" : "naranaja");
                    state.person.idEquipo = value ? "0OtwyNJ5VMlYrhjKWLjd" : "vuEV8viTnRUBe2bL4aGO";//naranja
                  },
                ),
              ],
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
                          state.nextWidget();
                        },
                        text: "Finalizar",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: BereaOnboardButton(
                        onPressed: () {
                          state.nextWidget(thisWidgetComplet: false);
                        },
                        text: "Continuar sin equipo",
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
