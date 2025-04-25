import 'package:flutter/material.dart';
import 'package:garcon/configs/configs.dart';
import 'package:garcon/core/constants/colors.dart';
import 'package:garcon/presentation/widgets/custom_buttons.dart';

Future<bool?> customDeleteDialog(
  BuildContext context, {
  required String text,
  required String buttonText1,
  required String buttonText2,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.normalize(6)),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.normalize(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppDimensions.normalize(10)),
              Text(
                text,
                style: AppText.h3b,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.normalize(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customElevatedButton(
                    width: AppDimensions.normalize(38),
                    height: AppDimensions.normalize(18),
                    color: Colors.black,
                    borderRadius: AppDimensions.normalize(3),
                    text: buttonText1,
                    textStyle: AppText.h3b!.copyWith(color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  customElevatedButton(
                    width: AppDimensions.normalize(38),
                    height: AppDimensions.normalize(18),
                    color: AppColors.deepRed,
                    borderRadius: AppDimensions.normalize(3),
                    text: buttonText2,
                    textStyle: AppText.h3b!.copyWith(color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.normalize(10)),
            ],
          ),
        ),
      );
    },
  );
}
