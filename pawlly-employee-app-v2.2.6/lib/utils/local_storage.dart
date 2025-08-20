import 'package:get_storage/get_storage.dart';

import '../../../../../../utils/library.dart';
GetStorage localStorage = GetStorage();

setValueToLocal(String key, dynamic value) {
  log('setValueToLocal : ${value.runtimeType} - $key - $value');
  localStorage.write(key, value);
}

T getValueFromLocal<T>(String key) {
  final val = localStorage.read(key);
  log("getValueFromLocal : ${val.runtimeType} - $key - $val");
  return val;
}

removeValueFromLocal(String key) {
  log("removeValueFromLocal : $key");
  localStorage.remove(key);
}
