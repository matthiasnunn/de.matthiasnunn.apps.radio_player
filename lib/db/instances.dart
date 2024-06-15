import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:radio_player/models/instance.dart';


class Instances {

  static const _instances = "instances";
  static const _lastInstance = "lastInstance";

  static const _storage = FlutterSecureStorage();

  static Future<void> deleteInstance(Instance instance) async {
    final instances = await getInstances();
          instances.remove(instance);
    final jsonString = json.encode(instances);
    await _storage.write(key: _instances, value: jsonString);
  }

  static Future<List<Instance>> getInstances() async {
    final string = await _storage.read(key: _instances);
    if (string == null) {
      return [];
    }
    final jsonString = json.decode(string) as List<dynamic>;
    return jsonString.map((dynamic element) {
      return Instance.fromJson(element);
    }).toList();
  }

  static Future<void> setInstances(Instance instance) async {
    final instances = await getInstances();
          instances.add(instance);
    final jsonString = json.encode(instances);
    await _storage.write(key: _instances, value: jsonString);
  }

  static Future<Instance?> getLastInstance() async {
    final string = await _storage.read(key: _lastInstance);
    if (string == null) {
      return null;
    }
    final jsonString = json.decode(string);
    return Instance.fromJson(jsonString);
  }

  static Future<void> setLastInstance(Instance? instance) async {
    final jsonStringOrNull = (instance == null) ? null : json.encode(instance);
    await _storage.write(key: _lastInstance, value: jsonStringOrNull);
  }
}
