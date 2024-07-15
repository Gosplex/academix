import 'package:hive/hive.dart';

part 'user_model_hive.g.dart';

@HiveType(typeId: 1)
class UserModelHive extends HiveObject {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final DateTime timestamp;

  // Constructor
  UserModelHive({
    required this.uid,
    required this.name,
    required this.imageUrl,
    required this.timestamp,
  });
  
}