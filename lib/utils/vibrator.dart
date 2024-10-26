import 'package:vibration/vibration.dart';

void callVibration() async {
  if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 50, amplitude: 64);
  } else {
    Vibration.vibrate(duration: 50);
  }
}
