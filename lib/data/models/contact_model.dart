import 'package:whats_contacts/domain/entities/contact.dart';

class ContactModel extends Contact {
  ContactModel({required super.name, required super.phone});

  factory ContactModel.fromJson(Map<Object?, Object?> map) {
    return ContactModel(
        name: map['name'] as String, phone: map['phone'] as String);
  }
}
