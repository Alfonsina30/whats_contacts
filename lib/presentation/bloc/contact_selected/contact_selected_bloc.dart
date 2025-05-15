import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whats_contacts/domain/model/contact_model.dart';
part 'contact_selected_event.dart';
part 'contact_selected_state.dart';

class ContactSelectedBloc
    extends Bloc<HandleContactSelectedEvent, ContactSelectedState> {
  ContactSelectedBloc() : super(ContactSelectedState(contactSelected: [])) {
    on<ContactSelectedEvent>((event, emit)=>   emit(event.newState));
    on<DeleteContactSelectedEvent>((event, emit)=>   emit(event.newState));
  }

  void handleContactSelected(ContactModel contact) {
    final newState = <ContactModel>[...state.contactSelected];

    if (!newState.any((item) => item.name.contains(contact.name))) {
      newState.add(contact);
    } else {
      newState.removeWhere((item) => item.name == contact.name);
    }
    add(ContactSelectedEvent(newState: state.copyWith(contactSelected: newState)));
  }

  void deleteContactSelected(ContactModel contact) {
    final newState = <ContactModel>[...state.contactSelected];
    newState.removeWhere((item) => item.name == contact.name);
    add(DeleteContactSelectedEvent(newState: state.copyWith(contactSelected: newState)));
  }
}
