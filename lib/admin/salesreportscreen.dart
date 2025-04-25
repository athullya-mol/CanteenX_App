import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garcon/presentation/screens/choose.dart';
import 'package:garcon/presentation/widgets/home_components.dart';

class SalesReportScreen extends StatelessWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  Future<Map<String, Map<String, dynamic>>> fetchDailySales() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('reservations').get();

    Map<String, Map<String, dynamic>> dailySales = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = data['date']; // Ensure this is in 'YYYY-MM-DD' format
      final amount = double.tryParse(data['amount'].toString()) ?? 0.0;

      if (dailySales.containsKey(date)) {
        dailySales[date]!['orders'] += 1;
        dailySales[date]!['total'] += amount;
      } else {
        dailySales[date] = {
          'orders': 1,
          'total': amount,
        };
      }
    }

    return dailySales;
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
        title: trendingTitle("Sales Reports"),
      ),
      body: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: fetchDailySales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sales data available.'));
          }

          final salesData = snapshot.data!;
          final sortedDates = salesData.keys.toList()
            ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order

          return ListView.builder(
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final data = salesData[date]!;
              return ListTile(
                title: Text('Date: $date'),
                subtitle: Text('Orders: ${data['orders']}'),
                trailing: Text('₹${data['total'].toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
