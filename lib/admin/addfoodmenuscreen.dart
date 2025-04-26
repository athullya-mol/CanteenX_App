import 'dart:io';
import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/presentation/screens/choose.dart';
import 'package:CanteenX/presentation/widgets/custom_buttons.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodMenuScreen extends StatefulWidget {
  const AddFoodMenuScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodMenuScreen> createState() => _AddFoodMenuScreenState();
}

class _AddFoodMenuScreenState extends State<AddFoodMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _catController = TextEditingController();
  final TextEditingController _ratController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _pickupsController = TextEditingController();
  final TextEditingController _branchesController = TextEditingController();
  final TextEditingController _reservationController = TextEditingController();
  bool _isLoading = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _addMenuItem() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Upload image to Firebase Storage (no folder path)
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(_selectedImage!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Generate a new document reference with auto ID
        DocumentReference docRef =
            FirebaseFirestore.instance.collection('restaurants').doc();

        // Prepare menu item data
        final menuItem = {
          'id': docRef.id,
          'name': _nameController.text.trim(),
          'image': downloadUrl,
          'ratings': _ratController.text.trim(),
          'tags': _tagsController.text.trim().split(','),
          'categories': _catController.text.trim().split(','),
          'pickups': _pickupsController.text.trim().split(','),
          'branches': _branchesController.text.trim().split(','),
          'reservation': _reservationController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Save menu item to Firestore
        await docRef.set(menuItem);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu item added successfully')),
        );

        // Clear form
        _nameController.clear();
        _catController.clear();
        _ratController.clear();
        _tagsController.clear();
        _pickupsController.clear();
        _branchesController.clear();
        _reservationController.clear();
        setState(() {
          _selectedImage = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add item: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
        title: trendingTitle("Add New Food Menu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.add_a_photo),
                        ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Dish Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter dish name' : null,
                ),
                TextFormField(
                  controller: _catController,
                  decoration: const InputDecoration(
                      labelText: 'Categories (comma separated)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter categories'
                      : null,
                ),
                TextFormField(
                  controller: _ratController,
                  decoration: const InputDecoration(labelText: 'Ratings'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter ratings' : null,
                ),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)'),
                ),
                TextFormField(
                  controller: _pickupsController,
                  decoration: const InputDecoration(
                      labelText: 'Pickups (comma separated)'),
                ),
                TextFormField(
                  controller: _branchesController,
                  decoration: const InputDecoration(
                      labelText: 'Branches (comma separated)'),
                ),
                TextFormField(
                  controller: _reservationController,
                  decoration: const InputDecoration(labelText: 'Reservation'),
                ),
                Space.yf(2.5),
                customElevatedButton(
                  width: double.infinity,
                  height: AppDimensions.normalize(20),
                  color: Colors.black,
                  borderRadius: AppDimensions.normalize(5),
                  text: !_isLoading
                      ? "Add Menu".toUpperCase()
                      : "Wait".toUpperCase(),
                  textStyle: AppText.h3b!.copyWith(color: Colors.white),
                  onPressed: _isLoading ? null : _addMenuItem,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
