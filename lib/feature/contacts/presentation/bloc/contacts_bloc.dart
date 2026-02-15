import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:books_discovery_app/feature/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_event.dart';
import 'package:books_discovery_app/feature/contacts/presentation/bloc/contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetContactsUseCase getContactsUseCase;

  ContactsBloc({required this.getContactsUseCase}) : super(ContactsInitial()) {
    on<RequestContactsPermission>(_onRequestPermission);
    on<FetchContacts>(_onFetchContacts);
  }

  Future<void> _onRequestPermission(
    RequestContactsPermission event,
    Emitter<ContactsState> emit,
  ) async {
    emit(ContactsLoading()); 
    try {
      bool granted = await FlutterContacts.requestPermission(readonly: true);

      if (granted) {
        add(FetchContacts());
      } else {
        emit(ContactsPermissionDenied());
      }
    } catch (e) {
      emit(ContactsError("Permission error: ${e.toString()}"));
    }
  }

  Future<void> _onFetchContacts(
    FetchContacts event,
    Emitter<ContactsState> emit,
  ) async {
    emit(ContactsLoading());
    try {
      final contacts = await getContactsUseCase.execute();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ContactsError("Fetch error: ${e.toString()}"));
    }
  }
}
