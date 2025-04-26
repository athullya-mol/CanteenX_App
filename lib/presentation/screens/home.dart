import 'package:CanteenX/application/blocs/restaurants/restaurants_bloc.dart';
import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/assets.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/presentation/screens/chatbot_ai.dart';
import 'package:CanteenX/presentation/widgets/dots_indicator.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';
import 'package:CanteenX/presentation/widgets/horizontal_restaurant_item.dart';
import 'package:CanteenX/presentation/widgets/vertical_restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int selectedPageIndex = 1;

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedPageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              trendingTitle("Today's Specials"),
              SizedBox(
                height: AppDimensions.normalize(97),
                child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
                  builder: (context, state) {
                    if (state is RestaurantsLoaded &&
                        state.restaurants.isNotEmpty) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.restaurants.length,
                        padding: Space.hf(1.2),
                        itemBuilder: (context, index) {
                          return horizontalRestaurantItem(
                              state.restaurants[index], context);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Space.xf();
                        },
                      );
                    } else if (state is RestaurantsLoaded &&
                        state.restaurants.isEmpty) {
                      return noRestaurantsState();
                    } else {
                      return loadingState();
                    }
                  },
                ),
              ),
              restaurantsTitle(),
              BlocBuilder<RestaurantsBloc, RestaurantsState>(
                builder: (context, state) {
                  if (state is RestaurantsLoaded &&
                      state.restaurants.isNotEmpty) {
                    return Column(
                      children: [
                        ...state.restaurants.map((restaurant) =>
                            verticalRestaurantItem(restaurant, context))
                      ],
                    );
                  } else if (state is RestaurantsLoaded &&
                      state.restaurants.isEmpty) {
                    return noRestaurantsState();
                  } else {
                    return loadingState();
                  }
                },
              ),
              Space.yf(.6),
              SizedBox(
                height: AppDimensions.normalize(130),
                child: PageView.builder(
                    itemCount: 4,
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        selectedPageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: Space.hf(1.3),
                        child: Image.asset(
                          AppAssets.ad,
                          fit: BoxFit.fill,
                        ),
                      );
                    }),
              ),
              Space.yf(.6),
              Center(
                child: dotsIndicator(
                  dotsIndex:
                      _pageController.hasClients ? _pageController.page! : 1,
                  dotsCount: 4,
                  activeColor: AppColors.darkRed.withOpacity(.7),
                  color: AppColors.darkRed.withOpacity(.2),
                ),
              ),
              Space.yf()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const ChatBotScreen(),
            );
          },
          child: const Icon(Icons.chat),
        ));
  }
}
