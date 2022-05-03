enum DeviceType {
  body_temperature,
  heart_rate,
  oxygen_saturation,
  temperature,
  humidity,
  // pressure
}

extension ParseToString on DeviceType {
  String asString() {
    return toString().split('.').last.toUpperCase();
  }
}
