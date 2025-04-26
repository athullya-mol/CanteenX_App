import 'package:CanteenX/application/blocs/about_us/about_us_bloc.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/strings.dart';
import 'package:CanteenX/presentation/widgets/custom_appbar.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';
import 'package:CanteenX/presentation/widgets/settings_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "About us"),
      body: SingleChildScrollView(
        child: BlocBuilder<AboutUsBloc, AboutUsState>(
          builder: (context, state) {
            if (state is AboutUsLoaded) {
              return Column(
                children: [
                  Space.yf(),
                  restaurantCachedNetworkImage(AppStrings.aboutUsImage),
                  Space.yf(1.5),
                  verseText(text: state.aboutUs.verse1),
                  Space.yf(2),
                  verseText(text: state.aboutUs.verse2),
                  Space.yf(2),
                ],
              );
            } else {
              return Center(
                child: Text(
                  "error loading info",
                  style: AppText.h3b,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
