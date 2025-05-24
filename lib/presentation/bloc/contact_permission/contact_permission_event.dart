part of 'contact_permission_bloc.dart';

sealed class ContactPermissionEvent {}

class CheckPermissionEvent extends ContactPermissionEvent {
  final PermissionStatus statusPermission;
  CheckPermissionEvent({required this.statusPermission});
}

class GetContactsEvent extends ContactPermissionEvent {
  final List<Contact> contacts;
  GetContactsEvent({required this.contacts});
}
