import 'dart:async';
import 'dart:typed_data';

import 'package:academix/api/api_services.dart';
import 'package:academix/constants/constants.dart';
import 'package:academix/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

import '../hive/chat_history_hive.dart';
import '../hive/settings_hive.dart';
import '../hive/user_model_hive.dart';

class ChatProvider extends ChangeNotifier {
  List<MessageModel> _inChatMessages = [];
  List<XFile>? _imageUrls = [];
  String _currentChatId = '';
  GenerativeModel? _model;
  GenerativeModel? _textModel;
  GenerativeModel? _visionModel;
  String _modelType = 'gemini-pro';
  bool _isLoaded = false;

  // Getters
  List<MessageModel> get inChatMessages => _inChatMessages;
  List<XFile>? get imageUrls => _imageUrls;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;
  bool get isLoaded => _isLoaded;

  // Setters
  Future<void> setinChatMessages({required String chatId}) async {
    //  Get Messages From HIVE Database
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);

    for (var messages in messagesFromDB) {
      if (!_inChatMessages.contains(messages)) {
        _inChatMessages.add(messages);
      }
    }
    _currentChatId = chatId;
    notifyListeners();
  }

  Future<List<MessageModel>> loadMessagesFromDB(
      {required String chatId}) async {
    final messagesBox =
        await Hive.openBox('${Constants.chatMessagesBox}_$chatId');

    final newData = messagesBox.keys.map((key) {
      final message = messagesBox.get(key);
      final messageData =
          MessageModel.fromMap(Map<String, dynamic>.from(message));
      return messageData;
    }).toList();

    notifyListeners();

    return newData;
  }

  // set Image Urls
  void setImageUrls({required List<XFile> imageUrls}) {
    _imageUrls = imageUrls;
    notifyListeners();
  }

  String setCurrentModel({required String modelType}) {
    _modelType = modelType;
    notifyListeners();
    return _modelType;
  }

  // Set Model if it's textOnly

  Future<void> setModel({required bool isTextOnly}) async {
    if (isTextOnly) {
      _model = _textModel ??
          GenerativeModel(
            model: setCurrentModel(modelType: 'gemini-pro'),
            apiKey: ApiServices.apiKey,
          );
    } else {
      _model = _visionModel ??
          GenerativeModel(
            model: setCurrentModel(modelType: 'gemini-1.5-flash'),
            apiKey: ApiServices.apiKey,
          );
    }
    notifyListeners();
  }

  // Set Current Chat Id
  void setCurrentChatId({required String chatId}) {
    _currentChatId = chatId;
    notifyListeners();
  }

  // Set Loading
  void setLoading({required bool isLoading}) {
    _isLoaded = isLoading;
    notifyListeners();
  }

  // Send Message
  Future<void> sendMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    await setModel(isTextOnly: isTextOnly);
    setLoading(isLoading: true);
    String chatId = getChatId();
    List<Content> history = [];

    history = await getHistory(chatId: chatId);

    // Get Images
    List<String> imageUrls = getImageUrls(isTextOnly: isTextOnly);

    // UserMessage ID
    final userMessageId = const Uuid().v4();

    // User's Message
    final userMessage = MessageModel(
      chatId: chatId,
      imageUrls: imageUrls,
      message: StringBuffer(message),
      messageId: userMessageId,
      role: Role.user,
      timeSent: DateTime.now(),
    );

    // Print User Message Image
    print('User Message Image: $imageUrls');

    _inChatMessages.add(userMessage);
    notifyListeners();

    if (_currentChatId.isEmpty) {
      setCurrentChatId(chatId: chatId);
    }

    // Send  Message to model and wait for response
    await sendMessageAndWaitForResponse(
      message: message,
      chatId: chatId,
      history: history,
      userMessage: userMessage,
      isTextOnly: isTextOnly,
    );
  }

  // Send Message and Wait for Response
  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required List<Content> history,
    required MessageModel userMessage,
    required bool isTextOnly,
  }) async {
    final chatSession = _model!.startChat(
      history: history.isEmpty || isTextOnly ? null : history,
    );

    // Get Content
    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    final assistantMessageId = const Uuid().v4();

    // Assistant Message
    final assistantMessage = userMessage.copyWith(
      messageId: assistantMessageId,
      message: StringBuffer(''),
      role: Role.assistant,
      timeSent: DateTime.now(),
    );

    // Add Assistant Message to Chat
    _inChatMessages.add(assistantMessage);
    notifyListeners();

    // Wait for Streamed Response
    chatSession.sendMessageStream(content).asyncMap(
      (event) {
        return event;
      },
    ).listen((event) {
      _inChatMessages
          .firstWhere((element) =>
              element.messageId == assistantMessage.messageId &&
              element.role == Role.assistant)
          .message
          .write(event.text);
      notifyListeners();
    }).onDone(() {
      setLoading(isLoading: false);
    });
  }

  // Get Image Urls
  List<String> getImageUrls({required bool isTextOnly}) {
    List<XFile>? imageUrls = [];
    if (!isTextOnly && _imageUrls != null) {
      for (var image in _imageUrls!) {
        imageUrls.add(image);
      }
    }
    return imageUrls.map((e) => e.path).toList();
  }

  Future<Content> getContent(
      {required String message, required bool isTextOnly}) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageFutures = _imageUrls!
          .map((image) => image.readAsBytes())
          .toList(growable: false);
      final imageBytes = await Future.wait(imageFutures);
      final prompt = TextPart(message);
      final imageParts = imageBytes
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }

  String getChatId() {
    if (_currentChatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return _currentChatId;
    }
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];

    if (currentChatId.isNotEmpty) {
      await setinChatMessages(chatId: chatId);

      for (var message in _inChatMessages) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }

    return history;
  }

  // init Hive
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    if (Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryHiveAdapter());

      // Open Chat History Box
      await Hive.openBox<ChatHistoryHive>(Constants.chatHistoryBox);
    }

    // Register UserModel Box
    if (Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelHiveAdapter());
      await Hive.openBox<UserModelHive>(Constants.userModelBox);
    }

    // Register Settings Box
    if (Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsHiveAdapter());
      await Hive.openBox<SettingsHive>(Constants.settingsBox);
    }
  }
}
