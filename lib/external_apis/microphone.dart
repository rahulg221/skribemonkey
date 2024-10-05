import 'package:flutter_sound/flutter_sound.dart';


FlutterSoundRecorder recorder = FlutterSoundRecorder();
bool is_recording = false;
String out_file = "";


// Start recording audio
Future<void> startRecording(String filePath) async {
  out_file = filePath; // File outputs as an .ogg file

  await recorder.openRecorder();
  await recorder.startRecorder(
    toFile: out_file,
    codec: Codec.opusOGG, 
  );
  is_recording = true;
}

// End recording audio
Future<void> stopRecording() async {
  await recorder.stopRecorder();
  is_recording = false;
  await recorder.closeRecorder();
}
