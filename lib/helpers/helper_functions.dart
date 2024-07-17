import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constants/constants.dart';

class HelperFunctions {
  // Single Image
  static Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 95,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      // Handle the case when no image is picked.
      print('No image selected.');
      return null;
    }
  }

  // Multiple Images
  static Future<List<XFile>> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      imageQuality: 95,
      maxWidth: 800,
      maxHeight: 800,
    );

    return pickedFiles;
  }

  // Show Top Snack Bar
  static showInfoTopBar(BuildContext context, String message) {
    showTopSnackBar(
      displayDuration: const Duration(milliseconds: 500),
      Overlay.of(context),
      CustomSnackBar.info(
        message: message,
      ),
    );
  }

  // Show Confirmation Bottom Sheet
  static void showConfirmationBottomSheet(
    BuildContext context, {
    required VoidCallback onPressed1,
    required VoidCallback onPressed2,
    IconData? icon1,
    IconData? icon2,
    required String title1,
    required String title2,
    required String message,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // No border radius
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Constants.primaryColor,
                  thickness: 4.0,
                  endIndent: 320.0,
                  height: 20.0,
                ),
                Text(
                  message,
                  style: Constants.body.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onPressed1,
                  icon: Icon(
                    icon1,
                    color: Colors.green.withOpacity(0.8),
                  ),
                  label: Text(
                    title1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onPressed2,
                  icon: Icon(
                    icon2,
                    color: Colors.red.withOpacity(0.8),
                  ),
                  label: Text(
                    title2,
                    style: Constants.body.copyWith(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show AnimatedDialog
  static void showAnimatedDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String actionText,
    required Function(bool) onAction,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Constants.heading3.copyWith(
                    color: Constants.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  style: Constants.body.copyWith(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        onAction(true);
                        Navigator.pop(context);
                      },
                      child: Text(
                        actionText,
                        style: Constants.body.copyWith(
                          color: Constants.primaryColor,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onAction(false);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'No',
                        style: Constants.body.copyWith(
                          color: Colors.red.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Convert from DateTime to String and format the date to AM or PM
  static String formatDateTime(DateTime dateTime) {
    final String formattedDate =
        '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final String formattedTime = '${dateTime.hour}:${dateTime.minute}';

    return '$formattedDate at $formattedTime';
  }
}
