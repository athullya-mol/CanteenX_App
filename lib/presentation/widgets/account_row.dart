import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:flutter/material.dart';

Widget accountRow({
  required String title,
  void Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppText.h2?.copyWith(
            color: AppColors.greyColor,
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.greyColor,
        )
      ],
    ),
  );
}
