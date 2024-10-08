import 'package:audioplayers/audioplayers.dart';

class SoundPlayer {
  static final _audioPlayer = AudioPlayer();

  static void playSound(int soundNumber) async {
    await _audioPlayer.setSource(AssetSource('note$soundNumber.wav'));
    await _audioPlayer.resume();
  }
}
