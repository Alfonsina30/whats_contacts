import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whats_contacts/domain/native/meth_channel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';

import 'package:whats_contacts/domain/model/contact_model.dart';
part 'contact_permission_event.dart';
part 'contact_permission_state.dart';

class ContactPermissionBloc
    extends Bloc<ContactPermissionEvent, ContactPermissionState> {
  final ConnectionWithMethChannel connectionWithMethChannel;

  ContactPermissionBloc({required this.connectionWithMethChannel})
      : super(ContactPermissionState(
            contacts: [], statusPermission: PermissionStatus.denied)) {
    on<CheckPermissionEvent>((event, emit) =>
        emit(state.copyWith(statusPermission: event.statusPermission)));
    on<GetContactsEvent>(
        (event, emit) => emit(state.copyWith(contacts: event.contacts)));
  }

  Future<void> checkPermission() async {
    final status = await Permission.contacts.status;
    add(CheckPermissionEvent(statusPermission: status));
    if (status == PermissionStatus.granted) {
      await _getContactsList();
    }
  }

  Future<List<ContactModel>> requestContactPermission() async {
    final status = await Permission.contacts.request();

    if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
    if (status == PermissionStatus.granted) {
      add(CheckPermissionEvent(statusPermission: status));
      return await _getContactsList();
    }

    return [];
  }

  Future<List<ContactModel>> _getContactsList() async {
    try {
      final contacts = await connectionWithMethChannel.getContacts();
      add(GetContactsEvent(contacts: contacts));
      //
      return contacts;
    } catch (e) {
      throw Exception(['An unknown exception ocurred']);
    }
  }
}
