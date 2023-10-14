String formatSeconds(int seconds) {
  // Calculate minutes and seconds
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;

  // Convert to "MM:SS" format
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = remainingSeconds.toString().padLeft(2, '0');

  return '$minutesStr:$secondsStr';
}
