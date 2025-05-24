import 'dart:async';
import 'package:flutter/services.dart';

import 'package:whats_contacts/data/data_files.dart';
import 'package:whats_contacts/domain/entities/contact.dart';

class ConnectionWithMethChannel {
  final MethodChannel _methodChannel = MethodChannel("app/whatscontacts");

  Future<bool> checkPermission() async {
    try {
      final response = await _methodChannel.invokeMethod("checkPermission");
      return response;
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<Contact>> getContacts() async {
    try {
      final List<dynamic> response =
          await _methodChannel.invokeMethod("getContacts");

      return response.map((map) {
        return ContactModel.fromJson(map);
      }).toList();

      //
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
