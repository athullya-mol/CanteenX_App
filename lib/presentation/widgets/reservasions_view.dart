import 'package:CanteenX/application/cubits/get_reservations/get_reservation_cubit.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/assets.dart';
import 'package:CanteenX/presentation/widgets/empty_screen.dart';
import 'package:CanteenX/presentation/widgets/reservation_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationsView extends StatelessWidget {
  const ReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetReservationsCubit, GetReservationsState>(
      builder: (context, state) {
        if (state is GetReservationsLoaded && state.reservations.isNotEmpty) {
          return ListView.separated(
            itemCount: state.reservations.length,
            padding: Space.all(1.5, 1),
            itemBuilder: (context, index) {
              return reservationItem(
                reservation: state.reservations[index],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Space.yf();
            },
          );
        } else if (state is GetReservationsLoaded &&
            state.reservations.isEmpty) {
          return emptyScreen(
            text: "You Don’t have any\nBookings",
            svg: AppAssets.emptyBooking,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
