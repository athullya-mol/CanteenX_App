import 'package:CanteenX/application/blocs/about_us/about_us_bloc.dart';
import 'package:CanteenX/application/blocs/auth/auth_bloc.dart';
import 'package:CanteenX/application/blocs/contact_us/contact_us_bloc.dart';
import 'package:CanteenX/application/blocs/privacy/privacy_bloc.dart';
import 'package:CanteenX/application/blocs/restaurants/restaurants_bloc.dart';
import 'package:CanteenX/application/blocs/sign_in/sign_in_bloc.dart';
import 'package:CanteenX/application/blocs/sign_up/sign_up_bloc.dart';
import 'package:CanteenX/application/blocs/tags/tags_bloc.dart';
import 'package:CanteenX/application/blocs/terms/terms_bloc.dart';
import 'package:CanteenX/application/blocs/user/user_bloc.dart';
import 'package:CanteenX/application/cubits/add_reservation/add_reservation_cubit.dart';
import 'package:CanteenX/application/cubits/cart/cart_cubit.dart';
import 'package:CanteenX/application/cubits/connectivity/connectivity_cubit.dart';
import 'package:CanteenX/application/cubits/filter/filter_cubit.dart';
import 'package:CanteenX/application/cubits/get_orders/get_orders_cubit.dart';
import 'package:CanteenX/application/cubits/get_reservations/get_reservation_cubit.dart';
import 'package:CanteenX/application/cubits/navigation_cubit/admin_navigation_cubit.dart';
import 'package:CanteenX/application/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:CanteenX/application/cubits/payment/payment_cubit.dart';
import 'package:CanteenX/application/cubits/pickup/pickup_cubit.dart';
import 'package:CanteenX/application/cubits/place_order/place_order_cubit.dart';
import 'package:CanteenX/application/cubits/search/search_cubit.dart';
import 'package:CanteenX/application/cubits/select_tag/select_tag_cubit.dart';
import 'package:CanteenX/application/cubits/selected_tap/selected_tap_cubit.dart';
import 'package:CanteenX/repositories/about/about_repo.dart';
import 'package:CanteenX/repositories/auth_repos/auth_repo.dart';
import 'package:CanteenX/repositories/cart/cart_repo.dart';
import 'package:CanteenX/repositories/contact_us/contact_us_repo.dart';
import 'package:CanteenX/repositories/orders/orders_repo.dart';
import 'package:CanteenX/repositories/pickups/pickups_repo.dart';
import 'package:CanteenX/repositories/privacy/privacy_repo.dart';
import 'package:CanteenX/repositories/reservation/reservation_repo.dart';
import 'package:CanteenX/repositories/restaurants/restaurants_repo.dart';
import 'package:CanteenX/repositories/terms/terms_repo.dart';
import 'package:CanteenX/repositories/user_repos/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
              firebaseAuth: FirebaseAuth.instance,
              firestore: FirebaseFirestore.instance),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseAuth: FirebaseAuth.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(InitializeAuthEvent()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => UserBloc(
              authBloc: context.read<AuthBloc>(),
              userRepository: context.read<UserRepository>(),
            )..add(StartUserEvent()),
          ),
          BlocProvider(
            create: (context) =>
                SignUpBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => SignInBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ConnectivityCubit(),
          ),
          BlocProvider(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider(
            create: (context) => AdminNavigationCubit(),
          ),
          BlocProvider(
              lazy: false,
              create: (context) =>
                  RestaurantsBloc(restaurantsRepository: RestaurantsRepo())
                    ..add(LoadRestaurants())),
          BlocProvider(
            create: (context) => FilterCubit(
              repository: RestaurantsRepo(),
            ),
          ),
          BlocProvider(
              lazy: false,
              create: (context) =>
                  TagsBloc(restaurantsRepository: RestaurantsRepo())
                    ..add(LoadTags())),
          BlocProvider(
            create: (context) => SelectTagCubit(),
          ),
          BlocProvider(
            create: (context) => PickupCubit(
              pickupRepo: PickupsRepo(),
            ),
          ),
          BlocProvider(
            create: (context) => SearchCubit(
              repository: RestaurantsRepo(),
            ),
          ),
          BlocProvider(
            create: (context) => AddReservationCubit(
              reservationsRepository: ReservationRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => GetReservationsCubit(
              reservationsRepository: ReservationRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => CartCubit(
              CartRepository(),
            ),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => AboutUsBloc(
              AboutRepo(),
            )..add(
                GetAboutUsEvent(),
              ),
          ),
          BlocProvider(
            create: (context) => PlaceOrderCubit(
              ordersRepository: OrdersRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => PaymentCubit(),
          ),
          BlocProvider(
            create: (context) => GetOrdersCubit(
              ordersRepository: OrdersRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => SelectedTapCubit(),
          ),
          BlocProvider(
            create: (context) => TermsBloc(
              TermsRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => PrivacyBloc(
              PrivacyRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => ContactUsBloc(
              ContactUsRepository(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'CanteenX',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: AppRouter.splash,
          theme: ThemeData(
            fontFamily: AppStrings.fontFamily,
            dialogTheme: const DialogTheme(
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
