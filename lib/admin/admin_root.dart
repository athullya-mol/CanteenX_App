import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garcon/admin/addfoodmenuscreen.dart';
import 'package:garcon/admin/customerorderlistscreen.dart';
import 'package:garcon/admin/deletemenuscreen.dart';
import 'package:garcon/admin/salesreportscreen.dart';
import 'package:garcon/application/cubits/navigation_cubit/admin_navigation_cubit.dart';
import 'package:garcon/configs/configs.dart';
import 'package:garcon/core/core.dart';

class AdminRootScreen extends StatefulWidget {
  const AdminRootScreen({
    super.key,
    this.fromRout,
  });

  final String? fromRout;

  @override
  State<AdminRootScreen> createState() => _AdminRootScreenState();
}

class _AdminRootScreenState extends State<AdminRootScreen> {
  @override
  void initState() {
    if (widget.fromRout == "orders") {
      context
          .read<AdminNavigationCubit>()
          .updateTab(AdminNavigationTab.customerOrders);
      // context.read<SelectedTapCubit>().updateIndex(1);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AdminNavigationCubit, AdminNavigationTab>(
          builder: (context, activeTab) {
            switch (activeTab) {
              case AdminNavigationTab.addMenu:
                return const AddFoodMenuScreen();
              case AdminNavigationTab.deleteMenu:
                return const DeleteMenuScreen();
              case AdminNavigationTab.customerOrders:
                return const CustomerOrderListScreen();
              case AdminNavigationTab.salesReports:
                return const SalesReportScreen();
            }
          },
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<AdminNavigationCubit, AdminNavigationTab>(
        builder: (context, activeTab) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.home),
                label: 'Add Menu',
                activeIcon: SvgPicture.asset(
                  AppAssets.home,
                  colorFilter: const ColorFilter.mode(
                      AppColors.deepRed, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.reservations),
                label: 'Delete Menu',
                activeIcon: SvgPicture.asset(
                  AppAssets.reservations,
                  colorFilter: const ColorFilter.mode(
                      AppColors.deepRed, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.account),
                label: 'Orders',
                activeIcon: SvgPicture.asset(
                  AppAssets.account,
                  colorFilter: const ColorFilter.mode(
                      AppColors.deepRed, BlendMode.srcIn),
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.settings),
                label: 'Reports',
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
              final newTab = AdminNavigationTab.values[index];
              context.read<AdminNavigationCubit>().updateTab(newTab);
            },
          );
        },
      ),
    );
  }
}
