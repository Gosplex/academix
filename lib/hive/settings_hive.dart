import 'package:hive/hive.dart';

part 'settings_hive.g.dart';

@HiveType(typeId: 2)
class SettingsHive {
  @HiveField(0)
  bool shouldSpeak = false;

  // Constructor
  SettingsHive({
    required this.shouldSpeak,
  });
}
