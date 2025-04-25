import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garcon/models/reservation.dart';
import 'package:garcon/presentation/screens/choose.dart';
import 'package:garcon/presentation/widgets/home_components.dart';

class CustomerOrderListScreen extends StatelessWidget {
  const CustomerOrderListScreen({Key? key}) : super(key: key);

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
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  title: Text('${res.name} • ${res.restaurant}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${res.date} at ${res.time}'),
                      Text('Branch: ${res.branch}'),
                      Text('People: ${res.personsNumber}'),
                      Text('Amount: ₹${res.amount}'),
                      Text('User ID: ${res.userId}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
