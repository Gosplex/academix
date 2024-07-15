import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class PhonePermissionScreen extends StatefulWidget {
  const PhonePermissionScreen({super.key});

  @override
  State<PhonePermissionScreen> createState() => _PhonePermissionScreenState();
}

class _PhonePermissionScreenState extends State<PhonePermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            'Enable Phone Permissions',
            style: Constants.heading3,
          ),
        ),
        body: Column(
          children: [
            // ListView of permissions
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  ListTile(
                    splashColor: Colors.transparent,
                    enableFeedback: true,
                    minTileHeight: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.7),
                        width: 0.5,
                      ),
                    ),
                    onTap: () {},
                    leading: const Icon(
                      CupertinoIcons.location,
                      color: Colors.black,
                      size: 18,
                    ),
                    title: Text(
                      'Location Permission',
                      style: Constants.body,
                    ),
                    subtitle: Text(
                      'Allow Academix to access your location',
                      style: Constants.body.copyWith(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  ListTile(
                    splashColor: Colors.transparent,
                    enableFeedback: true,
                    minTileHeight: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.7),
                        width: 0.5,
                      ),
                    ),
                    onTap: () {},
                    leading: const Icon(
                      CupertinoIcons.bell,
                      color: Colors.black,
                      size: 18,
                    ),
                    title: Text(
                      'Notification Permission',
                      style: Constants.body,
                    ),
                    subtitle: Text(
                      'Allow Academix to send you notifications',
                      style: Constants.body.copyWith(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                  ListTile(
                    splashColor: Colors.transparent,
                    enableFeedback: true,
                    minTileHeight: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.7),
                        width: 0.5,
                      ),
                    ),
                    onTap: () {},
                    leading: const Icon(
                      CupertinoIcons.mic,
                      color: Colors.black,
                      size: 18,
                    ),
                    title: Text(
                      'Microphone Permission',
                      style: Constants.body,
                    ),
                    subtitle: Text(
                      'Allow Academix to access your microphone',
                      style: Constants.body.copyWith(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.white,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 0),
        //     width: double.infinity,
        //     height: 60,
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Constants.primaryColor,
        //         shape: const RoundedRectangleBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(5)),
        //         ),
        //       ),
        //       onPressed: () {},
        //       child: Text(
        //         'Continue ',
        //         style: Constants.body.copyWith(
        //           color: Constants.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
