import 'dart:io';

import 'package:aichat/page/ChatHistoryPage.dart';
import 'package:aichat/page/purchase_screen.dart';
import 'package:aichat/page/terms_and_conditions.dart';
import 'package:aichat/utils/Chatgpt.dart';
import 'package:aichat/utils/Config.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share_plus/share_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with WidgetsBindingObserver {
  bool isCopying = false;
  final TextEditingController _keyTextEditingController =
      TextEditingController();
  final TextEditingController _urlTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Switch from background to foreground, the interface is visible.
        break;
      case AppLifecycleState.paused:

        /// TODO: Switch from foreground to background, the interface is not visible.
        break;
      case AppLifecycleState.inactive:

        /// TODO: Handle this case.
        break;
      case AppLifecycleState.detached:

        /// TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.white,
              highlightColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 60,
                child: Row(
                  children: const [
                    SizedBox(width: 24),
                    Image(
                      width: 18,
                      image: AssetImage('images/back_icon.png'),
                      color: Colors.white,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Setting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Config.primary,
        elevation: 0.5,
      ),
      backgroundColor: Config.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (context) => PurchaseScreen(),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Colors.amberAccent,
                      size: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Premium hasn't been activated yet",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Tap to upgrade",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            renderItemWidget(
              'images/privacy_policy_icon.png',
              icon: true,
              Colors.teal,
              32,
              'History',
              () {
                Utils.jumpPage(context, const ChatHistoryPage());
              },
            ),
            renderItemWidget(
              'images/privacy_policy_icon.png',
              Colors.red,
              32,
              'Privacy Policy',
              () {
                Utils.jumpPage(
                    context,
                    const TermsAndConditions(
                        url:
                            "https://www.termsfeed.com/live/f2b86595-49c9-41e7-b807-871b3cd9d989"));
              },
            ),
            renderItemWidget(
              'images/share_icon.png',
              Colors.green,
              26,
              'Share App',
              () {
                Share.share(
                  Platform.isAndroid
                      ? 'https://play.google.com/store/apps/details?id=com.binarybox.chatbuddy'
                      : "https://apps.apple.com/app/id***",
                );
              },
            ),
            renderItemWidget(
              'images/star_icon.png',
              Colors.amber,
              26,
              'Rating App',
              () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => RatingDialog(
                    initialRating: 5.0,
                    title: const Text(
                      'Did you like the app?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    message: const Text(
                      'Tap a star to set your rating. Add more description here if you want.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ),
                    image: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      clipBehavior: Clip.antiAlias,
                      child: const Image(
                        width: 52,
                        height: 52,
                        image: AssetImage('images/logo.png'),
                      ),
                    ),
                    submitButtonText: 'Submit',
                    commentHint: 'Set your custom comment hint',
                    onCancelled: () => print('cancelled'),
                    onSubmitted: (response) {
                      print(
                          'rating: ${response.rating}, comment: ${response.comment}');
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget renderItemWidget(
    String iconPath,
    Color iconBgColor,
    double iconSize,
    String title,
    GestureTapCallback back, {
    String rightIconSrc = 'images/arrow_icon.png',
    bool icon = false,
  }) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: back,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Config.primary, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: icon
                            ? const Icon(
                                Icons.history,
                                color: Colors.white,
                              )
                            : Image(
                                image: AssetImage(iconPath),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
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
                if (rightIconSrc != '')
                  Row(
                    children: [
                      Image(
                        image: AssetImage(rightIconSrc),
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

  @override
  void dispose() {
    super.dispose();
  }

  void _showCustomOpenAIKeyDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Custom OpenAI Key'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _keyTextEditingController,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Please input your key'),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  if (isCopying) {
                    return;
                  }
                  isCopying = true;
                  await Clipboard.setData(
                    const ClipboardData(
                      text: 'https://platform.openai.com/',
                    ),
                  );
                  EasyLoading.showToast(
                    'Copy successfully!',
                    dismissOnTap: true,
                  );
                  isCopying = false;
                },
                child: SingleChildScrollView(
                  child: Wrap(
                    children: const [
                      Text(
                        '* Custom key can use the APP without restrictions.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(220, 0, 0, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* You will get the APP version without ads.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(220, 0, 0, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* The AI Chat APP does not collect this key.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* The Key we provide may report an error, and custom keys need to be created at https://platform.openai.com/ .',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '* Click Copy URL.',
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: Color.fromRGBO(126, 126, 126, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _keyTextEditingController.clear();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                ChatGPT.setOpenAIKey(_keyTextEditingController.text).then((_) {
                  _keyTextEditingController.clear();
                  Navigator.of(context).pop(true);
                  EasyLoading.showToast(
                    'Successful setting!',
                    dismissOnTap: true,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showCustomOpenAIUrlDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Custom OpenAI Base URL'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _urlTextEditingController,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Please input your OpenAI host'),
              ),
              const SizedBox(height: 12),
              Wrap(
                children: const [
                  Text(
                    "You can set openai host where access to the official OpenAI host is restricted or unavailable, "
                    "allowing you to configure an alternative host for the specific needs.\n"
                    "Use https://api.openai.com by default.",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "This option is only applied when you provide a custom apiKey.",
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _urlTextEditingController.clear();
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                ChatGPT.setOpenAIBaseUrl(_urlTextEditingController.text)
                    .then((_) {
                  _urlTextEditingController.clear();
                  Navigator.of(context).pop(true);
                  EasyLoading.showToast(
                    'Successful setting!',
                    dismissOnTap: true,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
