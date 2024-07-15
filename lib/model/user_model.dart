// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String name;
  String phoneNumber;
  String photoUrl;
  String? fcmToken;
  String? faculty;
  String? department;
  String? stream;
  String? currentYear;
  String? currentclass;
  Timestamp createdAt;
  Timestamp updatedAt;
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.photoUrl,
    this.fcmToken,
    this.faculty,
    this.department,
    this.stream,
    this.currentYear,
    this.currentclass,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'fcmToken': fcmToken,
      'faculty': faculty,
      'department': department,
      'stream': stream,
      'currentYear': currentYear,
      'currentclass': currentclass,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: map['photoUrl'] as String,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      faculty: map['faculty'] != null ? map['faculty'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      stream: map['stream'] != null ? map['stream'] as String : null,
      currentYear:
          map['currentYear'] != null ? map['currentYear'] as String : null,
      currentclass:
          map['currentclass'] != null ? map['currentclass'] as String : null,
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: map['updatedAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
