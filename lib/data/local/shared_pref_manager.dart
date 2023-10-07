import 'dart:convert';
import 'package:flamingo/shared/shared.dart';
import 'package:flamingo/data/local/local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager implements LocalStorageClient {
  final SharedPreferences _sharedPref;

  SharedPrefManager({required SharedPreferences sharedPref})
      : _sharedPref = sharedPref;

  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _sharedPref.containsKey(key);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _sharedPref.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _sharedPref.setBool(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    return _sharedPref.getDouble(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _sharedPref.setDouble(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _sharedPref.getInt(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _sharedPref.setInt(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPref.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _sharedPref.setString(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _sharedPref.getStringList(key);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    await _sharedPref.setStringList(key, value);
  }

  @override
  Future<Obj?> getObject<Obj>(
      String key, Obj Function(dynamic json) fromJsonFn) async {
    final value = _sharedPref.getString(key);
    if (value == null) return null;

    try {
      return fromJsonFn(jsonDecode(value));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setObject<Obj extends JsonSerializable>(
      String key, Obj value) async {
    final jsonString = jsonEncode(value.toJson());

    await _sharedPref.setString(key, jsonString);
  }

  @override
  Future<bool> remove(String key) async {
    return await _sharedPref.remove(key);
  }
}
