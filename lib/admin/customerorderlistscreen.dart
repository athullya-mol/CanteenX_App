import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/models/reservation.dart';
import 'package:CanteenX/presentation/screens/choose.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrderListScreen extends StatelessWidget {
  const CustomerOrderListScreen({Key? key}) : super(key: key);

  // Function to update the reservation status
  Future<void> updateReservationStatus(
      String reservationId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({'status': newStatus});
      print('Reservation status updated to $newStatus');
    } catch (e) {
      print('Error updating reservation status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChooseScreen()),
            );
          },
        ),
        title: trendingTitle("Customer Order List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('reservations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading reservations'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final reservations = snapshot.data!.docs
              .map((doc) => Reservation.fromSnapshot(doc))
              .toList();

          if (reservations.isEmpty) {
            return const Center(child: Text('No reservations found.'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final res = reservations[index];
              final docId = snapshot.data!.docs[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${res.name} • ${res.restaurant}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Date: ${res.date} at ${res.time}'),
                      Text('Branch: ${res.branch}'),
                      Text('People: ${res.personsNumber}'),
                      Text('Amount: ₹${res.amount}'),
                      Text('User ID: ${res.userId}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status: ${res.status}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          ElevatedButton(
                              onPressed: () {
                                final newStatus = res.status == 'Pending'
                                    ? 'Accepted'
                                    : 'Pending';
                                updateReservationStatus(docId, newStatus);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: res.status == 'Accepted'
                                    ? AppColors.deepGreen
                                    : AppColors.deepRed,
                              ),
                              child: Text(
                                res.status == 'Accepted'
                                    ? 'Accepted'
                                    : 'Accept',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
