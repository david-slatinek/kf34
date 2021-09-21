abstract class ReturnFields {
  bool success = false;
  String? error;

  @override
  String toString() {
    return 'ReturnFields{success: $success, error: $error}';
  }
}
