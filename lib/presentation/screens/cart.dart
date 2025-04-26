import 'package:CanteenX/application/cubits/cart/cart_cubit.dart';
import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/assets.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/core/functions/calculate_total_price.dart';
import 'package:CanteenX/core/router/router.dart';
import 'package:CanteenX/models/restaurant.dart';
import 'package:CanteenX/presentation/widgets/custom_appbar.dart';
import 'package:CanteenX/presentation/widgets/custom_buttons.dart';
import 'package:CanteenX/presentation/widgets/empty_screen.dart';
import 'package:CanteenX/presentation/widgets/pickup_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> prices = [];

  @override
  void initState() {
    context.read<CartCubit>().loadCart(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: "Cart",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Space.yf(2.5),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if (state is CartLoaded && state.pickUps.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: AppDimensions.normalize(190),
                        child: ListView.separated(
                          itemCount: state.pickUps.length,
                          itemBuilder: (context, index) {
                            return pickupItem(
                              context: context,
                              pickUp: state.pickUps[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Space.yf();
                          },
                        ),
                      ),
                      Space.yf(.5),
                      Container(
                        width: double.infinity,
                        height: AppDimensions.normalize(16),
                        margin: Space.hf(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.deepRed),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.normalize(5),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_circle_outline_rounded,
                              color: AppColors.deepRed,
                            ),
                            Space.yf(.3),
                            Text(
                              "Add More Meals",
                              style: AppText.h3
                                  ?.copyWith(color: AppColors.deepRed),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is CartLoaded && state.pickUps.isEmpty) {
                  return emptyScreen(
                    text: "No Items in the Cart",
                    svg: AppAssets.emptyCart,
                  );
                } else {
                  return const Text("error");
                }
              },
            ),
            Space.yf(1.5),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if (state is CartLoaded && state.pickUps.isNotEmpty) {
                  for (var i = 0; i < state.pickUps.length; i++) {
                    prices.add(state.pickUps[i].price);
                  }
                  double totalPrice =
                      CalculateTotalPrice.calculateTotalPrice(prices);

                  return Column(
                    children: [
                      Text(
                        "Total Amount",
                        style: AppText.h3b,
                      ),
                      Space.yf(.2),
                      Text(
                        "$totalPrice KWD",
                        style: AppText.h1b?.copyWith(color: AppColors.deepRed),
                      ),
                      Space.yf(9.8),
                      customElevatedButton(
                          withArrow: true,
                          width: double.infinity,
                          height: AppDimensions.normalize(22),
                          color: AppColors.deepRed,
                          borderRadius: 0,
                          text: "Proceed to Checkout",
                          textStyle: AppText.h3b!.copyWith(color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              AppRouter.pickupsCheckout,
                              arguments: {
                                'restaurant': widget.restaurant,
                                'amount': totalPrice.toString(),
                                'itemsNumber': state.pickUps.length.toString(),
                              },
                            );
                          }),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
