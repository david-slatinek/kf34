enum DeviceType { temperature, humidity, pressure }

extension ParseToString on DeviceType {
  String asString() {
    return toString().split('.').last;
  }
}
