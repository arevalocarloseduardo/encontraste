import 'package:agora_rtm/agora_rtm.dart';
import 'package:encontraste/models/sala.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/utils/settings.dart';
import 'package:flutter/cupertino.dart';

import 'auth_controller.dart';

class RtmController with ChangeNotifier {
  AuthController _aut;

  List<AgoraRtmMember> _members;
  List<AgoraRtmMember> get members => _members;

  set members(List<AgoraRtmMember> value) {
    _members = value;
    notifyListeners();
  }

  DatabaseService _db;
  final _infoStrings = <String>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  AgoraRtmChannel get channel => _channel;
  set channel(AgoraRtmChannel value) {
    _channel = value;
    notifyListeners();
  }

  String _userId;
  String get userId => _userId;
  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;
  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  bool _isInChannel = false;
  bool get isInChannel => _isInChannel;
  set isInChannel(bool value) {
    _isInChannel = value;
    notifyListeners();
  }

  RtmController()
      : _db = DatabaseService(),
        _aut = AuthController.shared {
    _createClient(_aut.user.uid);
  }
  void _createClient(String uid) async {
    _client = await AgoraRtmClient.createInstance(APP_ID);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log("viene msg de: " + peerId + ", msg: " + message.text);
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      _log('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client.logout();
        _log('Logout.');
        _isLogin = false;
        notifyListeners();
      }
    };
    await _client.login(null, uid);
    print("me loguee en el channel con: $uid");
  }

  enviarMensajePersonal(String id, String msg) async {
    AgoraRtmMessage message = AgoraRtmMessage.fromText(msg);
    await _client.sendMessageToPeer(id, message, false);
  }

  enviarMensajeGrupal(String msg) async {
    var string = [
      {"dx": 124.36, "dy": 124.36},
      {"dx": 126.18, "dy": 126.18},
      {"dx": 129.82, "dy": 129.82},
      {"dx": 132.36, "dy": 132.36},
      {"dx": 138.18, "dy": 138.18},
      {"dx": 140.36, "dy": 140.36},
      {"dx": 143.27, "dy": 143.27},
      {"dx": 145.09, "dy": 145.09},
      {"dx": 145.82, "dy": 145.82},
      {"dx": 147.64, "dy": 147.64},
      {"dx": 148.73, "dy": 148.73},
      {"dx": 149.45, "dy": 149.45},
      {"dx": 149.45, "dy": 149.45},
      {"dx": 149.45, "dy": 149.45},
      {"dx": 149.45, "dy": 149.45},
      {"dx": 149.82, "dy": 149.82},
      {"dx": 150.55, "dy": 150.55}
    ];
    AgoraRtmMessage message = AgoraRtmMessage.fromText(string.toString());

    await _channel.sendMessage(message);
  }

  getIntegrantes() async {
    members = await _channel.getMembers();
  }

  salirSala(Sala sala) async {
    await _channel.leave();
   // await _client.releaseChannel(_channel.channelId);
    
   await _db.saliSala(sala, _aut.user.uid);
  }

  Future<bool> ingresarSala(Sala sala) async {
    await _createChannel(sala.channelName);
     await _channel.join();
    await _db.ingreseSala(sala, _aut.user.uid);
    return true;
  }

  Future<bool> _createChannel(String name) async {
    _channel = await _client.createChannel(name);
    _channel.onMemberJoined = (AgoraRtmMember member) {
      _log(
          "Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    _channel.onMemberLeft = (AgoraRtmMember member) {
      _log("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    _channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      _log("Channel msg: " + member.userId + ", msg: " + message.text);
    };
    return true;
  }

  mensajeFilter() {
    var acumulador = [];
    var lentTemp = 0;
    var enviar = true;
    var lentToSend = 32;
    while (enviar) {
      var listPointsToSend = [];
      if (acumulador.length > lentToSend) {
        for (var i = lentTemp; i < lentTemp + lentToSend; i++) {
          listPointsToSend.add(acumulador[i]);
        }
        lentTemp = lentTemp + lentToSend;
      } else {
        for (var i = lentTemp; i < acumulador.length; i++) {
          listPointsToSend.add(acumulador[i]);
        }
        lentTemp = acumulador.length;
      }
    }
  }

  void _log(String info) {
    print(info);
    _infoStrings.insert(0, info);
  }
}
