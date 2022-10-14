
// ignore_for_file: file_names

class HttpException implements Exception {
  String errorMessage;

  HttpException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}
