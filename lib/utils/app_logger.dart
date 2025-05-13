import 'package:logger/logger.dart';

class AppLogger {
  final Logger _logger;

  AppLogger() : _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Show 2 method calls in stack trace
      errorMethodCount: 8, // Show more methods for errors
      lineLength: 120, // Wider line length for more context
      colors: true,
      printEmojis: true,
      printTime: true, // Add timestamps to logs
    ),
  );

  // Regular debug log
  void debug(String message, [Map<String, dynamic>? extras]) {
    _logger.d(
      message,
      time: DateTime.now(),
      error: null,
      stackTrace: null,
    );
  }

  // Info log with optional context
  void info(String message, [Map<String, dynamic>? extras]) {
    _logger.i(
      message,
      time: DateTime.now(),
      error: null,
      stackTrace: null,
    );
  }

  // Warning with optional error details
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _logger.w(
      message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Enhanced error logging
  void error(
    String message, Object e, StackTrace stackTrace, {
    Object? error,
    StackTrace? trace,
    Map<String, dynamic>? extras,
    bool critical = false,
  }) {
    final errorLog = {
      'message': message,
      'error': error?.toString(),
      'type': error?.runtimeType.toString(),
      'timestamp': DateTime.now().toIso8601String(),
      'critical': critical,
      if (extras != null) ...extras,
    };

    _logger.e(
      '${critical ? '‼️ CRITICAL ' : ''}$message',
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );

    if (critical) {
      // Here you could add additional critical error handling
      // e.g., send to crash reporting service
    }
  }

  // Log network requests
  void network(
    String url, {
    String method = 'GET',
    int? statusCode,
    Object? requestBody,
    Object? response,
    int? durationMs,
  }) {
    final message = '$method $url ${statusCode != null ? '($statusCode)' : ''}';
    final extras = {
      'type': 'network',
      'method': method,
      'url': url,
      'status': statusCode,
      'duration_ms': durationMs,
      'request': requestBody?.toString(),
      'response': response?.toString(),
    };

    _logger.i(
      message,
      time: DateTime.now(),
      error: null,
      stackTrace: null,
    );
  }
}
