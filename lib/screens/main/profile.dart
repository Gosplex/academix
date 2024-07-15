import 'package:academix/constants/constants.dart';
import 'package:academix/helpers/helper_functions.dart';
import 'package:academix/model/user_model.dart';
import 'package:academix/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../auth/phone_permissions_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    final isDarkmode = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (isLoading) {
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Constants.primaryColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                    },
              icon: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.white,
              ),
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              'PROFILE',
              style: Constants.heading3.copyWith(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
            centerTitle: true,
            actions: <Widget>[
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => HelperFunctions.showConfirmationBottomSheet(context,
                            onLogout: () {
                          ap.signOut(context);
                          Navigator.pop(context);
                        }, message: 'Are you sure you want to logout?'),
                child: Text(
                  'Logout',
                  style: Constants.body.copyWith(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 82.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                  ),
                  Positioned(
                    top: 75.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white.withOpacity(0.9),
                      ),
                      height: MediaQuery.of(context).size.height - 100.0,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: 30.0,
                    left: (MediaQuery.of(context).size.width / 2) - 65.0,
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.user.photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 230.0,
                    left: 18.0,
                    right: 18.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              'NAME',
                              style: Constants.body.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.0,
                              ),
                            ),
                            subtitle: Text(
                              widget.user.name.toUpperCase(),
                              style: Constants.body.copyWith(
                                color: Constants.primaryColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              'FACULTY',
                              style: Constants.body.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.0,
                              ),
                            ),
                            subtitle: Text(
                              widget.user.faculty!.toUpperCase(),
                              style: Constants.body.copyWith(
                                color: Constants.primaryColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              'DEPARTMENT',
                              style: Constants.body.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.0,
                              ),
                            ),
                            subtitle: Text(
                              widget.user.department!.toUpperCase(),
                              style: Constants.body.copyWith(
                                color: Constants.primaryColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              'LEVEL',
                              style: Constants.body.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.0,
                              ),
                            ),
                            subtitle: Text(
                              widget.user.currentYear!.toUpperCase(),
                              style: Constants.body.copyWith(
                                color: Constants.primaryColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            dense: true,
                            enableFeedback: true,
                            onTap: isLoading
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const PhonePermissionScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tween = Tween(
                                                  begin: begin, end: end)
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
                                  },
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Constants.primaryColor,
                              size: 16.0,
                            ),
                            title: Text(
                              'PERMISSIONS',
                              style: Constants.body.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.0,
                              ),
                            ),
                            subtitle: Text(
                              'MANAGE APP PERMISSIONS',
                              style: Constants.body.copyWith(
                                color: Constants.primaryColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              'DARK MODE',
                              style: Constants.body.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.0,
                              ),
                            ),
                            subtitle: Text(
                              'ENABLE DARK MODE',
                              style: Constants.body.copyWith(
                                color: Constants.primaryColor,
                                fontSize: 14.0,
                              ),
                            ),
                            trailing: CupertinoSwitch(
                              value:
                                  isDarkmode == ThemeMode.dark ? true : false,
                              activeColor: Constants.primaryColor,
                              onChanged: (bool value) {
                                setState(() {
                                  Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .toggleTheme();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isLoading,
                    child: Positioned(
                      top: MediaQuery.of(context).size.height - 250.0,
                      left: (MediaQuery.of(context).size.width / 2) - 50,
                      child: Center(
                        child: Lottie.network(
                          'https://lottie.host/cbf67e75-963a-428c-8aea-d6c27c2eb103/ypkPx4BGg8.json',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
