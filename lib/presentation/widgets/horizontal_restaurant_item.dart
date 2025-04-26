import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/core/router/router.dart';
import 'package:CanteenX/models/restaurant.dart';
import 'package:CanteenX/core/extensions/extensions.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';
import 'package:flutter/material.dart';

Widget horizontalRestaurantItem(Restaurant restaurant, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRouter.restaurant, arguments: restaurant);
        },
        child: Container(
            height: AppDimensions.normalize(68),
            width: AppDimensions.normalize(94),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppDimensions.normalize(6),
              ),
            ),
            child: restaurantCachedNetworkImage(restaurant.image)),
      ),
      Space.yf(.3),
      Text(
        StringCapitalizeExtension(restaurant.name).capitalize(),
        style: AppText.h3b,
      ),
      Space.yf(.35),
      restaurantTagsRow(
          tags: restaurant.tags,
          svgColor: AppColors.darkPurple,
          textStyle: AppText.b1!.copyWith(height: 1))
    ],
  );
}
