import 'package:academix/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'password_set_screen.dart';
import 'phone_auth_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  bool isEmailValid = false;
  late FocusNode emailFocusNode;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    emailController.addListener(_validateEmail);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      isEmailValid = emailController.text.isNotEmpty &&
          validateEmail(emailController.text);
    });
  }

  // Validate Email
  bool validateEmail(String email) {
    const emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 60),
                child: CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.black.withOpacity(0.1),
                  child: Lottie.asset(
                    'assets/animations/avatar.json',
                    height: 50,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                'Let\'s get started!',
                style: Constants.heading3,
              ),
            ),
            // Email Verification Form
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.black.withOpacity(0.5),
                        cursorWidth: 1.0,
                        focusNode: emailFocusNode,
                        // onChanged: (value) => _validateEmail(),
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
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                                width: 1.0),
                            borderRadius: BorderRadius.zero,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.5),
                                width: 1.0),
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Email Error Message
                  Visibility(
                    visible: emailController.text.isNotEmpty && !isEmailValid,
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Please enter a valid email address',
                        style: Constants.body.copyWith(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      onPressed: isEmailValid
                          ? () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      PasswordSetScreen(
                                    email: emailController.text,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                        animation.drive(tween);

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        'Continue with Email',
                        style: Constants.body.copyWith(
                          color: Constants.white,
                        ),
                      ),
                    ),
                  ),
                  // Or
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        Text(
                          'or',
                          style: Constants.body.copyWith(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            height: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // sign up with google button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      elevation: 0, // Set elevation to 0
                      minimumSize: const Size(double.infinity, 45),
                      side: BorderSide(color: Colors.black.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      ap.signInWithGoogle(context);
                    },
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 24.0,
                    ),
                    label: Text(
                      'Sign In with Google',
                      style: Constants.body.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      elevation: 0, // Set elevation to 0
                      minimumSize: const Size(double.infinity, 45),
                      side: BorderSide(color: Colors.black.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const PhoneAuthScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    icon: Image.asset(
                      'assets/images/phone.png',
                      height: 24.0,
                    ),
                    label: Text(
                      'Sign In with Phone',
                      style: Constants.body.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Terms and Conditions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'By signing up, you agree to our ',
                        style: Constants.body.copyWith(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        'Terms and Conditions',
                        style: Constants.body.copyWith(
                          color: Constants.primaryColor,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
