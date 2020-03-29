import 'package:camera/camera.dart';
import 'package:encontraste/utils/constants.dart';
import 'package:encontraste/views/widgets/berea_onbord_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'onboard_controller.dart';

class OnboardInputSelfie extends StatelessWidget {
  static final String routeName = '/profile_picture';

  var tome = false;

  @override
  Widget build(BuildContext context) {
    final viewHeight = MediaQuery.of(context).size.height;
    final viewWidth = MediaQuery.of(context).size.width;
    // final globalState = Provider.of<GlobalController>(context);
    final state = Provider.of<OnboardController>(context);

    return Container(
      child: Stack(
        children: <Widget>[
          (state.camera != null && state.picture == null)
              ? Align(
                  child: AspectRatio(
                    child: Container(
                      child: CameraPreview(state.camera),
                    ),
                    aspectRatio: 9 / 16,
                  ),
                )
              : CircularProgressIndicator(),

          if (state.picture != null)
            Positioned(
              top: state.posY,
              left: state.posX,
              height: viewHeight-((viewHeight/21)*4),
              width: viewWidth,
              child: Transform(
                transform: Matrix4.diagonal3(
                    Vector3(state.scale, state.scale, state.scale)),
                child: Image.file(
                  state.picture,
                ),
              ),
            ),

          // Clipper
          ClipPath(
            clipper: _PictureInputClipper(),
            child: Container(
              color: Colors.white38,
            ),
          ),
          // Picture editing
          if (state.picture != null)
            GestureDetector(
              onScaleStart: (ScaleStartDetails details) {
                state.initialX = details.focalPoint.dx;
                state.initialY = details.focalPoint.dy;
                state.previousScale = state.scale;
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                final distanceX = details.focalPoint.dx - state.initialX;
                final distanceY = details.focalPoint.dy - state.initialY;
                state.initialX = details.focalPoint.dx;
                state.initialY = details.focalPoint.dy;

                if (state.posY + distanceY < (viewHeight-((viewHeight/21))*4) * 0.15 &&
                    state.posY + distanceY > -((viewHeight-((viewHeight/21))*4) * 0.15)) {
                  state.posY += distanceY;
                }
                if (state.posX + distanceX < viewWidth * 0.15 &&
                    state.posX + distanceX > -(viewWidth * 0.15)) {
                  state.posX += distanceX;
                }

                if (state.previousScale * details.scale < 1.15 &&
                    state.previousScale * details.scale > 0.85) {
                  state.scale = state.previousScale * details.scale;
                }
              },
              onScaleEnd: (ScaleEndDetails details) {
                state.previousScale = 1.0;
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          // Header

          Container(
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
                child: Container(),
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
                          state.picture == null
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: BereaOnboardButton(
                                    onPressed: state.getPictureFromCamera,
                                    text: "Tomar Foto",
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: BereaOnboardButton(
                                    onPressed: () =>
                                        state.updatePicture(viewHeight),
                                    text: "Confirmar",
                                  ),
                                ),
                          state.picture == null
                              ? Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: BereaOnboardButton(
                                    onPressed: () {
                                      state.nextWidget(
                                          thisWidgetComplet: false);
                                    },
                                    text: "Saltar",
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: BereaOnboardButton(
                                    onPressed: () {
                                      state.picture = null;
                                      state.posY = 0;
                                      state.posX = 0;
                                      state.scale = 1.0;
                                    },
                                    text: "Volver a tomar",
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class _PictureInputClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double percentageH = 0.325;
    final double percentageW = 0.9;
    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2.6),
          radius: size.width * 0.38,
        ),
        Radius.circular(size.width * 0.4)));
    path.addRect(Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      height: size.height,
      width: size.width,
    ));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
