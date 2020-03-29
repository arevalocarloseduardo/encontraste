import 'package:encontraste/utils/constants.dart';
import 'package:encontraste/views/widgets/berea_circle_navitaion.dart';
import 'package:encontraste/views/widgets/berea_onbord_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'onboard_controller.dart';

class OnboardWelcome extends StatelessWidget {
  OnboardWelcome(FirebaseUser user) : _user = user;
  final FirebaseUser _user;
  @override
  Widget build(BuildContext context) {
    OnboardController state = Provider.of<OnboardController>(context);
    state.user = _user;
    //double heigth = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Container(color: BereaColors.purple),
        Container(
            child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: TopNavigationCircle(state: state),
                    ),
                  ),
                  Expanded(flex: 17, child: state.widget)
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }
}

class TopNavigationCircle extends StatelessWidget {
  const TopNavigationCircle({
    Key key,
    @required this.state,
  }) : super(key: key);

  final OnboardController state;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BereaCirclePosition(
            onPressed: () => state.selectWidget(index: 0),
            isSelect: state.listWidgetOnboard[0].isSelect,
            isCompleted: state.listWidgetOnboard[0].isComplete,
            ordenPosition: 1,
            icon: Icons.assignment),
        BereaCirclePosition(
            onPressed: () => state.selectWidget(index: 1),
            isSelect: state.listWidgetOnboard[1].isSelect,
            isCompleted: state.listWidgetOnboard[1].isComplete,
            ordenPosition: 2,
            icon: Icons.wc),
        BereaCirclePosition(
            onPressed: () => state.selectWidget(index: 2),
            isSelect: state.listWidgetOnboard[2].isSelect,
            isCompleted: state.listWidgetOnboard[2].isComplete,
            ordenPosition: 3,
            icon: Icons.cake),
        BereaCirclePosition(
            onPressed: () => state.selectWidget(index: 3),
            isSelect: state.listWidgetOnboard[3].isSelect,
            isCompleted: state.listWidgetOnboard[3].isComplete,
            ordenPosition: 4,
            icon: Icons.add_a_photo),
        BereaCirclePosition(
            onPressed: () => state.selectWidget(index: 4),
            isSelect: state.listWidgetOnboard[4].isSelect,
            isCompleted: state.listWidgetOnboard[4].isComplete,
            ordenPosition: 5,
            icon: Icons.contact_phone),
        BereaCirclePosition(
            onPressed: () => state.selectWidget(index: 5),
            isSelect: state.listWidgetOnboard[5].isSelect,
            isCompleted: state.listWidgetOnboard[5].isComplete,
            ordenPosition: 6,
            icon: Icons.group_add),
      ],
    );
  }
}
