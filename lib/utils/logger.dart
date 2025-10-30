import "dart:io";

import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter/foundation.dart';

class Applogger extends Logger {
  Applogger._internal() : super();
  static final Applogger _instance = Applogger._internal();
  factory Applogger() {
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
      await Applogger._logLock.synchronized(() async {
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
      await Applogger._logLock.synchronized(() async {
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
