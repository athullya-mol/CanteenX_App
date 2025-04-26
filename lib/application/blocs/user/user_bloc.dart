import 'dart:async';
import 'dart:developer';
import 'package:CanteenX/application/blocs/auth/auth_bloc.dart';
import 'package:CanteenX/models/user.dart';
import 'package:CanteenX/repositories/user_repos/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late final StreamSubscription _authSubscription;
  StreamSubscription? _userSubscription;
  final AuthBloc authBloc;
  final BaseUserRepository userRepository;

  UserBloc({required this.authBloc, required this.userRepository})
      : super(UserState.initial()) {
    on<StartUserEvent>(_onStartUser);
    on<GetUserEvent>(_onGetUser);
    on<UserChangedEvent>(_oUserChanged);
    on<UpdateUserEvent>(_onUpdateUser);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _userSubscription?.cancel();
    _userSubscription = null;
    return super.close();
  }

  void _onStartUser(StartUserEvent event, Emitter<UserState> emit) {
    _authSubscription = authBloc.stream.listen((AuthState authState) {
      if (authState.status == AuthStatus.authenticated) {
        add(GetUserEvent(id: authState.user!.uid));
      }
    });
  }

  void _onGetUser(GetUserEvent event, Emitter<UserState> emit) {
    _userSubscription =
        userRepository.getUser(event.id).listen((CurrentUser user) {
      log(user.email);
      add(UserChangedEvent(user: user));
    });
  }

  void _oUserChanged(UserChangedEvent event, Emitter<UserState> emit) {
    emit(state.copyWith(user: event.user));
  }

  void _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.updateUser(
          updatedUser: event.updatedUser,
          //  currentUser: event.currentUser,
          userId: event.userId);
      // Emit UserChangedEvent to refresh the UI
      add(UserChangedEvent(user: event.updatedUser));
    } catch (e) {
      log('Error updating user: $e');
      // Handle any errors that may occur during the update
      emit(state.copyWith(error: e.toString())); // Emit error state
    }
  }

  void _onChangePassword(
      ChangePasswordEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.changePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword);
      // No need to emit a specific event for password change, but you can
      // optionally emit a success state for feedback if needed
    } catch (e) {
      log('Error changing password: $e');
      emit(state.copyWith(error: e.toString())); // Emit error state
    }
  }
}
