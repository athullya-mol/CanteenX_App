import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garcon/core/constants/colors.dart';
import 'package:garcon/presentation/screens/choose.dart';
import 'package:garcon/presentation/widgets/custom_deletedialog.dart';
import 'package:garcon/presentation/widgets/home_components.dart';

class DeleteMenuScreen extends StatelessWidget {
  const DeleteMenuScreen({Key? key}) : super(key: key);

  Future<void> _deleteMenuItem(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(docId)
          .delete();
    } catch (e) {
      print('Error deleting menu item: $e');
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
        title: trendingTitle('Delete Food Menu'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('restaurants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading menu items'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final menuItems = snapshot.data?.docs ?? [];

          if (menuItems.isEmpty) {
            return const Center(child: Text('No menu items found.'));
          }

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final doc = menuItems[index];
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unnamed Dish';
              final imageUrl = data['image'] ?? '';
              final categories =
                  (data['categories'] as List<dynamic>?)?.join(', ') ??
                      'No categories';
              final ratings = data['ratings']?.toString() ?? 'No ratings';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? Image.network(imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.fastfood),
                  title: Text(name),
                  subtitle: Text('Categories: $categories\nRatings: $ratings'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.deepRed,
                      size: 20,
                    ),
                    onPressed: () async {
                      final confirm = await customDeleteDialog(
                        context,
                        text: 'Are you sure you want to delete this menu item?',
                        buttonText1: 'Cancel',
                        buttonText2: 'Delete',
                      );

                      if (confirm == true) {
                        // Proceed with deletion
                      }

                      if (confirm == true) {
                        await _deleteMenuItem(doc.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Menu item deleted')),
                        );
                      }
                    },
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
