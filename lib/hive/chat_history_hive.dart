import 'package:hive/hive.dart';

part 'chat_history_hive.g.dart';

@HiveType(typeId: 0)
class ChatHistoryHive {
  @HiveField(0)
  final String chatId;
  @HiveField(1)
  final String prompt;
  @HiveField(2)
  final DateTime response;
  @HiveField(3)
  final List<String> images;
  @HiveField(4)
  final DateTime timestamp;

  // Constructor
  ChatHistoryHive({
    required this.chatId,
    required this.prompt,
    required this.response,
    required this.images,
    required this.timestamp,
  });
}
