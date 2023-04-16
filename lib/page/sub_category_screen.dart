import 'package:aichat/page/ChatPage.dart';
import 'package:aichat/utils/Chatgpt.dart';
import 'package:aichat/utils/Config.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({
    super.key,
    required this.id,
  });
  final String id;
  @override
  Widget build(BuildContext context) {
    List tips = ChatGPT.categories
        .where((element) => element['id'] == id)
        .first['tips'];
    return Scaffold(
      backgroundColor: Config.background,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear, color: Colors.white),
            ),
          ),
          const Text(
            'Choose',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...List.generate(
            tips.length,
            (index) => renderItemWidget(
              tips[index],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderItemWidget(
    String title,
  ) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Utils.jumpPage(
          Get.context!,
          ChatPage(
            chatId: const Uuid().v4(),
            showAppbar: true,
            autofocus: false,
            text: title,
            chatType: 'chat',
          ),
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
