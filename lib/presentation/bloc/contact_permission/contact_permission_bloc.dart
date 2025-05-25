import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';

import 'package:whats_contacts/data/data_files.dart';
import 'package:whats_contacts/domain/entities/contact.dart';

part 'contact_permission_event.dart';
part 'contact_permission_state.dart';

enum PermissionStatus { granted, denied }

class ContactPermissionBloc
    extends Bloc<ContactPermissionEvent, ContactPermissionState> {
  ///
  final ConnectionWithMethChannel connectionWithMethChannel;

  ContactPermissionBloc({required this.connectionWithMethChannel})
      : super(ContactPermissionState(
            contacts: [], statusPermission: PermissionStatus.denied)) {
    ///
    on<CheckPermissionEvent>((event, emit) =>
        emit(state.copyWith(statusPermission: event.statusPermission)));
    on<GetContactsEvent>(
        (event, emit) => emit(state.copyWith(contacts: event.contacts)));
  }

  Future<void> checkPermission() async {
    final status = await connectionWithMethChannel.checkPermission()
        ? PermissionStatus.granted
        : PermissionStatus.denied;
    //
    add(CheckPermissionEvent(statusPermission: status));

    if (status == PermissionStatus.granted) {
      await _getContactsList();
    }
  }

  Future<List<Contact>> requestContactPermission() async {
    final contacts = await _getContactsList();

    ///
    final status = await connectionWithMethChannel.checkPermission()
        ? PermissionStatus.granted
        : PermissionStatus.denied;

    add(CheckPermissionEvent(statusPermission: status));

    ///
    return contacts;
  }

  Future<List<Contact>> _getContactsList() async {
    try {
      final contacts = await connectionWithMethChannel.getContacts();
      add(GetContactsEvent(contacts: contacts));
      //
      return contacts;
    } catch (e) {
      ///
      log('CATCH CONTACT LIST $e');

      throw Exception(['An unknown exception ocurred']);
    }
  }
}
