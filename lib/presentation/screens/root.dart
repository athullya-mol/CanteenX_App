import 'package:CanteenX/application/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/core/constants/assets.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/core/enums/enums.dart';
import 'package:CanteenX/presentation/screens/account.dart';
import 'package:CanteenX/presentation/screens/home.dart';
import 'package:CanteenX/presentation/screens/reservations.dart';
import 'package:CanteenX/presentation/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
    this.fromRout,
  });

  final String? fromRout;

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    if (widget.fromRout == "pickups") {
      context.read<NavigationCubit>().updateTab(NavigationTab.reservationTap);
      // context.read<SelectedTapCubit>().updateIndex(1);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<NavigationCubit, NavigationTab>(
          builder: (context, activeTab) {
            switch (activeTab) {
              case NavigationTab.homeTab:
                return const HomeScreen();
              case NavigationTab.reservationTap:
                return const ReservationScreen();
              case NavigationTab.accountTap:
                return const AccountScreen();
              case NavigationTab.settingsTab:
                return const SettingsScreen();
            }
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationTab>(
        builder: (context, activeTab) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.home),
                label: 'Home',
                activeIcon: SvgPicture.asset(
                  AppAssets.home,
                  colorFilter: const ColorFilter.mode(
                      AppColors.deepRed, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.reservations),
                label: 'Reservations',
                activeIcon: SvgPicture.asset(
                  AppAssets.reservations,
                  colorFilter: const ColorFilter.mode(
                      AppColors.deepRed, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.account),
                label: 'Account',
                activeIcon: SvgPicture.asset(
                  AppAssets.account,
                  colorFilter: const ColorFilter.mode(
                      AppColors.deepRed, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.settings),
                label: 'Settings',
                activeIcon: SvgPicture.asset(
                  AppAssets.settings,
                  colorFilter: const ColorFilter.mode(
                      AppColors.deepRed, BlendMode.srcIn),
                ),
              ),
            ],
            currentIndex: activeTab.index,
            selectedLabelStyle: AppText.b1,
            selectedItemColor: AppColors.deepRed,
            showUnselectedLabels: false,
            onTap: (index) {
              final newTab = NavigationTab.values[index];
              context.read<NavigationCubit>().updateTab(newTab);
            },
          );
        },
      ),
    );
  }
}
