class Data {
  int idData;
  String capture;
  double value;
  int? fkDevice;

  Data(
      {required this.idData,
      required this.capture,
      required this.value,
      this.fkDevice});

  @override
  String toString() {
    return 'Data{idData: $idData, capture: $capture, value: $value, fkDevice: $fkDevice}';
  }

  static Data fromJson(Map<String, dynamic> json) {
    return Data(idData: int.parse(json['id_data']), capture: json['capture'], value: json['value'], fkDevice: json['fk_device']);
  }
}
