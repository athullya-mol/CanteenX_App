import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/core/constants/assets.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/core/router/router.dart';
import 'package:CanteenX/presentation/widgets/choose_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooseScreen extends StatelessWidget {
  const ChooseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          chooseStack(
              title: "User Login",
              curvedSvg: AppAssets.redCurve,
              positionedSvg: AppAssets.user,
              color: AppColors.deepRed,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.signIn);
              }),
          SizedBox(
              height: AppDimensions.normalize(65),
              child: SvgPicture.asset(
                AppAssets.logoText,
                colorFilter: const ColorFilter.mode(
                    AppColors.darkPurple, BlendMode.srcIn),
              )),
          chooseStack(
              title: "Admin Login",
              curvedSvg: AppAssets.purpleCurve,
              positionedSvg: AppAssets.user,
              color: AppColors.darkPurple,
              onTap: () {
                Navigator.of(context).pushNamed(AppRouter.adminSignIn);
              }),
        ],
      ),
    );
  }
}
