import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const Color primaryColor = Color(0xFF3F51B5); // #00A6BE  // #181820 (Dark Mode Button) // #2d2d35 (Dark Mode Background)
  static const Color secondaryColor = Color(0xFF57A59F); // #57A59F
  static const Color grey = Color(0xFFB7B9BE); // #B7B9BE
  static const Color white = Color(0xFFFFFFFF); // #FFFFFF

  // Text Styles Heading
  static final TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Text Styles Body
  static final TextStyle body = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );


  // Hives Boxes
  static const String chatHistoryBox= 'chat_history';
  static const String settingsBox = 'settings';
  static const String userModelBox = 'user_box';

  static const String chatMessagesBox = 'chat_messages';

  static const String geminiDB = 'gemini.db';
}
