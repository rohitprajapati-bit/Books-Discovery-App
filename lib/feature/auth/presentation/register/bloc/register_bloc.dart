import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_usecase.dart';
import '../../bloc/auth_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  final AuthBloc authBloc;

  RegisterBloc({required this.registerUseCase, required this.authBloc})
    : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final result = await registerUseCase(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      emit(RegisterSuccess(result));
      authBloc.add(AuthCheckRequested());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
