import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishor_app/services/contact_service.dart';
import 'package:mishor_app/utilities/app_colors.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreen createState() => _SupportScreen();
}

class _SupportScreen extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary),
        ),
        centerTitle: true,
        backgroundColor: AppColors.Col_White,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Text(
                'We’re here to help! Fill out the form below or reach us through email or WhatsApp.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              _buildContactCard(
                icon: Icons.email,
                title: 'Email Us',
                description: 'support@mishor.com',
                color: AppColors.primary,
                onPressed: () {
                },
              ),
              SizedBox(height: 16),
              _buildContactCard(
                icon: Icons.phone,
                title: 'Phone No',
                description: '+123 456 7890',
                color: Colors.green,
                onPressed: () {
                },
              ),
              SizedBox(height: 24),
              Text(
                'Get in Touch With Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hintText: 'Enter your name',
                      icon: Icons.person,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter your name' : null,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      hintText: 'Enter your phone number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _messageController,
                      label: 'Message',
                      hintText: 'Enter your message',
                      icon: Icons.message,
                      maxLines: 5,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter a message' : null,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey[600]),
        ),
        onTap: onPressed,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
    );
  }

void _submitForm() async {
  final String name = _nameController.text;
  final String phone = _phoneController.text;
  final String email = _emailController.text;
  final String message = _messageController.text;

  // Show a loading dialog while the request is being processed
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );

  try {
    await ContactService.sendContactDetails(
      name: name,
      phone: phone,
      email: email,
      message: message,
    );
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Contact Submitted'),
        content: Text(
          'Thank you, $name! Your message has been sent successfully. We will contact you shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
  
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Submission Failed'),
        content: Text(
          'An error occurred while sending your message. Please try again later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
}
