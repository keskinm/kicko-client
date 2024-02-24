import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel currentLevel = LogLevel.debug;

  static void setLogLevel(LogLevel level) {
    currentLevel = level;
  }

  static void log(String message, LogLevel level) {
    if (level.index >= currentLevel.index) {
      debugPrint(
          '[${level.toString().split('.').last.toUpperCase()}] $message');
    }
  }
}
