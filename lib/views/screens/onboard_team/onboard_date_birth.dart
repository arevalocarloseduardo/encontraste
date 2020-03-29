import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:encontraste/views/screens/onboard_team/onboard_controller.dart';
import 'package:encontraste/views/widgets/berea_onbord_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

class OnboardInputDateBirth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OnboardController state = Provider.of<OnboardController>(context);

    var time2 = DateTime(1995);

    final format = DateFormat("yyyy-MM-dd");
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DateTimeField(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        prefixIcon:
                            Icon(Icons.chevron_right, color: Colors.white),
                        filled: true,
                        fillColor: BereaColors.secondary.withOpacity(0.4),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: BereaColors.secondary.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        //fillColor: Colors.white70,
                        focusColor: Colors.white,
                        hintStyle: new TextStyle(color: Colors.grey[800]),
                        labelText:
                            "${state.person.fechaDeNacimiento.day}/${state.person.fechaDeNacimiento.month}/${state.person.fechaDeNacimiento.year}",
                        labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(color: Colors.white),
                    format: format,
                    onShowPicker: (context, currentValue) async {
                      var times = await showDatePicker(
                          context: context,
                          locale: Locale("es", "ES"),
                          initialDate: state.person.fechaDeNacimiento,
                          firstDate: DateTime(1980),
                          lastDate: DateTime(2010),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData(
                                primaryColor: BereaColors.purple,
                                secondaryHeaderColor: BereaColors.secondary,
                              ),
                              child: child,
                            );
                          });
                      state.setFecha(times ?? DateTime(1995, 7, 17));
                    },
                  ),
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
                        text: "Confirmar",
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
