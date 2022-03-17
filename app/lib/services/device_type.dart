enum DeviceType { temperature, humidity, pressure, heart_rate, oxygen_saturation }

extension ParseToString on DeviceType {
  String asString() {
    return toString().split('.').last.toUpperCase();
  }
}
