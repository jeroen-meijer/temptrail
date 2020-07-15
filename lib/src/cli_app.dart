import 'dart:async';
import 'dart:io' as io;
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';
import 'package:temptrail/src/any_bar_color.dart';
import 'package:temptrail/src/config.dart';
import 'package:temptrail/src/logging.dart';
import 'package:temptrail/src/system_service.dart';

@immutable
class CliApp {
  CliApp(this._config) : _systemService = SystemService.fromPlatform();

  final Config _config;
  final SystemService _systemService;

  StreamSubscription<io.ProcessSignal> _exitSignalStreamSubscription;

  AnyBarColor _getAnyBarColorForSpeedLimit(int speedLimit) {
    const limitColors = <int, AnyBarColor>{
      100: AnyBarColor.blue,
      90: AnyBarColor.green,
      80: AnyBarColor.yellow,
      60: AnyBarColor.orange,
      50: AnyBarColor.red,
      35: AnyBarColor.exclamation,
    };

    for (final limitColor in limitColors.entries) {
      if (speedLimit >= limitColor.key) {
        return limitColor.value;
      }
    }

    return AnyBarColor.question;
  }

  Future<void> _refresh() async {
    try {
      drawDivider();
      log(yellow('Refreshing at ${DateTime.now()}'));
      trace('Fetching speed limit...');
      final speedLimit = await _systemService.fetchCpuSpeedLimit();

      log('Speed limit: ${bold(speedLimit)}%');
      final color = _getAnyBarColorForSpeedLimit(speedLimit);

      log('Setting color to ${bold(color.value)}...');
      await _systemService.setAnyBarColor(color);

      log(green('Refreshed successfully.'));
    } catch (e) {
      log(red('Error occurred: ${bold(e)}'));

      if (_config.exitOnError) {
        log(red('Exit on error is turned on.'));
        return _quit(errorOccurred: true);
      }

      log('Ignoring and continuing...');
    } finally {}
  }

  Future<void> _quit({bool errorOccurred = false}) async {
    log(red(bold('Quitting...')));
    try {
      log(subtle('Setting AnyBar color to black...'));
      await _systemService.setAnyBarColor(AnyBarColor.black);
    } catch (e) {
      log(subtle('Setting AnyBar color failed.'));
    }
    log(bold('Bye.'));
    io.exit(errorOccurred ? 1 : 0);
  }

  Future<void> run() async {
    if (_exitSignalStreamSubscription != null) {
      await _exitSignalStreamSubscription.cancel();
    }

    _exitSignalStreamSubscription =
        io.ProcessSignal.sigint.watch().listen((event) {
      _quit();
    });

    unawaited(_refresh());
    Timer.periodic(
      Duration(milliseconds: _config.pollingRate),
      (_) {
        _refresh();
      },
    );
  }

  @override
  String toString() => 'CliApp(config: $_config)';
}
