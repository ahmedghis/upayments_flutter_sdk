import 'dart:convert';

class UPaymentsException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  UPaymentsException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'UPaymentsException($statusCode): $message';

  factory UPaymentsException.fromResponse(int statusCode, String body) {
    final parsed = _parseBody(body);
    final message = parsed['message']?.toString() ?? 'Unknown error';
    switch (statusCode) {
      case 401:
        return UPaymentsUnauthenticatedException(message,
            statusCode: statusCode, details: parsed);
      case 403:
        return UPaymentsForbiddenException(message,
            statusCode: statusCode, details: parsed);
      case 422:
        return UPaymentsValidationException(message,
            statusCode: statusCode, details: parsed);
      case 429:
        return UPaymentsRateLimitException(message,
            statusCode: statusCode, details: parsed);
      default:
        return UPaymentsException(message,
            statusCode: statusCode, details: parsed);
    }
  }

  static Map<String, dynamic> _parseBody(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map<String, dynamic>) {
        return data;
      }
    } catch (_) {
      // ignore parse errors
    }
    return {'body': body};
  }
}

class UPaymentsUnauthenticatedException extends UPaymentsException {
  UPaymentsUnauthenticatedException(super.message,
      {super.statusCode, super.details});
}

class UPaymentsForbiddenException extends UPaymentsException {
  UPaymentsForbiddenException(super.message,
      {super.statusCode, super.details});
}

class UPaymentsValidationException extends UPaymentsException {
  UPaymentsValidationException(super.message,
      {super.statusCode, super.details});
}

class UPaymentsRateLimitException extends UPaymentsException {
  UPaymentsRateLimitException(super.message,
      {super.statusCode, super.details});
}
