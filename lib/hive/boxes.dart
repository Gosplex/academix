import 'package:academix/constants/constants.dart';
import 'package:hive/hive.dart';

import 'chat_history_hive.dart';
import 'settings_hive.dart';
import 'user_model_hive.dart';

class Boxes {
  // Get ChatHistoryHive box
  static Box<ChatHistoryHive> getChatHistory() =>
      Hive.box<ChatHistoryHive>(Constants.chatHistoryBox);

  // Get SettingsHive box
  static Box<SettingsHive> getSettings() =>
      Hive.box<SettingsHive>(Constants.settingsBox);

  // Get UserModelHive box
  static Box<UserModelHive> getUserModel() =>
      Hive.box<UserModelHive>(Constants.userModelBox);
}
