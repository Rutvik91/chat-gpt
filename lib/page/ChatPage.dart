import 'package:aichat/components/QuestionInput.dart';
import 'package:aichat/page/SettingPage.dart';
import 'package:aichat/page/category_screen.dart';
import 'package:aichat/stores/AIChatStore.dart';
import 'package:aichat/utils/Chatgpt.dart';
import 'package:aichat/utils/Config.dart';
import 'package:aichat/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final bool autofocus;
  final bool showAppbar;
  final String chatType;
  final String text;

  const ChatPage({
    Key? key,
    required this.chatId,
    required this.showAppbar,
    required this.autofocus,
    required this.chatType,
    this.text = '',
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

enum TtsState { playing, stopped, paused, continued }

class _ChatPageState extends State<ChatPage> {
  static final LottieBuilder _generatingLottie =
      Lottie.asset("images/loading2.json");

  final ScrollController _listController = ScrollController();

  late FlutterTts _flutterTts;
  TtsState _ttsState = TtsState.stopped;
  String _speakText = '';

  bool _isCopying = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> initTts() async {
    _flutterTts = FlutterTts();

    _setAwaitOptions();

    _flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        _ttsState = TtsState.playing;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        _ttsState = TtsState.stopped;
      });
    });

    _flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        _ttsState = TtsState.paused;
      });
    });

    _flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        _ttsState = TtsState.continued;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        _ttsState = TtsState.stopped;
      });
    });
  }

  Future _setAwaitOptions() async {
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _speak(String text) async {
    // 如果正在播放，则先停止
    if (_ttsState == TtsState.playing) {
      await _flutterTts.stop();
    }
    if (_speakText == text) {
      _speakText = '';
      return;
    }
    _speakText = text;
    await _flutterTts.speak(text);
  }

  @override
  void initState() {
    super.initState();

    initTts();

    // WidgetsBinding.instance.addPostFrameCallback((mag) {
    // print("页面渲染完毕");
    // scrollToBottom();
    // });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void scrollToBottom() {
    // _listController.animateTo(
    //   _listController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
    if (_listController.hasClients) {
      _listController.jumpTo(_listController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AIChatStore>(context, listen: true);
    final chat = store.getChatById(widget.chatType, widget.chatId);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: !(MediaQuery.of(context).viewInsets.bottom > 0) &&
              !(widget.showAppbar)
          ? FloatingActionButton(
              backgroundColor: Config.primary2,
              onPressed: () {},
              child: const Icon(Icons.chat_bubble),
            )
          : null,
      bottomNavigationBar: !widget.showAppbar
          ? BottomAppBar(
              color: Config.primary,
              shape: const CircularNotchedRectangle(),
              notchMargin: 10.0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.menu),
                    iconSize: 35,
                    color: Config.primary2,
                    onPressed: () {
                      showCupertinoModalBottomSheet(
                        context: context,
                        builder: (context) => CategoryScreen(),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 35,
                    color: Config.primary2,
                    onPressed: () {
                      Utils.jumpPage(context, const SettingPage());
                    },
                  ),
                ],
              ),
            )
          : null,
      appBar: widget.showAppbar
          ? AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              toolbarHeight: 60,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Row(
                children: [
                  InkWell(
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
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
                                "ChatGPT",
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
                      ],
                    ),
                  )
                ],
              ),
              backgroundColor: Config.primary,
              elevation: 0.5,
              actions: const [
                SizedBox(width: 20),
              ],
            )
          : null,
      backgroundColor: Config.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _renderMessageListWidget(
                chat['messages'],
              ),
            ),
            QuestionInput(
              key: widget.showAppbar ? null : globalQuestionInputKey,
              chat: chat,
              autofocus: false,
              enabled: true,
              text: widget.text,
              scrollToBottom: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  scrollToBottom();
                });
              },
            ),
            if (!widget.showAppbar)
              const SizedBox(
                height: 20,
              )
          ],
        ),
      ),
    );
  }

  Widget _renderMessageListWidget(List messages) {
    if (messages.isEmpty && widget.text.isEmpty) {
      Map aiData = ChatGPT.getAiInfoByType(widget.chatType);

      List<Widget> tipsWidget = [];
      for (int i = 0; i < aiData['tips'].length; i++) {
        String tip = aiData['tips'][i];
        tipsWidget.add(
          Ink(
            decoration: BoxDecoration(
              color: Config.primary2,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.white60,
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                if (globalQuestionInputKey.currentState != null) {
                  final currentState = globalQuestionInputKey.currentState;
                  if (currentState != null) {
                    currentState.myQuestion = tip;
                    currentState.questionController.clear();
                    currentState.questionController.text = tip;
                    currentState.focusNode.requestFocus();
                    currentState.questionController.selection =
                        TextSelection.fromPosition(
                            TextPosition(offset: tip.length));
                    setState(() {});
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Text(
                  tip,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    height: 20 / 14,
                  ),
                ),
              ),
            ),
          ),
        );
        tipsWidget.add(
          const SizedBox(height: 10),
        );
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Image(
              width: 18,
              height: 18,
              image: AssetImage('images/tip_icon.png'),
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            const Text(
              'Tip',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: tipsWidget,
            ),
            const SizedBox(height: 60),
          ],
        ),
      );
    }

    return _genMessageListWidget(messages);
  }

  /// TODO Performance optimization?
  Widget _genMessageListWidget(List messages) {
    // List<Widget> list = [];
    // for (var i = 0; i < messages.length; i++) {
    //   list.add(
    //     _genMessageItemWidget(messages[i], i),
    //   );
    // }
    // list.add(
    //   const SizedBox(height: 10),
    // );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: list,
    //   ),
    // );

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 20),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      controller: _listController,
      reverse: false,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        String role = messages[index]['role'];
        String defaultAvatar = 'images/logo.png';
        if (role == 'user') {
          defaultAvatar = 'images/user_icon.png';
        }
        return Row(
          mainAxisAlignment:
              role == 'user' ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (role != 'user')
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      clipBehavior: Clip.antiAlias,
                      child: Image(
                        width: 36,
                        height: 36,
                        image: AssetImage(defaultAvatar),
                      ),
                    ),
                  ],
                ),
              ),
            _genMessageItemWidget(messages[index], index),
            if (role == 'user')
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      clipBehavior: Clip.antiAlias,
                      child: Image(
                        width: 36,
                        height: 36,
                        image: AssetImage(defaultAvatar),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _genMessageItemWidget(Map message, int index) {
    // String role = message['role'];
    // if (role == 'generating') {
    //   return SizedBox(
    //     height: 160,
    //     child: _generatingLottie,
    //   );
    // }

    return Container(
      color: Config.background,
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: _renderMessageItem(message, index),
    );
  }

  Widget _renderMessageItem(Map message, int index) {
    String role = message['role'];
    String defaultAvatar = 'images/logo.png';
    String defaultRoleName = 'ChatGPT';
    Color defaultColor = const Color.fromRGBO(229, 245, 244, 1);
    Color defaultTextColor = Colors.black;
    Color defaultRoleTextColor = Colors.black;
    String defaultTextPrefix = '';
    List<Widget> defaultIcons = [
      _renderVoiceWidget(message),
      const SizedBox(width: 6),
      _renderShareWidget(message),
      const SizedBox(width: 8),
      _renderCopyWidget(message),
    ];
    Widget? customContent;
    defaultColor = Config.primary;
    defaultTextColor = Colors.white;
    defaultRoleTextColor = Colors.white;
    if (role == 'user') {
      defaultAvatar = 'images/user_icon.png';
      defaultRoleName = 'You';
      defaultColor = Config.primary2;
      defaultTextColor = Colors.black;
      defaultRoleTextColor = Colors.black;
      defaultIcons = [];
    } else if (role == 'error') {
      defaultTextColor = const Color.fromRGBO(238, 56, 56, 1.0);
      defaultTextPrefix = 'Error:  ';
      defaultIcons = [
        _renderRegenerateWidget(index),
      ];
    } else if (role == 'generating') {
      defaultIcons = [];
      customContent = Row(
        children: [
          SizedBox(
            height: 60,
            child: _generatingLottie,
          )
        ],
      );
    }
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 1.2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: defaultIcons,
          ),
          if (role != 'user') const SizedBox(height: 10),
          customContent ??
              MarkdownBody(
                data: '$defaultTextPrefix${message['content']}',
                // data: 'This is a line\nThis is another line'.replaceAll('\n', '<br>'),
                shrinkWrap: true,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  textScaleFactor: 1.1,
                  textAlign: WrapAlignment.start,
                  p: TextStyle(
                    height: 1.5,
                    color: defaultTextColor,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _renderShareWidget(Map message) {
    return GestureDetector(
      onTap: () async {
        Share.share(message['content']);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: const Image(
          image: AssetImage('images/share_message_icon.png'),
          color: Colors.white,
          width: 22,
        ),
      ),
    );
  }

  Widget _renderVoiceWidget(Map message) {
    return GestureDetector(
      onTap: () async {
        _speak(message['content']);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: const Image(
          image: AssetImage('images/voice_icon.png'),
          color: Colors.white,
          width: 26,
        ),
      ),
    );
  }

  Widget _renderCopyWidget(Map message) {
    return GestureDetector(
      onTap: () async {
        if (_isCopying) {
          return;
        }
        _isCopying = true;
        await Clipboard.setData(
          ClipboardData(
            text: message['content'],
          ),
        );
        EasyLoading.showToast(
          'Copy successfully!',
          dismissOnTap: true,
        );
        _isCopying = false;
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
        child: const Image(
          image: AssetImage('images/chat_copy_icon.png'),
          width: 26,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _renderRegenerateWidget(int index) {
    return GestureDetector(
      onTap: () {
        globalQuestionInputKey.currentState?.reGenerate(index);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: const Image(
          image: AssetImage('images/refresh_icon.png'),
          width: 26,
        ),
      ),
    );
  }
}
