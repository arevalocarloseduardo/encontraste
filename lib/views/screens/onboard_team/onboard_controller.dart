import 'package:camera/camera.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/views/screens/onboard_team/onboard_date_birth.dart';
import 'package:encontraste/views/screens/onboard_team/onboard_input_selfie.dart';
import 'package:encontraste/views/screens/onboard_team/onboard_input_sex.dart';
import 'package:encontraste/views/screens/onboard_team/onboard_input_team.dart';
import 'package:encontraste/views/screens/onboard_team/onboard_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'onboard_input_names.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:exif/exif.dart';

class OnboardController with ChangeNotifier {
  FirebaseUser _user;
  FirebaseUser get user => _user;
  set user(FirebaseUser user) {
    _user = user;
  }

  MaskedTextController _telController =
      MaskedTextController(mask: '0000000000');
  MaskedTextController get telController => _telController;

  TextEditingController _nombres = TextEditingController(text: "");
  TextEditingController get nombres => _nombres;
  set nombres(TextEditingController value) {
    _nombres = value;
    notifyListeners();
  }

  TextEditingController _apellidos = TextEditingController(text: "");
  TextEditingController get apellidos => _apellidos;
  set apellidos(TextEditingController value) {
    _apellidos = value;
    notifyListeners();
  }

  int _indexCustom = 0;
  int get indexCustom => _indexCustom;
  set indexCustom(int index) {
    _indexCustom = index;
    notifyListeners();
  }

  Widget _widget = OnboardInputNames();
  Widget get widget => _widget;
  set widget(Widget value) {
    _widget = value;
    notifyListeners();
  }

  List<WidgetOnboard> _listWidgetOnboard = [
    WidgetOnboard(
        index: 0,
        isComplete: false,
        isSelect: false,
        title: "Bienvenido!",
        info: "Indicá tú nombre y seguí completando para continuar."),
    WidgetOnboard(
        index: 1,
        isComplete: false,
        isSelect: false,
        title: "¿Cuál es tú género?",
        info: "Seleccioná uno de los siguientes géneros."),
    WidgetOnboard(
        index: 2,
        isComplete: false,
        isSelect: false,
        title: "¿Cuándo naciste?",
        info: "Agregá tu fecha de nacimiento en el calendario."),
    WidgetOnboard(
        index: 3,
        isComplete: false,
        isSelect: false,
        title: "¿Una selfie?",
        info: "Sonrie! podés tomarte una selfie y mover la imagen"),
    WidgetOnboard(
        index: 4,
        isComplete: false,
        isSelect: false,
        title: "En contacto",
        info: "Si deseas estar más en contacto agregá tu número."),
    WidgetOnboard(
        index: 5,
        isComplete: false,
        isSelect: false,
        title: "Sé parte del equipo!",
        info: "Si aún no tenés equipo o no te acordás, podés continuar."),
  ];
  WidgetOnboard _widgetOnboard = WidgetOnboard(
      index: 0,
      isComplete: false,
      isSelect: false,
      title: "Bienvenido!",
      info: "yatusabes");

  WidgetOnboard get widgetOnboard => _widgetOnboard;

  set widgetOnboard(WidgetOnboard widget) {
    _widgetOnboard = widget;
    selectPage(widget.index);
    notifyListeners();
  }

  init() {
    widgetOnboard = listWidgetOnboard[indexCustom];
  }

  List<WidgetOnboard> get listWidgetOnboard => _listWidgetOnboard;

  set listWidgetOnboard(List<WidgetOnboard> button) {
    _listWidgetOnboard = button;
    notifyListeners();
  }

  selectWidget({int index}) {
    _listWidgetOnboard.map((element) {
      if (element.index == index) {
        element.isSelect = true;
        widgetOnboard = element;
      } else {
        element.isSelect = false;
      }
    }).toList();
    notifyListeners();
  }

  completWidget({int index}) {
    _listWidgetOnboard.map((element) {
      if (element.index == index) {
        element.isComplete = true;
      }
    }).toList();
    notifyListeners();
  }

  Persona _person = Persona(fechaDeNacimiento: DateTime(1995, 7, 17));
  Persona get person => _person;
  set person(Persona newPerson) {
    _person = newPerson;
    notifyListeners();
  }

  void nextWidget({bool thisWidgetComplet = true}) {
    if (thisWidgetComplet) {
      completWidget(index: _widgetOnboard.index);
    }
    if (_widgetOnboard.index == _listWidgetOnboard.length - 1) {
      print("complete");
      finalizarOnboard();
    } else {
      selectWidget(index: _widgetOnboard.index + 1);
    }
  }

  void selectPage(int index) {
    switch (index) {
      case 0:
        widget = OnboardInputNames();
        break;
      case 1:
        widget = OnboardInputSex();
        break;
      case 2:
        widget = OnboardInputDateBirth();
        break;
      case 3:
        onInit();
        widget = OnboardInputSelfie();

        break;
      case 4:
        widget = OnboardInputPhone();
        break;
      case 5:
        widget = OnboardInputTeam();
        break;
      default:
    }
  }

  void setNames() {
    _person.apellidos = _apellidos.text;
    _person.nombres = _nombres.text;
  }

  void setFecha(DateTime dateTime) {
    person.fechaDeNacimiento = dateTime;
    notifyListeners();
  }

  ///Camera

  static String currentPicture;
  double initialX = 0;
  double initialY = 0;

  CameraController _camera;
  CameraController get camera => _camera;
  set camera(CameraController change) {
    _camera = change;
  }

  double _posX = 0;
  double get posX => _posX;
  set posX(double change) {
    _posX = change;
    notifyListeners();
  }

