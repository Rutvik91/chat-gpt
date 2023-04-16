import 'package:aichat/page/ChatPage.dart';
import 'package:aichat/page/purchase_controller.dart';
import 'package:aichat/page/purchase_screen.dart';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:aichat/utils/Config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController questionController = TextEditingController();
  String chatId = const Uuid().v4();
  final PurchaseController _purchaseController = Get.find();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_purchaseController.proUser.value) {
        showCupertinoModalBottomSheet(
          context: Get.context!,
          isDismissible: false,
          enableDrag: false,
          builder: (context) => PurchaseScreen(),
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: Container(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                builder: (context) => PurchaseScreen(),
              );
            },
            icon: const Icon(Icons.workspace_premium_rounded),
            color: Config.primary2,
          ),
        ),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const SizedBox(width: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              clipBehavior: Clip.antiAlias,
              child: const Image(
                width: 36,
                height: 36,
                image: AssetImage('images/logo.png'),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              Config.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1,
              ),
            ),
          ],
        ),
        backgroundColor: Config.primary,
        elevation: 0.5,
      ),
      backgroundColor: Config.background,
      resizeToAvoidBottomInset: false,
      body: ChatPage(
        showAppbar: false,
        chatId: chatId,
        autofocus: true,
        chatType: 'chat',
      ),
    );
  }

  Widget _renderTitle(
    String text, {
    Widget? rightContent,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Config.primary2,
              fontSize: 22,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (rightContent != null) rightContent,
        ],
      ),
    );
  }
}
