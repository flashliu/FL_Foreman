class CountDown {
  String day;
  String hour;
  String min;
  String sec;
  CountDown({this.day, this.hour, this.min, this.sec});

  static CountDown fromTime(DateTime time) {
    final diff = time.difference(DateTime.now());
    final day = ((diff.inSeconds ~/ 3600) ~/ 24).toString();
    final hour = ((diff.inSeconds ~/ 3600) % 24).toString();
    final min = (diff.inSeconds % 3600 ~/ 60).toString();
    final sec = (diff.inSeconds % 60).toString();
    return CountDown(
      day: int.parse(day) > 9 ? day : '0$day',
      hour: int.parse(hour) > 9 ? hour : '0$hour',
      min: int.parse(min) > 9 ? min : '0$min',
      sec: int.parse(sec) > 9 ? sec : '0$sec',
    );
  }
}
