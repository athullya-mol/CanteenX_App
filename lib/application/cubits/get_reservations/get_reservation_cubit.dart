import 'package:CanteenX/repositories/reservation/reservation_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/models.dart';

part 'get_reservations_state.dart';

class GetReservationsCubit extends Cubit<GetReservationsState> {
  final BaseReservationsRepository reservationsRepository;

  GetReservationsCubit({required this.reservationsRepository})
      : super(GetReservationsInitial());

  void getReservations(String userId) {
    emit(GetReservationLoading());
    reservationsRepository.getReservations(userId).listen(
      (reservations) {
        emit(GetReservationsLoaded(reservations: reservations));
      },
      onError: (error) {
        emit(GetReservationsError(errorMessage: error.toString()));
      },
    );
  }
}
