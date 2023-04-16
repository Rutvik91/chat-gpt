import 'package:aichat/page/sub_category_screen.dart';
import 'package:aichat/utils/Chatgpt.dart';
import 'package:aichat/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Choose category',
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
            ChatGPT.categories.length,
            (index) => renderItemWidget(
              ChatGPT.categories[index]['name'],
              ChatGPT.categories[index]['id'],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderItemWidget(
    String title,
    String id,
  ) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        showCupertinoModalBottomSheet(
          context: Get.context!,
          builder: (context) => SubCategoryScreen(id: id),
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Config.primary,
              borderRadius: BorderRadius.circular(20),
            ),
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
                Row(
                  children: const [
                    Image(
                      image: AssetImage("images/arrow_icon.png"),
                      width: 18,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
