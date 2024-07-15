import 'package:academix/constants/constants.dart';
import 'package:academix/helpers/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../helpers/helper_class.dart';
import '../../model/user_model.dart';
import '../../providers/auth_provider.dart' as authProvider;

class CreateAcademicProfile extends StatefulWidget {
  const CreateAcademicProfile({super.key});

  @override
  State<CreateAcademicProfile> createState() => _CreateAcademicProfileState();
}

class _CreateAcademicProfileState extends State<CreateAcademicProfile> {
  UserModel? userModel;

  // FocusNode
  final FocusNode _facultyNode = AlwaysDisabledFocusNode();
  final FocusNode _departmentNode = AlwaysDisabledFocusNode();
  final FocusNode _currentYear = AlwaysDisabledFocusNode();

  // Controllers
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _currentYearController = TextEditingController();

  // List of Faculties
  final List<String> faculties = [
    'Engineering and Technology',
    'Humanities and Social Sciences',
    'Health Sciences',
    'Business and Economics',
    'Natural Sciences',
    'Arts and Design',
  ];

  // List of Departments
  final Map<String, List<String>> departments = {
    "Engineering and Technology": [
      "Computer Engineering",
      "Electrical Engineering",
      "Civil Engineering",
      "Mechanical Engineering",
      "Robotics and Automation"
    ],
    "Humanities and Social Sciences": [
      "Psychology",
      "Sociology",
      "Political Science",
      "History",
      "Philosophy"
    ],
    "Health Sciences": [
      "Medicine",
      "Nursing",
      "Pharmacy",
      "Public Health",
      "Biomedical Sciences"
    ],
    "Business and Economics": [
      "Finance",
      "Marketing",
      "Accounting",
      "Management",
      "Economics"
    ],
    "Natural Sciences": [
      "Physics",
      "Chemistry",
      "Biology",
      "Mathematics",
      "Environmental Science"
    ],
    "Arts and Design": [
      "Graphic Design",
      "Fine Arts",
      "Fashion Design",
      "Interior Design",
      "Performing Arts"
    ],
  };

  // Current Year
  final List<String> currentYear = [
    'SEM 1',
    'SEM 2',
    'SEM 3',
    'SEM 4',
    'SEM 5',
    'SEM 6',
    'SEM 7',
    'SEM 8',
  ];

  // Get the userData from firebase
  void getUserData() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      var user = firebaseAuth.currentUser;
      var data = await firestore
          .collection('AllUsers')
          .doc(user!.uid)
          .collection("profile")
          .get();

      if (data.docs.isNotEmpty) {
        userModel = UserModel.fromMap(data.docs.first.data());
      } else {}
    } catch (e) {}
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<authProvider.AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<authProvider.AuthProvider>(context, listen: true).isLoading;
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
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  'Setup Your Educational Profile',
                  style: Constants.heading3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/animations/world_graduation_cap.json',
              height: 200,
              width: 200,
              repeat: false,
            ),
            //
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 20),
              height: 40,
              child: GestureDetector(
                onTap: () {
                  _showFacultyModalBottomSheet(context);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    focusNode: _facultyNode,
                    controller: _facultyController,
                    cursorColor: Colors.black.withOpacity(0.5),
                    cursorWidth: 1.0,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 10.0,
                      ),
                      hintText: 'Select Your Faculty',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
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
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 20),
              height: 40,
              child: GestureDetector(
                onTap: () {
                  _showDepartmentModalBottomSheet(context);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    cursorColor: Colors.black.withOpacity(0.5),
                    focusNode: _departmentNode,
                    controller: _departmentController,
                    cursorWidth: 1.0,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 10.0,
                      ),
                      hintText: 'Select Your Department',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
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
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 20),
              height: 40,
              child: GestureDetector(
                onTap: () {
                  _showCurrentYearModalBottomSheet(context);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextFormField(
                    cursorColor: Colors.black.withOpacity(0.5),
                    cursorWidth: 1.0,
                    focusNode: _currentYear,
                    controller: _currentYearController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 10.0,
                      ),
                      hintText: 'Select Your Current Academic Year',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
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
                : Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      onPressed: () {
                        //  Add fields to user Model
                        if (_facultyController.text.isEmpty) {
                          HelperFunctions.showInfoTopBar(
                              context, 'Please select a faculty');
                          return;
                        } else if (_departmentController.text.isEmpty) {
                          HelperFunctions.showInfoTopBar(
                              context, 'Please select a department');
                          return;
                        } else if (_currentYearController.text.isEmpty) {
                          HelperFunctions.showInfoTopBar(
                              context, 'Please select a current year');
                          return;
                        }
                        userModel!.faculty = _facultyController.text;
                        userModel!.department = _departmentController.text;
                        userModel!.currentYear = _currentYearController.text;
                        userModel!.updatedAt = Timestamp.now();

                        ap.createAcademicProfile(
                          userModel: userModel!,
                          context: context,
                        );
                      },
                      child: Text(
                        'Save',
                        style: Constants.body.copyWith(
                          color: Constants.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Helper Function for bottomsheet

  void _showFacultyModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        int selectedRadio = -1; // Initial value for selected radio button

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select Faculty',
                        style: Constants.heading3.copyWith(
                          color: Colors.black,
                        )),
                    const SizedBox(height: 16.0),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: faculties.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            value: index,
                            groupValue: selectedRadio,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedRadio = newValue!;
                              });
                              print('Selected Radio: $selectedRadio');
                            },
                            title: Text(
                              faculties[index],
                              style: Constants.body.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            activeColor: Constants.primaryColor,
                            controlAffinity: ListTileControlAffinity.trailing,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _facultyController.text = faculties[selectedRadio];
                        _departmentController.text = '';
                        _currentYearController.text = '';
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDepartmentModalBottomSheet(BuildContext context) {
    if (_facultyController.text.isEmpty) {
      HelperFunctions.showInfoTopBar(context, 'Please select a faculty first');
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        int selectedRadio = -1; // Initial value for selected radio button

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select Department',
                        style: Constants.heading3.copyWith(
                          color: Colors.black,
                        )),
                    const SizedBox(height: 16.0),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: departments[_facultyController.text]!.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            value: index,
                            groupValue: selectedRadio,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedRadio = newValue!;
                              });
                              print('Selected Radio: $selectedRadio');
                            },
                            title: Text(
                              departments[_facultyController.text]![index],
                              style: Constants.body.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            activeColor: Constants.primaryColor,
                            controlAffinity: ListTileControlAffinity.trailing,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _departmentController.text = departments[
                            _facultyController.text]![selectedRadio];
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCurrentYearModalBottomSheet(BuildContext context) {
    if (_departmentController.text.isEmpty) {
      HelperFunctions.showInfoTopBar(
          context, 'Please select a department first');
      return;
    } else if (_facultyController.text.isEmpty) {
      HelperFunctions.showInfoTopBar(context, 'Please select a faculty first');
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        int selectedRadio = -1; // Initial value for selected radio button

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select Current Year',
                        style: Constants.heading3.copyWith(
                          color: Colors.black,
                        )),
                    const SizedBox(height: 16.0),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: currentYear.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            value: index,
                            groupValue: selectedRadio,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedRadio = newValue!;
                              });
                              print('Selected Radio: $selectedRadio');
                            },
                            title: Text(
                              currentYear[index],
                              style: Constants.body.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            activeColor: Constants.primaryColor,
                            controlAffinity: ListTileControlAffinity.trailing,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _currentYearController.text =
                            currentYear[selectedRadio];
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
