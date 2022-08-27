import 'dart:collection';

import 'package:uuid/uuid.dart';

int calculationV1(int num, int duplicate) {
  var uuid = Uuid();

  final List<String> list = [];

  for (var users = 0; users < num; users++) {
    var userId = uuid.v4();

    for (var post = 0; post < duplicate; post++) {
      list.add(userId);
    }
  }

  return list.toSet().toList().length;
}

int calculationV2(int num, int duplicate) {
  var uuid = Uuid();

  final Set<String> list = {};

  for (var users = 0; users < num; users++) {
    var userId = uuid.v4();

    for (var post = 0; post < duplicate; post++) {
      list.add(userId);
    }
  }

  return list.length;
}

int calculationV3(int num, int duplicate) {
  var uuid = Uuid();

  final list = HashSet<String>();

  for (var users = 0; users < num; users++) {
    var userId = uuid.v4();

    for (var post = 0; post < duplicate; post++) {
      list.add(userId);
    }
  }

  return list.length;
}
