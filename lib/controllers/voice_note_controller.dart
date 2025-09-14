import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceNoteController {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _recorderInitialized = false;
  bool _playerInitialized = false;

  String? recordedFilePath;

  Future<void> init() async {
    if (!_recorderInitialized) {
      await _recorder.openRecorder();
      _recorderInitialized = true;
    }
    if (!_playerInitialized) {
      await _player.openPlayer();
      _playerInitialized = true;
    }
  }

  Future<void> dispose() async {
    if (_recorderInitialized) {
      await _recorder.closeRecorder();
      _recorderInitialized = false;
    }
    if (_playerInitialized) {
      await _player.closePlayer();
      _playerInitialized = false;
    }
  }

  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission denied');
    }

    final path = '/flutter_sound_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );
    recordedFilePath = path;
  }

  Future<String?> stopRecording() async {
    if (!_recorder.isRecording) return null;
    final path = await _recorder.stopRecorder();
    recordedFilePath = path;
    return path;
  }

  Future<void> play(String path) async {
    if (!_player.isPlaying) {
      await _player.startPlayer(fromURI: path);
    }
  }

  Future<void> stopPlayer() async {
    if (_player.isPlaying) {
      await _player.stopPlayer();
    }
  }
}
