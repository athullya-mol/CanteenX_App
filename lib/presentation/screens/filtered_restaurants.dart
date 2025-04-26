import 'package:CanteenX/application/cubits/filter/filter_cubit.dart';
import 'package:CanteenX/application/cubits/select_tag/select_tag_cubit.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/presentation/widgets/custom_appbar.dart';
import 'package:CanteenX/presentation/widgets/vertical_restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CanteenX/core/extensions/extensions.dart';

class FilteredRestaurantsScreen extends StatelessWidget {
  const FilteredRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectTagCubit, SelectTagState>(
      builder: (context, selectedState) {
        return Scaffold(
          appBar: customAppBar(
              context: context,
              title: (selectedState.selectedTag == null)
                  ? ""
                  : StringCapitalizeExtension(selectedState.selectedTag!.name)
                      .capitalize()),
          body: BlocBuilder<FilterCubit, FilterState>(
            builder: (context, state) {
              if (state.filteredRestaurants.isEmpty) {
                return const Center(
                  child: Text("No Matches Found"),
                );
              } else {
                return ListView.builder(
                    padding: Space.v2,
                    itemCount: state.filteredRestaurants.length,
                    itemBuilder: (context, index) {
                      return verticalRestaurantItem(
                          state.filteredRestaurants[index], context);
                    });
              }
            },
          ),
        );
      },
    );
  }
}
