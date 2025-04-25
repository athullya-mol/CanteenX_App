import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String customerName;
  final String restaurantName;
  final double totalAmount;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.customerName,
    required this.restaurantName,
    required this.totalAmount,
    required this.orderDate,
  });

  // The 'fromDocument' method to convert a Firestore document into an Order instance
  factory Order.fromDocument(DocumentSnapshot doc) {
    return Order(
      id: doc
          .id, // This assumes that Firestore will assign a unique ID to each document
      customerName: doc['customerName'] ?? '',
      restaurantName: doc['restaurantName'] ?? '',
      totalAmount: doc['totalAmount'] ?? 0.0,
      orderDate: (doc['orderDate'] as Timestamp).toDate(),
    );
  }
}
