import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/assets.dart';
import 'package:CanteenX/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

PreferredSizeWidget customAppBar(
    {required BuildContext context,
    required String title,
    bool isWithArrow = true}) {
  return PreferredSize(
      preferredSize: Size(
        double.infinity,
        AppDimensions.normalize(20),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: Space.hf(1.3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isWithArrow
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        AppAssets.arrowLeft,
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn),
                      ),
                    )
                  : const SizedBox.shrink(),
              Text(
                StringCapitalizeExtension(title).capitalize(),
                style: AppText.h3b,
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ));
}
