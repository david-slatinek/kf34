enum DeviceType { TEMPERATURE, HUMIDITY }

extension ParseToString on DeviceType {
  String asString() {
    return toString().split('.').last;
  }
}
