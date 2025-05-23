part of 'contact_permission_bloc.dart';

class ContactPermissionState extends Equatable {
  final PermissionStatus statusPermission;
  final List<Contact> contacts;

  const ContactPermissionState(
      {required this.statusPermission, required this.contacts});

  bool get isPermisionGranted => statusPermission == PermissionStatus.granted;

  ContactPermissionState copyWith({
    PermissionStatus? statusPermission,
    List<Contact>? contacts,
  }) {
    return ContactPermissionState(
        statusPermission: statusPermission ?? this.statusPermission,
        contacts: contacts ?? this.contacts);
  }

  @override
  List<Object?> get props => [statusPermission, contacts];
}
