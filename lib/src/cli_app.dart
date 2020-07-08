// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

// 🌎 Project imports:
import 'package:temptrail/src/any_bar_color.dart';
import 'package:temptrail/src/colors.dart';
import 'package:temptrail/src/config.dart';
import 'package:temptrail/src/logging.dart';
import 'package:temptrail/src/system_service.dart';

@immutable
class CliApp {
  CliApp(this._config) : _systemService = SystemService.fromPlatform();

  final Config _config;
  final SystemService _systemService;

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
    trace('Fetching speed limit...');
    final speedLimit = await _systemService.fetchCpuSpeedLimit();

    log('Speed limit: $speedLimit%');
    final color = _getAnyBarColorForSpeedLimit(speedLimit);

    log('Setting color to "${color.value}"...');
    await _systemService.setAnyBarColor(
      color: color,
      host: 'localhost',
      port: _config.port,
    );

    log('Refreshed successfully.');
    log(subtle('-----------------------'));
  }

  Future<void> run() async {
    unawaited(_refresh());
    Timer.periodic(Duration(milliseconds: _config.pollingRate), (_) {
      _refresh();
    });
  }

  @override
  String toString() => 'CliApp(config: $_config)';
}
