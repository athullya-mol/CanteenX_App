import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:CanteenX/configs/app_dimensions.dart';
import 'package:CanteenX/configs/app_typography.dart';
import 'package:CanteenX/configs/space.dart';
import 'package:CanteenX/core/constants/colors.dart';
import 'package:CanteenX/presentation/screens/home.dart';
import 'package:CanteenX/presentation/widgets/custom_buttons.dart';
import 'package:CanteenX/presentation/widgets/home_components.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  bool _isLoading = false;

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'subject': _subjectController.text.trim(),
          'feedback': _feedbackController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully')),
        );
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _feedbackController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _feedbackController.dispose();
    super.dispose();
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
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: trendingTitle("Submit Feedback"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              Space.yf(1.5),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Your Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email validation
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              Space.yf(1.5),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              Space.yf(1.5),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(labelText: 'Your Feedback'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              Space.yf(2.5),
              customElevatedButton(
                width: double.infinity,
                height: AppDimensions.normalize(20),
                color: AppColors.deepRed,
                borderRadius: AppDimensions.normalize(5),
                text:
                    !_isLoading ? "Submit".toUpperCase() : "Wait".toUpperCase(),
                textStyle: AppText.h3b!.copyWith(color: Colors.white),
                onPressed: _isLoading ? null : _submitFeedback,
              )
            ],
          ),
        ),
      ),
    );
  }
}
