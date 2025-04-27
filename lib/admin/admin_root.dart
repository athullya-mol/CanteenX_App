import 'package:CanteenX/admin/addfoodmenuscreen.dart';
import 'package:CanteenX/admin/customerorderlistscreen.dart';
import 'package:CanteenX/admin/deletemenuscreen.dart';
import 'package:CanteenX/admin/salesreportscreen.dart';
import 'package:CanteenX/application/cubits/navigation_cubit/admin_navigation_cubit.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/core/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add, size: 28),
                label: 'Add Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.delete_sweep_outlined),
                label: 'Delete Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.all_inbox_rounded),
                label: 'Reports',
              ),
            ],
            currentIndex: activeTab.index,
            selectedLabelStyle: AppText.b1,
            selectedItemColor: AppColors.deepRed,
            unselectedItemColor: Colors.grey,
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
