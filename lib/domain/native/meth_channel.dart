import 'dart:developer';

import 'package:flutter/services.dart';
import 'dart:async';

import '../model/contact_model.dart';

class ConnectionWithMethChannel {
  final MethodChannel _methodChannel = MethodChannel("app/whatscontacts");

  Future<List<ContactModel>> getContacts() async {
    try {
      final List<dynamic> response = await _methodChannel.invokeMethod("getContacts");
      log('LOGIN RESPONSE $response');
      log('Length RESPONSE ${response.length}');

      return response.map((item) {
        return ContactModel(name: item['name'], phone: item['phone']);
      }).toList();

      //
    } catch (e) {
      log('CATCH $e');
      throw Exception();
    }
  }

  Future<bool> checkPermission() async {
    try {
      final response = await _methodChannel.invokeMethod("checkPermission");
      log('"checkPermission" $response');
      //  log('Length RESPONSE ${response.length}');

      return response;
    } catch (e) {
      throw Exception();
    }
  }
}
