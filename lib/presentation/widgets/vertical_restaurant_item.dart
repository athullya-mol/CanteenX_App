import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/assets.dart';
import 'package:CanteenX/core/extensions/extensions.dart';
import 'package:CanteenX/core/router/router.dart';
import 'package:CanteenX/models/restaurant.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget verticalRestaurantItem(Restaurant restaurant, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.of(
        context,
      ).pushNamed(AppRouter.restaurant, arguments: restaurant);
    },
    child: Container(
      clipBehavior: Clip.hardEdge,
      margin: Space.all(1.3, .5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.normalize(8)),
      ),
      child: Stack(
        children: [
          restaurantCachedNetworkImage(restaurant.image),
          Positioned(
            top: AppDimensions.normalize(8),
            right: AppDimensions.normalize(8),
            child: Column(
              children: [
                // reviewsRow(svgUrl: AppAssets.eyeAlt, text: restaurant.views),
                // Space.yf(.3),
                reviewsRow(svgUrl: AppAssets.star, text: restaurant.ratings),
              ],
            ),
          ),
          Positioned(
            bottom: AppDimensions.normalize(5),
            left: AppDimensions.normalize(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringCapitalizeExtension(restaurant.name).capitalize(),
                  style: AppText.h2b?.copyWith(
                    color: Colors.white,
                    backgroundColor: Colors.blueGrey.shade400,
                  ),
                ),
                Space.yf(.2),
                restaurantTagsRow(
                  tags: restaurant.tags,
                  svgColor: Colors.white,
                  textStyle: AppText.b1b!.copyWith(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget reviewsRow({required String svgUrl, required String text}) {
  return Row(
    children: [
      SvgPicture.asset(
        svgUrl,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      Space.xf(.5),
      Text(text, style: AppText.b1b?.copyWith(color: Colors.white)),
    ],
  );
}
