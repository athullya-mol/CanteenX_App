import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackAdminPanel extends StatelessWidget {
  const FeedbackAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Feedback')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedbacks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: const Text('Error fetching feedback'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final feedbackDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: feedbackDocs.length,
            itemBuilder: (context, index) {
              final feedback = feedbackDocs[index]['feedback'];
              final timestamp = feedbackDocs[index]['timestamp']?.toDate();
              return ListTile(
                title: Text(feedback),
                subtitle: Text(
                    timestamp != null ? timestamp.toString() : 'No timestamp'),
              );
            },
          );
        },
      ),
    );
  }
}
