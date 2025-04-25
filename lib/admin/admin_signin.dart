import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:garcon/application/cubits/navigation_cubit/admin_navigation_cubit.dart';
import 'package:garcon/presentation/widgets.dart';

import '../../configs/configs.dart';
import '../../core/core.dart';

class AdminSigninScreen extends StatefulWidget {
  const AdminSigninScreen({super.key});

  @override
  State<AdminSigninScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<AdminSigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Validators _validators = Validators();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      appBar: customAppBar(context: context, title: "Admin Sign In"),
      body: SingleChildScrollView(
        child: Padding(
          padding: Space.hf(1.8),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Space.yf(1.5),
                  SvgPicture.asset(
                    AppAssets.logoText,
                    colorFilter: const ColorFilter.mode(
                      AppColors.deepRed,
                      BlendMode.srcIn,
                    ),
                    height: 250,
                  ),
                  Text(
                    "Sign In",
                    style: AppText.h1b,
                  ),
                  Space.yf(2),
                  customTextField(
                    labelText: "Email",
                    controller: _emailController,
                    validator: _validators.validateEmail,
                    prefix: Padding(
                      padding: EdgeInsets.only(
                        left: AppDimensions.normalize(9),
                        right: AppDimensions.normalize(5),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.email,
                      ),
                    ),
                  ),
                  Space.yf(1.5),
                  customTextField(
                    labelText: "Password",
                    controller: _passwordController,
                    validator: _validators.validatePassword,
                    prefix: Padding(
                      padding: EdgeInsets.only(
                        left: AppDimensions.normalize(9),
                        right: AppDimensions.normalize(5),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.lock,
                      ),
                    ),
                  ),
                  Space.yf(.7),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Forgot Password?",
                      style: AppText.h3,
                    ),
                  ),
                  Space.yf(2.7),
                  customElevatedButton(
                    width: double.infinity,
                    height: AppDimensions.normalize(20),
                    color: AppColors.deepRed,
                    borderRadius: AppDimensions.normalize(5),
                    text: "SIGN IN",
                    textStyle: AppText.h3b!.copyWith(color: Colors.white),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (email == "admin12@gmail.com" &&
                            password == "Admin@123") {
                          customDialog(
                            context,
                            text:
                                "You have successfully\nLogged in with CanteenX",
                            buttonText: "My Account",
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRouter.adminroot, (route) => false);
                              context
                                  .read<AdminNavigationCubit>()
                                  .updateTab(AdminNavigationTab.customerOrders);
                            },
                          );
                        } else {
                          customDialog(
                            context,
                            text: "Invalid Email or Password!",
                            buttonText: "Dismiss",
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      }
                    },
                  ),
                  Space.yf(3.5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
