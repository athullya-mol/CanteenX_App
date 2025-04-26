import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/presentation/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';

Future<void> customDialog(
  BuildContext context, {
  required String text,
  required void Function()? onPressed,
  required String buttonText,
}) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.normalize(6),
            ),
          ),
          child: SizedBox(
            height: AppDimensions.normalize(80),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Space.yf(2),
                  Text(
                    text,
                    style: AppText.h3b,
                    textAlign: TextAlign.center,
                  ),
                  Space.yf(1.5),
                  customElevatedButton(
                    width: AppDimensions.normalize(58),
                    height: AppDimensions.normalize(18),
                    color: AppColors.deepRed,
                    borderRadius: AppDimensions.normalize(3),
                    text: buttonText,
                    textStyle: AppText.h3b!.copyWith(color: Colors.white),
                    onPressed: onPressed,
                  )
                ],
              ),
            ),
          ),
        );
      });
}
