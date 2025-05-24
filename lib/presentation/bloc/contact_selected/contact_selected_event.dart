part of 'contact_selected_bloc.dart';

sealed class HandleContactSelectedEvent {
  //
  final ContactSelectedState newState;
  HandleContactSelectedEvent({required this.newState});
}

class ContactSelectedEvent extends HandleContactSelectedEvent {
  ContactSelectedEvent({required super.newState});
}

class DeleteContactSelectedEvent extends HandleContactSelectedEvent {
  DeleteContactSelectedEvent({required super.newState});
}