  double _posY = 0;
  double get posY => _posY;
  set posY(double change) {
    _posY = change;
    notifyListeners();
  }

  double _scale = 1.0;
  double get scale => _scale;
  set scale(double change) {
    _scale = change;
    notifyListeners();
  }

  double _previousScale = 1.0;
  double get previousScale => _previousScale;
  set previousScale(double change) {
    _previousScale = change;
    notifyListeners();
  }

  File _picture;
  File get picture => _picture;
  set picture(File change) {
    imageCache.clear();
    _picture = change;
    notifyListeners();
  }

  Future<void> updatePicture(double viewHeight) async {
    try {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(picture.path);

      final image = img.decodeImage(picture.readAsBytesSync());

      final photoHeight = properties.width > properties.height
          ? properties.width
          : properties.height;
      final photoWidth = properties.width > properties.height
          ? properties.height
          : properties.width;
//-((viewHeight/21)*4)
      final y = ((photoHeight * 0.2) - (photoWidth * 0.2) + viewHeight * 0.12)
          .toInt();
      final x = (photoWidth * 0.096).toInt();
      final h = (photoWidth * 0.8).toInt();
      final w = (photoWidth * 0.8).toInt();

      final newW = w ~/ scale;
      final newH = h ~/ scale;
      final newX = x ~/ scale;
      final newY = y ~/ scale;
      final newPosX = posX ~/ scale;
      final newPosY = posY ~/ scale;

      final croppedImage = img.copyCrop(image, (newX - newPosX).toInt(),
          (newY - newPosY).toInt(), newW, newH);
 var imag =img.encodeJpg(croppedImage);
 
      startUpload(imag);
      nextWidget();  
    } catch (e) {
      picture = null;
      posY = 0;
      posX = 0;
      scale = 1.0;
      log(e.toString());
    }
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      imageCache.clear();
      return newFile;
    }
  }

  Future<void> getPictureFromCamera() async {
    if (camera != null) {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final path = extDir.path + '/selfie.jpg';

      final File selfie = File(path);

      if (await selfie.exists()) {
        await selfie.delete(recursive: true);
      }

      await camera.takePicture(path);

      final tempPicture = File(path);

      List<int> bytes = await tempPicture.readAsBytes();
      var tags = await readExifFromBytes(bytes);
      var sb = StringBuffer();
      tags.forEach((k, v) {
        sb.write("$k: $v \n");
      });

      log(sb.toString());

      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(path);

      log('Imagen capturada - width: ${properties.width}, height: ${properties.height} orientation: ${properties.orientation}');

      if (properties.width > properties.height) {
        switch (tags['Image Orientation'].toString().split(' ')[1]) {
          case '90':
            bytes = await FlutterImageCompress.compressWithList(
              bytes,
              minHeight: 720,
              minWidth: 720,
              quality: 96,
              rotate: 0,
            );
            break;

          case '0':
            bytes = await FlutterImageCompress.compressWithList(
              bytes,
              minHeight: 720,
              minWidth: 720,
              quality: 96,
              rotate: 90,
            );
            break;

          case '270':
            bytes = await FlutterImageCompress.compressWithList(
              bytes,
              minHeight: 720,
              minWidth: 720,
              quality: 96,
              rotate: 180,
            );
            break;

          case '180':
            bytes = await FlutterImageCompress.compressWithList(
              bytes,
              minHeight: 720,
              minWidth: 720,
              quality: 96,
              rotate: 270,
            );
            break;

          default:
            break;
        }

        tempPicture.writeAsBytesSync(bytes, flush: true);

        await moveFile(tempPicture, tempPicture.path);
      }

      picture = tempPicture;
    }
  }

  Future<void> onInit() async {
    if (camera == null) {
      final cameras = await availableCameras();
      CameraDescription cam = cameras
          .firstWhere((cam) => cam.lensDirection == CameraLensDirection.front);

      if (cam != null) {
        final tempCam =
            CameraController(cam, ResolutionPreset.high, enableAudio: false);
        await tempCam.initialize();
        camera = tempCam;
      notifyListeners();
      }
    } else {
      //await camera.initialize();
      //camera = camera;
    }
  }

  void setPhone() {
    _person.celular = _telController.text;
  }

  /// Starts an upload task
  void startUpload( data ) {
    /// Unique file name for the file
      
    String filePath = 'images/${user.uid}.jpg';

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(filePath);

    StorageUploadTask uploadTask = storageReference.putData(data);
    uploadTask.onComplete.then((onValue) {
      print("cargue foto");
      storageReference.getDownloadURL().then((imageUrl) {
        person.imagen = imageUrl;
      });
    });
  }

  void finalizarOnboard() {
    person = Persona.fromOnboard(user, person);
    print("sexo: " + person.sexo);
    print("Nmbres: " + person.nombres);
    print("apellido: " + person.apellidos);
    print("Fechade nacimiento: " + person.fechaDeNacimiento.toString());
    print("celular: " + person.celular);
    print("email: " + person.email);
    print("imagen: " + person.imagen);
    print("equipo: " + person.idEquipo);
  }
}

class WidgetOnboard {
  int index;
  bool isSelect;
  bool isComplete;
  String title;
  String info;
  WidgetOnboard(
      {this.index, this.isSelect, this.isComplete, this.title, this.info});

  factory WidgetOnboard.allFalse(WidgetOnboard widget) {
    return WidgetOnboard(
        title: widget.title ?? "",
        info: widget.info ?? "",
        index: widget.index ?? -1,
        isComplete: widget.isComplete ?? false,
        isSelect: false ?? false);
  }
}
