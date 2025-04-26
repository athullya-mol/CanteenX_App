import 'package:CanteenX/core/enums/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminNavigationCubit extends Cubit<AdminNavigationTab> {
  AdminNavigationCubit() : super(AdminNavigationTab.addMenu);

  void updateTab(AdminNavigationTab tab) => emit(tab);
}
