import "dart:io";

import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter/foundation.dart';

class SZLogger extends Logger {
  SZLogger._internal() : super();
  static final SZLogger _instance = SZLogger._internal();
  factory SZLogger() {
    return _instance;
  }

  static final Lock _logLock = Lock();

  static Future<String> _getLogFilePath() async {
    String dir = (await getApplicationSupportDirectory()).path;
    final String logDir = path.join(dir, "logs");
    final String filename = path.join(logDir, "wrt_logs.log");
    final directory = Directory(logDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return filename;
  }

  static Future<File> getLogFile() async {
    final file = File(await _getLogFilePath());
    if (!await file.exists()) {
      await SZLogger._logLock.synchronized(() async {
        if (!await file.exists()) {
          await file.create();
        }
      });
    }
    return file;
  }

  static void clearLogs() async {
    final file = File(await _getLogFilePath());
    try {
      await SZLogger._logLock.synchronized(() async {
        await file.writeAsString("");
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void log(Level level, dynamic message,
      {Object? error, StackTrace? stackTrace, DateTime? time}) async {
    if (level == Level.error) {
      await _logLock.synchronized(() async {
        await File(await _getLogFilePath()).writeAsString(
          "**${DateTime.now()}** \n$message \n${stackTrace == null ? '' : stackTrace.toString()} \n",
          mode: FileMode.writeOnlyAppend,
        );
      });
    }
    super.log(level, "$message",
        error: error, stackTrace: level == Level.error ? stackTrace : null);
  }

  void devLog(dynamic message) {
    if (!kReleaseMode) {
      print(message);
    }
  }
}
