import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:encontraste/models/persona.dart';
import 'package:encontraste/models/sala.dart';
import 'package:encontraste/services/database_service.dart';
import 'package:encontraste/utils/settings.dart';
import 'package:flutter/cupertino.dart';

import 'auth_controller.dart';

enum VOICES { off, oldman, babyBoy, babyGirl, zhubajie, ethereal, hulk }

class RtmController with ChangeNotifier {
  AuthController _aut;
  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  StreamController<String> streamMensajes = StreamController.broadcast();
  DatabaseService _db;
  Sala isSala;
  Persona isPersona;
  final _infoStrings = <String>[];

  bool _isLogin = false;
  bool get isLogin => _isLogin;
  set isLogin(bool value) {
    _isLogin = value;
    //notifyListeners();
  }

  bool _isInChannel = false;
  bool get isInChannel => _isInChannel;
  set isInChannel(bool value) {
    _isInChannel = value;
    //notifyListeners();
  }

  List<AgoraRtmMember> _members;
  List<AgoraRtmMember> get members => _members;
  set members(List<AgoraRtmMember> value) {
    _members = value;
    notifyListeners();
  }

  String _userId;
  String get userId => _userId;
  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  AgoraRtmChannel get channel => _channel;
  set channel(AgoraRtmChannel value) {
    _channel = value;
    notifyListeners();
  }

  void joinRoom(
      {bool video = true,
      bool audio = true,
      bool mensajes = true,
      @required Sala sala,
      @required Persona persona}) async {
    isSala = sala;
    isPersona = persona;
    video ? AgoraRtcEngine.enableVideo() : AgoraRtcEngine.disableVideo();
    audio ? AgoraRtcEngine.enableAudio() : AgoraRtcEngine.disableAudio();
    AgoraRtcEngine.setChannelProfile(ChannelProfile.Communication);
    VideoEncoderConfiguration config = VideoEncoderConfiguration();
    config.orientationMode = VideoOutputOrientationMode.FixedPortrait;
    AgoraRtcEngine.setVideoEncoderConfiguration(config);

    AgoraRtcEngine.startPreview();
    AgoraRtcEngine.joinChannel(null, sala.channelName, null, 0);
    isInChannel = true;

    if (mensajes) {
      _client.login(null, _aut.user.uid);
      _channel = await _client.createChannel(sala.channelName);
      isLogin = true;
    }
    _addChannelRtmEvent();
    _addChannelRtcEvent();
    _db.ingreseSala(sala, _aut.user.uid);
  }

  void leftRoom()  {
    if (isInChannel) {
      AgoraRtcEngine.leaveChannel();
      AgoraRtcEngine.stopPreview();
      isInChannel = false;
    }
    if (isLogin) {
      _client.logout();
      isLogin = true;
    }
     _db.saliSala(isSala, _aut.user.uid);
  }

  RtmController()
      : _db = DatabaseService(),
        _aut = AuthController.shared {
    print("instancia de rtm");
    init();
  }

  init() async {
    AgoraRtcEngine.create(APP_ID);
    _client = await AgoraRtmClient.createInstance(APP_ID);
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log("Peer msg: " + peerId + ", msg: " + message.text);
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
      }
    };
  }

  changeVoice(VOICES voice) {
    switch (voice) {
      case VOICES.off:
        AgoraRtcEngine.setLocalVoiceChanger(VoiceChanger.VOICE_CHANGER_OFF);
        break;
      case VOICES.babyBoy:
        AgoraRtcEngine.setLocalVoiceChanger(VoiceChanger.VOICE_CHANGER_BABYBOY);
        break;
      case VOICES.babyGirl:
        AgoraRtcEngine.setLocalVoiceChanger(
            VoiceChanger.VOICE_CHANGER_BABYGILR);
        break;
      case VOICES.ethereal:
        AgoraRtcEngine.setLocalVoiceChanger(
            VoiceChanger.VOICE_CHANGER_ETHEREAL);
        break;
      case VOICES.hulk:
        AgoraRtcEngine.setLocalVoiceChanger(VoiceChanger.VOICE_CHANGER_HULK);
        break;
      case VOICES.oldman:
        AgoraRtcEngine.setLocalVoiceChanger(VoiceChanger.VOICE_CHANGER_OLDMAN);
        break;
      case VOICES.zhubajie:
        AgoraRtcEngine.setLocalVoiceChanger(
            VoiceChanger.VOICE_CHANGER_ZHUBAJIE);
        break;
      default:
    }
  }

  Future<bool> _addChannelRtmEvent() async {
    _channel.onMemberJoined = (AgoraRtmMember member) {
      _log(
          "Member joined: " + member.userId + ', channel: ' + member.channelId);
    };
    _channel.onMemberLeft = (AgoraRtmMember member) {
      _log("Member left: " + member.userId + ', channel: ' + member.channelId);
    };
    _channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      streamMensajes.add("""{"user":"${member.userId}", ${message.text}}""");
    };
    return true;
  }

  void _addChannelRtcEvent() {
    AgoraRtcEngine.onVideoSizeChanged = (uid, width, height, rotation) {
      print('$uid $width $height $rotation');
    };

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
      _infoStrings.add(info);
    };

    AgoraRtcEngine.onLeaveChannel = () {
      _infoStrings.add('onLeaveChannel');
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      String info = 'userJoined: ' + uid.toString();
      _infoStrings.add(info);
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      String info = 'userOffline: ' + uid.toString();
      _infoStrings.add(info);
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      String info = 'firstRemoteVideo: ' +
          uid.toString() +
          ' ' +
          width.toString() +
          'x' +
          height.toString();
      _infoStrings.add(info);
    };
  }

  @override
  void dispose() {
    super.dispose();
    streamMensajes.close();
  }

  enviarMensajePersonal(String id, String msg) async {
    AgoraRtmMessage message = AgoraRtmMessage.fromText(msg);
    await _client.sendMessageToPeer(id, message, false);
  }

  enviarMensajeGrupal(String msg) async {
    AgoraRtmMessage message = AgoraRtmMessage.fromText(msg);
    await _channel.sendMessage(message);
  }

  getIntegrantes() async {
    members = await _channel.getMembers();
  }

  salirSala(Sala sala) async {
    leftRoom();
  }

  Future<bool> ingresarSala(Sala sala) async {
    joinRoom(sala: sala, persona: Persona(id: _aut.user.uid));
    return true;
  }

  void _log(String info) {
    print(info);
    _infoStrings.insert(0, info);
  }
}
