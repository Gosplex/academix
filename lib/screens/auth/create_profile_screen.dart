import 'dart:io';

import 'package:academix/helpers/helper_functions.dart';
import 'package:academix/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../constants/constants.dart';
import '../../providers/auth_provider.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Booleans
  bool _isEmailValid = false;
  bool _isNameValid = false;
  bool _isPhoneValid = false;

  // Form Key
  final _formKey = GlobalKey<FormState>();
  File? _image;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _nameController.addListener(_validateName);
    _phoneController.addListener(_validatePhone);
  }

  Future<void> _pickImage() async {
    final pickedImage = await HelperFunctions.pickImage();
    setState(() {
      _image = pickedImage;
    });
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isNotEmpty &&
          validateEmail(_emailController.text)) {
        _isEmailValid = false;
      }
    });
  }

  // Validate Email
  bool validateEmail(String email) {
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isNotEmpty &&
          validateName(_nameController.text)) {
        _isNameValid = false;
      }
    });
  }

  // Validate Name
  bool validateName(String name) {
    const namePattern = r'^[a-zA-Z\s]+$';
    final regExp = RegExp(namePattern);
    return regExp.hasMatch(name);
  }

  // Validate Phone
  bool validatePhone(String phone) {
    const phonePattern = r'^[0-9]{10}$';
    final regExp = RegExp(phonePattern);
    return regExp.hasMatch(phone);
  }

  void _validatePhone() {
    setState(() {
      if (_phoneController.text.isNotEmpty &&
          validatePhone(_phoneController.text)) {
        _isPhoneValid = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Create Your Academix Profile',
                style: Constants.heading3,
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black.withOpacity(0.1),
                  child: ClipOval(
                    child: _image != null
                        ? Image.file(
                            _image!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                CupertinoIcons.person,
                                size: 60,
                                color: Colors.grey.shade700,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/student_avatar.png',
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                CupertinoIcons.person,
                                size: 60,
                                color: Colors.grey.shade700,
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
            // Center text button, change image
            Center(
              child: TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: Text(
                  'Change Image',
                  style: Constants.body.copyWith(
                    color: Constants.primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Profile Form, email, name, phone number
            Form(
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.black.withOpacity(0.5),
                        cursorWidth: 1.0,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 8.0,
                          ),
                          hintText: 'Email',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                                width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: _isEmailValid,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 2,
                              bottom: 10,
                            ),
                            child: Text(
                              'Please enter a valid email address',
                              style: Constants.body.copyWith(
                                color: Colors.red,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextFormField(
                        controller: _nameController,
                        cursorColor: Colors.black.withOpacity(0.5),
                        cursorWidth: 1.0,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 8.0,
                          ),
                          hintText: 'Full Name',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                                width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: _isNameValid,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 2,
                              bottom: 10,
                            ),
                            child: Text(
                              'Please enter your full name',
                              style: Constants.body.copyWith(
                                color: Colors.red,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextFormField(
                        controller: _phoneController,
                        cursorColor: Colors.black.withOpacity(0.5),
                        cursorWidth: 1.0,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.length > 10) {
                            _phoneController.text = value.substring(0, 10);
                          }

                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 8.0,
                          ),
                          hintText: 'Phone Number',
                          counterText: '',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                                width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Text length / 10
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: _isPhoneValid,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 0,
                              bottom: 10,
                            ),
                            child: Text(
                              'Please enter your phone number',
                              style: Constants.body.copyWith(
                                color: Colors.red,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '${_phoneController.text.length}/10',
                          style: Constants.body.copyWith(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    // Save Button
                    isLoading
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: const CircularProgressIndicator(
                                color: Constants.primaryColor,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isEmailValid = _emailController.text.isEmpty;
                                  _isNameValid = _nameController.text.isEmpty;
                                  _isPhoneValid = _phoneController.text.isEmpty;
                                });

                                if (_image == null) {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    displayDuration:
                                        const Duration(milliseconds: 400),
                                    const CustomSnackBar.error(
                                      message:
                                          'Please select an image to continue.',
                                    ),
                                  );
                                }

                                if (_isEmailValid == false &&
                                    _isNameValid == false &&
                                    _isPhoneValid == false &&
                                    _image != null) {
                                  UserModel userModel = UserModel(
                                    uid: '',
                                    email: _emailController.text,
                                    name: _nameController.text,
                                    phoneNumber: _phoneController.text,
                                    photoUrl: '',
                                    createdAt: Timestamp.now(),
                                    updatedAt: Timestamp.now(),
                                  );

                                  await ap.saveUserData(
                                    userModel: userModel,
                                    profilePic: _image!,
                                    context: context,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: Constants.body.copyWith(
                                  color: Constants.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
