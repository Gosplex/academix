import 'dart:io';

import 'package:academix/model/message_model.dart';
import 'package:academix/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({super.key, this.message});

  final MessageModel? message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageToShow =
            message != null ? message!.imageUrls : chatProvider.imageUrls;
        final padding = message != null
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              );

        return Padding(
          padding: padding,
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: messageToShow!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(
                        message != null
                            ? message!.imageUrls[index]
                            : chatProvider.imageUrls![index].path,
                      ),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
