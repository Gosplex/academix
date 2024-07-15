// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:academix/constants/constants.dart';
import 'package:academix/screens/main/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../model/user_model.dart';
import '../screens/auth/create_academic_profile.dart';
import '../screens/auth/create_profile_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/auth/otp_screen.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  bool _isProfileCreated = false;
  bool get isProfileCreated => _isProfileCreated;
  bool _isAcademicCreated = false;
  bool get isAcademicCreated => _isAcademicCreated;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> checkLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  Future setLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLoggedIn', true);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> sendOTP(String phoneNumber, BuildContext context) async {
    // Set loading to true
    _isLoading = true;
    notifyListeners();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _isLoading = false;
        notifyListeners();
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: e.message!,
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        _isLoading = false;
        notifyListeners();
        showTopSnackBar(
          Overlay.of(context),
          displayDuration: const Duration(milliseconds: 500),
          CustomSnackBar.info(
            message:
                "OTP has been sent to your phone number. Please enter the OTP to verify your account.",
            textStyle: Constants.body.copyWith(color: Colors.white),
          ),
        );
        // Delay for 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  OTPScreen(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ),
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
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Verify OTP
  Future<void> verifyOTP(
      String otp, String verificationId, BuildContext context) async {
    // Set loading to true
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      User? user = (await _firebaseAuth.signInWithCredential(credential)).user;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var isProfileCreated =
          sharedPreferences.getBool('isProfileCreated') ?? false;
      if (user != null) {
        _isLoading = false;
        // Set login to true
        await setLogin();
        notifyListeners();
        showTopSnackBar(
          displayDuration: const Duration(milliseconds: 500),
          Overlay.of(context),
          const CustomSnackBar.info(
            message: "OTP has been verified successfully.",
          ),
        );

        print("Profile Created: $isProfileCreated");

        if (isProfileCreated) {
          // Delay for 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
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
          });
        } else {
          // Delay for 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CreateProfileScreen(),
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
              (route) => false,
            );
          });
        }
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    }
  }

  // SignIn with google
  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        showTopSnackBar(
          displayDuration: const Duration(milliseconds: 500),
          Overlay.of(context),
          const CustomSnackBar.info(
            message: "Signed in with Google successfully.",
          ),
        );

        await setLogin();

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const CreateProfileScreen(),
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
        });
      }
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    }
  }

  // Sign Up with email and password
  Future<void> signUpWithEmailPassword(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showTopSnackBar(
        displayDuration: const Duration(milliseconds: 500),
        Overlay.of(context),
        const CustomSnackBar.info(
          message: "Account created successfully.",
        ),
      );

      await setLogin();

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const CreateProfileScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'The password provided is too weak.',
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'The account already exists for that email.',
          ),
        );
      }
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign In with email and password
  Future<void> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showTopSnackBar(
        displayDuration: const Duration(milliseconds: 500),
        Overlay.of(context),
        const CustomSnackBar.info(
          message: "Signed in successfully.",
        ),
      );

      // await setLogin();

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const CreateProfileScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'No user found for that email.',
          ),
        );
      } else if (e.code == 'wrong-password') {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Wrong password provided for that user.',
          ),
        );
      }
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save User Data in firestore
  Future<void> saveUserData({
    required UserModel userModel,
    required File profilePic,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    var userPhone = userModel.phoneNumber;
    await storeFileToStorage("profilePic/$userPhone", profilePic).then(
      (value) {
        try {
          userModel.photoUrl = value;
          userModel.uid = _firebaseAuth.currentUser!.uid;
          _firestore
              .collection('AllUsers')
              .doc(userModel.uid)
              .collection("profile")
              .add(userModel.toMap());
          showTopSnackBar(
            displayDuration: const Duration(milliseconds: 500),
            Overlay.of(context),
            const CustomSnackBar.info(
              message: "Profile created successfully.",
            ),
          );

          // Set Profile Created
          setProfileCreated();

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CreateAcademicProfile(),
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
          });
        } catch (e) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: e.toString(),
            ),
          );
        } finally {
          _isLoading = false;
          notifyListeners();
        }
      },
    );
  }

  // Save Image to Firebase Storage
  Future<String> storeFileToStorage(String ref, File file) async {
    try {
      UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint(downloadUrl);
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  // Set Profile Created
  Future<void> setProfileCreated() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isProfileCreated', true);
    _isProfileCreated = true;
    notifyListeners();

    print("Profile Created");
  }

  // Get Profile from firebase
  Future<String?> getUserName() async {
    String userName = "";

    try {
      var user = _firebaseAuth.currentUser;
      var data = await _firestore
          .collection('AllUsers')
          .doc(user!.uid)
          .collection("profile")
          .get();

      if (data.docs.isNotEmpty) {
        var userModel = UserModel.fromMap(data.docs.first.data());
        userName = userModel.name;
      } else {
        userName = "";
      }
    } catch (e) {}

    return userName;
  }

  // Update User Model in firestore
  Future<void> createAcademicProfile({
    required UserModel userModel,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var user = _firebaseAuth.currentUser;
      userModel.uid = user!.uid;
      var profileCollection = await _firestore
          .collection('AllUsers')
          .doc(user.uid)
          .collection("profile")
          .get();

      if (profileCollection.docs.isNotEmpty) {
        var profileDocId = profileCollection.docs.first.id;

        _firestore
            .collection('AllUsers')
            .doc(user.uid)
            .collection("profile")
            .doc(profileDocId)
            .set(userModel.toMap(), SetOptions(merge: true));
      } else {
        await _firestore
            .collection('AllUsers')
            .doc(user.uid)
            .collection("profile")
            .add(userModel.toMap());
      }

      showTopSnackBar(
        displayDuration: const Duration(milliseconds: 500),
        Overlay.of(context),
        const CustomSnackBar.info(
          message: "Academic profile created successfully.",
        ),
      );

      // Set Profile Created
      setAcademicCreated();

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      });
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setAcademicCreated() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isAcademicCreated', true);
    _isAcademicCreated = true;
    notifyListeners();

    print("Academic Created");
  }

  // Sign Out
  Future<void> signOut(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    await _firebaseAuth.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLoggedIn', false);
    // Put Some Delay
    await Future.delayed(const Duration(seconds: 2));

    _isLoggedIn = false;
    _isLoading = false;
    notifyListeners();

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const EmailVerificationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
      (route) => false,
    );
  }
}
