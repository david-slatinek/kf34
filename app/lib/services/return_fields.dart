abstract class ReturnFields {
  bool success = false;
  String? error;

  static final url = Uri.parse('https://kf34.herokuapp.com/graphql');
  static const Map<String, String> headers = {
    "X-API-Key": '',
    "Content-Type": "application/json",
  };

  @override
  String toString() {
    return 'ReturnFields{success: $success, error: $error}';
  }
}
