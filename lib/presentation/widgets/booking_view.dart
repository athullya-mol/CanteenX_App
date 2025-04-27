import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/core/router/router.dart';
import 'package:CanteenX/models/reservation.dart';
import 'package:CanteenX/models/restaurant.dart';
import 'package:CanteenX/presentation/widgets/custom_buttons.dart';
import 'package:CanteenX/presentation/widgets/custom_textfield.dart';
import 'package:CanteenX/presentation/widgets/restaurant_components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingView extends StatefulWidget {
  const BookingView({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final TextEditingController _nameController = TextEditingController();
  List<String> dropDownItems = [];
  String dropDownValue = "Select Counter";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int numberOfPersons = 1;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    dropDownItems = ["Select Counter", ...widget.restaurant.branches];
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
double pricePerPerson = double.tryParse(widget.restaurant.price) ?? 0.0;
    double totalPrice = pricePerPerson * numberOfPersons;
    return Column(
      children: [
        Padding(
          padding: Space.all(1, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customer Name",
                style: AppText.b1b,
              ),
              Space.yf(.5),
              customTextField(
                  labelText: "Type here", controller: _nameController),
              Space.yf(1.5),
              Text(
                "Canteen Counter",
                style: AppText.b1b,
              ),
              Space.yf(.5),
              Container(
                padding: Space.h1!,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.normalize(4),
                  ),
                ),
                child: DropdownButton(
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    value: dropDownValue,
                    items: dropDownItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownValue = value!;
                      });
                    }),
              ),
              Space.yf(1.5),
              Text(
                "Booking Date",
                style: AppText.b1b,
              ),
              Space.yf(.5),
              Container(
                padding: Space.all(1.1, .7),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.normalize(4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate.toString().substring(0, 10)),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: const Icon(
                        Icons.date_range,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Space.yf(1.5),
              Text(
                "Booking Time",
                style: AppText.b1b,
              ),
              Space.yf(.5),
              Container(
                padding: Space.all(1.1, .7),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.normalize(4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedTime.format(context)),
                    GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: const Icon(
                        Icons.timelapse,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Space.yf(1.5),
              Text(
                "No. Of Person",
                style: AppText.b1b,
              ),
              Space.yf(.5),
              Container(
                padding: Space.all(1.1, .7),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.normalize(4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(numberOfPersons.toString()),
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                numberOfPersons++;
                              });
                            },
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.grey,
                            )),
                        Space.xf(.2),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                numberOfPersons--;
                              });
                            },
                            child: const Icon(
                              Icons.arrow_downward,
                              color: Colors.grey,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              bookingFooter()
            ],
          ),
        ),
        reservationAmountColumn(totalPrice),
        customElevatedButton(
            width: double.infinity,
            height: AppDimensions.normalize(24),
            color: AppColors.deepRed,
            borderRadius: 0,
            text: "Confirm Booking",
            textStyle: AppText.h3b!.copyWith(color: Colors.white),
            onPressed: () {
              Reservation reservation = Reservation(
                  time: selectedTime.format(context).toString(),
                  personsNumber: numberOfPersons.toString(),
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  name: _nameController.text,
                  branch: dropDownValue.toString(),
                  restaurant: widget.restaurant.name,
                  amount: totalPrice.toStringAsFixed(2),
                  date: selectedDate.toString().substring(0, 10),
                  status: 'Pending');

              Navigator.of(context).pushNamed(AppRouter.reservationCheckout,
                  arguments: reservation);
            })
      ],
    );
  }
}
