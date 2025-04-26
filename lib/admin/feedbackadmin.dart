import 'package:CanteenX/admin/customerorderlistscreen.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackAdminPanel extends StatelessWidget {
  const FeedbackAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CustomerOrderListScreen()),
            );
          },
        ),
        title: trendingTitle("User Feedback"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedbacks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching feedback'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final feedbackDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              final data = feedbackDocs[index];
              final subject = data['subject'] ?? 'No Subject';
              final feedback = data['feedback'] ?? 'No Feedback';
              final name = data['name'] ?? 'Anonymous';
              final timestamp = data['timestamp']?.toDate();

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              const Icon(Icons.feedback, color: Colors.blue),
                          title: Text(
                            subject,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              feedback,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'By: $name',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timestamp != null
                              ? 'Submitted on: ${timestamp.toLocal()}'
                              : 'No timestamp',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
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
