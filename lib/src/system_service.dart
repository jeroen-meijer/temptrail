import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:temptrail/src/any_bar_color.dart';
import 'package:temptrail/src/logging.dart';
import 'package:temptrail/temptrail.dart';

abstract class SystemService {
  const SystemService(
    this.anyBarHost,
    this.anyBarPort,
  );

  factory SystemService.fromPlatform({
    @required String anyBarHost,
    @required String anyBarPort,
  }) {
    assert(anyBarHost != null);
    assert(anyBarPort != null);

    trace(
      'Fetching SystemService with anyBarHost "$anyBarHost" '
      'and anyBarPort "$anyBarPort"'
      'for platform ${Platform.operatingSystem}...',
    );
    if (Platform.isMacOS) {
      trace(
        '$_MacSystemService found '
        'for platform ${Platform.operatingSystem}.',
      );
      return _MacSystemService(anyBarHost, anyBarPort);
    }

    trace('No SystemService found for platform ${Platform.operatingSystem}.');
    throw UnimplementedError(
      '$appName does not support ${Platform.operatingSystem}.',
    );
  }

  final String anyBarHost;
  final String anyBarPort;

  Future<int> fetchCpuSpeedLimit();
  Future<void> setAnyBarColor(AnyBarColor color);
}

class _MacSystemService extends SystemService {
  const _MacSystemService(
    String anyBarHost,
    String anyBarPort,
  ) : super(anyBarHost, anyBarPort);

  @override
  Future<int> fetchCpuSpeedLimit() async {
    trace('Running fetchCpuSpeedLimit');

    const command = 'pmset';
    const args = ['-g', 'therm'];
    const lineTarget = 'CPU_Speed_Limit';

    try {
      trace('Running command "$command" with args [${args.join(', ')}]');
      final process = await Process.start(command, args);
      final output = await process.stdout
          .transform(utf8.decoder)
          .first
          .timeout(const Duration(seconds: 5));
      process.kill(ProcessSignal.sigabrt);

      trace('Output received: $output');
      final lines = output.split('\n');

      final dataLine = lines.firstWhere(
        (line) => line.contains(lineTarget),
        orElse: () => null,
      );

      if (dataLine == null) {
        trace('Line with data not found.');
        throw SystemServiceException.commandFailure(
          command,
          args: args,
          exception: 'Required data cannot be found in command output.',
        );
      }

      final trimmedDataLine = dataLine.trim().replaceAll(' ', '');
      final rawSpeedLimit =
          trimmedDataLine.substring(trimmedDataLine.indexOf('=') + 1);

      trace('Raw speed limit: "$rawSpeedLimit"');
      final speedLimit = int.tryParse(rawSpeedLimit);
      if (speedLimit == null) {
        throw SystemServiceException.commandFailure(
          command,
          args: args,
          exception: 'Speed limit "$rawSpeedLimit" could not be parsed.',
        );
      }

      trace('Resulting speed limit: $speedLimit');

      return speedLimit;
    } catch (e) {
      if (e is SystemServiceException) {
        rethrow;
      }

      throw SystemServiceException.commandFailure(
        command,
        args: args,
        exception: e,
      );
    }
  }

  @override
  Future<void> setAnyBarColor(AnyBarColor color) async {
    trace('Running setAnyBarColor with color $color');

    const script = './set_color.sh';
    final args = [color.value];

    try {
      trace('Running script "$script" with args [${args.join(', ')}]');
      await Process.run(
        script,
        args,
        workingDirectory: Directory.current.path,
      );
    } catch (e) {
      if (e is SystemServiceException) {
        rethrow;
      }

      throw SystemServiceException.scriptFailure(script, exception: e);
    }
  }
}

class SystemServiceException implements Exception {
  SystemServiceException.commandFailure(
    String command, {
    List<String> args,
    this.exception,
  }) : message = 'The command "$command' +
            (args?.isEmpty ?? true ? '' : ' ${args.join(' ')}') +
            '" failed to run.';

  SystemServiceException.scriptFailure(
    String script, {
    this.exception,
  }) : message = 'The script "$script" failed to run.';

  final String message;
  final Object exception;

  @override
  String toString() => 'SystemServiceException('
      'message: $message, '
      'exception: $exception'
      ')';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SystemServiceException &&
        other.message == message &&
        other.exception == exception;
  }

  @override
  int get hashCode => message.hashCode ^ exception.hashCode;
}
