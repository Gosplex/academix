import 'package:academix/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'phone_auth_screen.dart';

class PasswordSetScreen extends StatefulWidget {
  const PasswordSetScreen({super.key, required this.email});

  final String email;

  @override
  State<PasswordSetScreen> createState() => _PasswordSetScreenState();
}

class _PasswordSetScreenState extends State<PasswordSetScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _isLogin = false;
  bool isVisible = false;

  @override
  void dispose() {
    passwordController.removeListener(_updateState);
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    emailController.text = widget.email;
    passwordController.addListener(_updateState);
    super.initState();
  }

  void _updateState() {
    setState(() {
      // Validate all conditions
      if (passwordController.text.length >= 8 &&
          RegExp(r'(?=.*?[A-Z])').hasMatch(passwordController.text) &&
          RegExp(r'(?=.*?[0-9])').hasMatch(passwordController.text) &&
          RegExp(r'(?=.*?[!@#$&*])').hasMatch(passwordController.text)) {
        isVisible = false;
      } else if (passwordController.text.isNotEmpty) {
        isVisible = true;
      } else {
        isVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black.withOpacity(1),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('FORGOT PASSWORD?',
                  style: Constants.body.copyWith(
                    color: Constants.primaryColor.withOpacity(0.8),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _isLogin ? _loginAccount() : _createAccount(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Other Sign In Options',
                      style: Constants.body.copyWith(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
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
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createAccount() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Column(
      children: [
        // SignIn Heading
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Sign Up',
              style: Constants.heading1,
            ),
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
                child: TextFormField(
                  cursorColor: Colors.black.withOpacity(0.5),
                  controller: emailController,
                  cursorWidth: 1.0,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 10.0,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Constants.primaryColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextFormField(
                  cursorColor: Colors.black.withOpacity(0.5),
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      passwordController.text = value;
                    });
                  },
                  cursorWidth: 1.0,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 10.0,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Constants.primaryColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              // Password Validation Checkmark
              const SizedBox(height: 10),
              AnimatedOpacity(
                opacity: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isVisible ? null : 0.0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            passwordController.text.length >= 8
                                ? Icons.check
                                : Icons.close,
                            color: passwordController.text.length >= 8
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Password must be at least 8 characters long',
                            style: Constants.body.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      // Password must contain an uppercase letter
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            RegExp(r'(?=.*?[A-Z])')
                                    .hasMatch(passwordController.text)
                                ? Icons.check
                                : Icons.close,
                            color: RegExp(r'(?=.*?[A-Z])')
                                    .hasMatch(passwordController.text)
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Password must contain an uppercase letter',
                            style: Constants.body.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      // Password must contain a number

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            RegExp(r'(?=.*?[0-9])')
                                    .hasMatch(passwordController.text)
                                ? Icons.check
                                : Icons.close,
                            color: RegExp(r'(?=.*?[0-9])')
                                    .hasMatch(passwordController.text)
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Password must contain a number',
                            style: Constants.body.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      // Password must contain a special character
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            RegExp(r'(?=.*?[!@#$&*])')
                                    .hasMatch(passwordController.text)
                                ? Icons.check
                                : Icons.close,
                            color: RegExp(r'(?=.*?[!@#$&*])')
                                    .hasMatch(passwordController.text)
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Password must contain a special character',
                            style: Constants.body.copyWith(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
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
                  : SizedBox(
                      width: double.infinity,
                      // height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          ap.signUpWithEmailPassword(
                            emailController.text,
                            passwordController.text,
                            context,
                          );
                        },
                        child: Text(
                          'Create Account',
                          style: Constants.body.copyWith(
                            color: Constants.white,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Constants.body.copyWith(
                          color: Colors.black.withOpacity(0.5), fontSize: 12.0),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = true;
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                        minimumSize:
                            MaterialStateProperty.all(const Size(0, 0)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        'Sign In',
                        style: Constants.body.copyWith(
                          color: Constants.primaryColor,
                          fontSize: 12.0,
                          decoration: TextDecoration.underline,
                          decorationColor: Constants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginAccount() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              'Sign In',
              style: Constants.heading1,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextFormField(
                  cursorColor: Colors.black.withOpacity(0.5),
                  controller: emailController,
                  cursorWidth: 1.0,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 10.0,
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Constants.primaryColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextFormField(
                  cursorColor: Colors.black.withOpacity(0.5),
                  controller: passwordController,
                  onChanged: (value) {
                    setState(() {
                      passwordController.text = value;
                    });
                  },
                  cursorWidth: 1.0,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: 10.0,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Constants.primaryColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
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
                  : SizedBox(
                      width: double.infinity,
                      // height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        onPressed: () {
                          ap.signInWithEmailPassword(
                            emailController.text,
                            passwordController.text,
                            context,
                          );
                        },
                        child: Text(
                          'Login Account',
                          style: Constants.body.copyWith(
                            color: Constants.white,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Constants.body.copyWith(
                          color: Colors.black.withOpacity(0.5), fontSize: 12.0),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = false;
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                        minimumSize:
                            MaterialStateProperty.all(const Size(0, 0)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        'Sign Up',
                        style: Constants.body.copyWith(
                          color: Constants.primaryColor,
                          fontSize: 12.0,
                          decoration: TextDecoration.underline,
                          decorationColor: Constants.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
