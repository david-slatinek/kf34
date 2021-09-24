class Data {
  int idData = -999;
  String capture = '';
  double value = -999;
  int? fkDevice = -999;

  Data(
      {required this.idData,
      required this.capture,
      required this.value,
      required this.fkDevice});

  @override
  String toString() {
    return 'Data{idData: $idData, capture: $capture, value: $value, fkDevice: $fkDevice}';
  }

  static Data fromJson(Map<String, dynamic> json) {
    return Data(
        idData: int.parse(json['id_data']),
        capture: json['capture'],
        value: json['value'] ?? -1,
        fkDevice: json['fk_device']);
  }
}
