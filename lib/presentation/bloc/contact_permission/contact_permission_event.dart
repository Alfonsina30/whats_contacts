part of 'contact_permission_bloc.dart';

class ContactPermissionEvent {}

class CheckPermissionEvent extends ContactPermissionEvent {
  final PermissionStatus statusPermission;
  CheckPermissionEvent({required this.statusPermission});
}

class GetContactsEvent extends ContactPermissionEvent {
  final List<ContactModel> contacts;
  GetContactsEvent({required this.contacts});
}
