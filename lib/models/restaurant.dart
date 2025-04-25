import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String image;
  // final String views;
  final String ratings;
  final List<dynamic> tags;
  final List<dynamic> categories;
  final List<dynamic> pickups;
  final List<dynamic> branches;
  final String reservation;

  const Restaurant({
    required this.id,
    required this.name,
    required this.image,
    // required this.views,
    required this.ratings,
    required this.tags,
    required this.categories,
    required this.pickups,
    required this.branches,
    required this.reservation,
  });

  /// Factory constructor to create a Restaurant from a Firestore DocumentSnapshot
  static Restaurant fromSnapShot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>?;

    return Restaurant(
      id: data?['id'] ?? snap.id,
      name: data?['name'] ?? '',
      image: data?['image'] ?? '',
      // views: data?['views'] ?? '0',
      ratings: data?['ratings'] ?? '0',
      tags: data?['tags'] ?? [],
      categories: data?['categories'] ?? [],
      pickups: data?['pickups'] ?? [],
      branches: data?['branches'] ?? [],
      reservation: data?['reservation'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        ratings,
        // views,
        // reviews,
        tags,
        categories,
        pickups,
        branches,
        reservation,
      ];
}
