import 'dart:isolate';

import 'package:dart_hyperloglog/hyperloglog.dart';
import 'package:uuid/uuid.dart';

int calculationV1(int num, int duplicate) {
  var uuid = Uuid();

  final hyperloglog = HyperLogLog(0.01);

  for (var users = 0; users < num; users++) {
    var userId = uuid.v4();

    for (var post = 0; post < duplicate; post++) {
      hyperloglog.add(userId);
    }
  }

  return hyperloglog.count();
}

Future<int> calculationV2(int num, int duplicate) async {
  final hyperLogLogMaps = await Future.wait([
    _fillHyperLogLogMap(num ~/ 6, duplicate),
    _fillHyperLogLogMap(num ~/ 6, duplicate),
    _fillHyperLogLogMap(num ~/ 6, duplicate),
    _fillHyperLogLogMap(num ~/ 6, duplicate),
    _fillHyperLogLogMap(num ~/ 6, duplicate),
    _fillHyperLogLogMap(num ~/ 6, duplicate),
  ]);

  final hyperLogLog = hyperLogLogMaps.first;
  hyperLogLog.merge(hyperLogLogMaps[1]);
  hyperLogLog.merge(hyperLogLogMaps[2]);
  hyperLogLog.merge(hyperLogLogMaps[3]);
  hyperLogLog.merge(hyperLogLogMaps[4]);
  hyperLogLog.merge(hyperLogLogMaps[5]);

  return hyperLogLog.count();
}

Future<HyperLogLog> _fillHyperLogLogMap(int num, int duplicate) async {
  final receivePort = ReceivePort();
  final requiredArgs = RequiredArgs(num, duplicate, receivePort.sendPort);

  await Isolate.spawn(_init, requiredArgs);

  return await receivePort.first;
}

Future<void> _init(RequiredArgs requiredArgs) async {
  final SendPort sendPort = requiredArgs.sendPort;

  var uuid = Uuid();

  final hyperloglog = HyperLogLog(0.01);

  for (var users = 0; users < requiredArgs.num; users++) {
    var userId = uuid.v4();

    for (var post = 0; post < requiredArgs.duplicate; post++) {
      hyperloglog.add(userId);
    }
  }

  sendPort.send(hyperloglog);
}

class RequiredArgs {
  final int num;
  final int duplicate;
  final SendPort sendPort;

  RequiredArgs(this.num, this.duplicate, this.sendPort);
}
