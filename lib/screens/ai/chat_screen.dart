import 'package:academix/constants/constants.dart';
import 'package:academix/helpers/helper_functions.dart';
import 'package:academix/model/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../providers/chat_provider.dart';
import '../../widgets/image/preview_image.dart';
import '../main/home_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _blinkingController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _blinkingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_blinkingController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _blinkingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollMessage() {
    // Remove focus and close the keyboard
    _focusNode.unfocus();
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _sendTextMessage() {
    if (_controller.text.isNotEmpty) {
      bool hasImage = Provider.of<ChatProvider>(context, listen: false)
          .imageUrls!
          .isNotEmpty;
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      try {
        chatProvider
            .sendMessage(
          message: _controller.text,
          isTextOnly: hasImage ? false : true,
        )
            .then(
          (_) {
            setState(() {
              Provider.of<ChatProvider>(context, listen: false).setImageUrls(
                imageUrls: [],
              );
            });
          },
        );
      } catch (e) {
        print(e);
      } finally {
        _controller.clear();
      }
    } else {
      return;
    }
  }

  void _pickImage() async {
    // Initialize Chat Provider
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (chatProvider.imageUrls!.isNotEmpty) {
      HelperFunctions.showAnimatedDialog(
        context,
        title: 'Delete Image',
        content: 'Are you sure you want to delete this image?',
        actionText: 'Yes',
        onAction: (bool value) {
          if (value) {
            setState(() {
              chatProvider.setImageUrls(
                imageUrls: [],
              );
            });
          }
        },
      );
    } else {
      HelperFunctions.pickMultipleImages().then(
        (value) {
          chatProvider.setImageUrls(imageUrls: value);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        bool hasImage = chatProvider.imageUrls!.isNotEmpty ? true : false;
        if (chatProvider.inChatMessages.isNotEmpty) {
          _scrollMessage();
        }

        chatProvider.addListener(() {
          if (chatProvider.inChatMessages.isNotEmpty) {
            _scrollMessage();
          }
        });

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Constants.primaryColor,
              elevation: 4,
              scrolledUnderElevation: 0,
              toolbarHeight: 70.0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    ),
                  )),
              titleSpacing: 0.0,
              title: Row(
                children: [
                  const CustomPaint(
                    painter: DashedCirclePainter(Colors.white),
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: Center(
                            child: Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chat with Gemini',
                        style: Constants.body.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          FadeTransition(
                            opacity: _animation,
                            child: const Icon(
                              Icons.circle,
                              color: Colors.green,
                              size: 10,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Online',
                            style: Constants.body.copyWith(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: chatProvider.inChatMessages.isEmpty
                        ? Center(
                            child: Text(
                              'Start a conversation with Gemini',
                              style: Constants.body.copyWith(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: chatProvider.inChatMessages.length,
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            itemBuilder: (context, index) {
                              final message =
                                  chatProvider.inChatMessages[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      message.role == Role.assistant
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: message.role == Role.user
                                              ? Constants.primaryColor
                                              : Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: message.message.isEmpty
                                            ? SizedBox(
                                                width: 50,
                                                child: SpinKitThreeBounce(
                                                  color:
                                                      message.role == Role.user
                                                          ? Colors.white
                                                          : Colors.black,
                                                  size: 20,
                                                ))
                                            : MarkdownBody(
                                                data:
                                                    message.message.toString(),
                                                styleSheet: MarkdownStyleSheet(
                                                  p: Constants.body.copyWith(
                                                    color: message.role ==
                                                            Role.user
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),

                  // Input Field
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Constants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        hasImage ? const PreviewImage() : const SizedBox(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image Picker
                            IconButton(
                              onPressed: _pickImage,
                              icon: Icon(
                                hasImage ? Icons.delete_forever : Icons.image,
                                color: Constants.primaryColor,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  border: InputBorder.none,
                                  hintStyle: Constants.body.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _sendTextMessage,
                              icon: const Icon(
                                Icons.send,
                                color: Constants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
