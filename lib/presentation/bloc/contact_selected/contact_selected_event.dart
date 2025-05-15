part of 'contact_selected_bloc.dart';


sealed class ContactSelectedEvent {
  final ContactSelectedState newState;

  ContactSelectedEvent({required this.newState});
}

class ContactSelected extends ContactSelectedEvent {
  ContactSelected({required super.newState});
}
