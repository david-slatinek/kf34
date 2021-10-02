enum DeviceType { TEMPERATURE, HUMIDITY, PRESSURE }

extension ParseToString on DeviceType {
  String asString() {
    return toString().split('.').last;
  }
}
