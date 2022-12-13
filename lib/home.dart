import 'dart:io';

import 'package:ar_rtc_engine/rtc_engine.dart';
import 'package:ease_call_kit/ease_call_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/category/category.dart';
import 'package:flutter_medical_beauty/ui/consultation/index.dart';
import 'package:flutter_medical_beauty/ui/home/home.dart';
import 'package:flutter_medical_beauty/ui/mall/index.dart';
import 'package:flutter_medical_beauty/ui/mine/index.dart';
import 'package:flutter_medical_beauty/ui/mine/mine.dart';
import 'package:flutter_medical_beauty/ui/profit/profit.dart';
import 'package:flutter_medical_beauty/ui/share/index.dart';
import 'package:flutter_medical_beauty/ui/video/call.dart';
import 'package:flutter_medical_beauty/ui/video/video.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

import 'colors.dart';
import 'event_center.dart';

/// tabItem模型
class TabItem {
  const TabItem({
    required this.title,
    this.image,
    this.selectedImage,
    this.tabView,
    this.isSelected,
  }) : assert(image != null || selectedImage != null || tabView != null);

  final String title;
  final String? image;
  final String? selectedImage;
  final Widget? tabView;
  final bool? isSelected;
}

/// 主界面
class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // 选择的tab界面索引
  int _selectedIndex = 0;

  var _subscriptionAddress;

  @override
  void dispose() {
    _subscriptionAddress!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _subscriptionAddress =
        EventCenter.defaultCenter().on<PushTabEvent>().listen((event) {
      pageController.jumpToPage(event.result);
    });
    Future.delayed(Duration.zero, _initPush);
    // 初始化 EaseCallKit插件
    EaseCallKit.initWithConfig(
      EaseCallConfig('15cb0d28b87b425ea613fc46f7c9f974')
        ..userMap = {
          '13500000000': EaseCallUser('13500000000', ''),
          '13500000001': EaseCallUser('13500000001', ''),
        },
    );
    super.initState();
  }

  // tab数据
  List<TabItem> _tabItems = [
    TabItem(
        title: "首页",
        image: 'assets/images/tabs/home.png',
        selectedImage: 'assets/images/tabs/home_selected.png',
        tabView: ConsultationScreen()),
    TabItem(
        title: "商城",
        image: 'assets/images/tabs/category.png',
        selectedImage: 'assets/images/tabs/category_selected.png',
        tabView: MallScreen()),
    TabItem(
        title: "分享",
        image: 'assets/images/tabs/profit.png',
        selectedImage: 'assets/images/tabs/profit_selected.png',
        tabView: ShareScreen()),
    TabItem(
        title: "我的",
        image: 'assets/images/tabs/mine.png',
        selectedImage: 'assets/images/tabs/mine_selected.png',
        tabView: MyScreen()),
  ];

  final pageController = PageController();

  // tab切换
  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPush() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /// 推送
    XgFlutterPlugin tpush = new XgFlutterPlugin();

    /// 开启DEBUG
    tpush.setEnableDebug(true);

    /// 添加回调事件
    tpush.addEventHandler(
      onRegisteredDeviceToken: (String msg) async {
        print("flutter onRegisteredDeviceToken: $msg");
        _savePushToken(msg);
      },
      onRegisteredDone: (String msg) async {
        print("flutter onRegisteredDone: $msg");
        _savePushToken(msg);
      },
      unRegistered: (String msg) async {
        print("flutter unRegistered: $msg");
      },
      onReceiveNotificationResponse: (Map<String, dynamic> msg) async {
        print("flutter onReceiveNotificationResponse $msg");
        if ('视频通话邀请' == msg['content']) {
          showGeneralDialog(
            context: context,
            barrierDismissible: false,
            barrierLabel: '',
            transitionDuration: Duration(milliseconds: 200),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * .8,
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Text(
                            msg['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              msg['content'],
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          height: 45,
                          child: Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text('拒绝'),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )),
                              VerticalDivider(
                                width: 1,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: XCColors.themeColor,
                                    child: Text(
                                      '接听',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CallPage(
                                          msg['customMessage'],
                                          ClientRole.Broadcaster,
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
      },
      onReceiveMessage: (Map<String, dynamic> msg) async {
        print("flutter onReceiveMessage $msg");
      },
      xgPushDidSetBadge: (String msg) async {
        print("flutter xgPushDidSetBadge: $msg");
        // 在此可设置应用角标
        // tpush.setAppBadge(0);
      },
      xgPushDidBindWithIdentifier: (String msg) async {
        print("flutter xgPushDidBindWithIdentifier: $msg");
      },
      xgPushDidUnbindWithIdentifier: (String msg) async {
        print("flutter xgPushDidUnbindWithIdentifier: $msg");
      },
      xgPushDidUpdatedBindedIdentifier: (String msg) async {
        print("flutter xgPushDidUpdatedBindedIdentifier: $msg");
      },
      xgPushDidClearAllIdentifiers: (String msg) async {
        print("flutter xgPushDidClearAllIdentifiers: $msg");
      },
      xgPushClickAction: (Map<String, dynamic> msg) async {
        print("flutter xgPushClickAction $msg");
        if (msg['actionType'] == 0 && '视频通话邀请' == msg['content']) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallPage(
                msg['customMessage'],
                ClientRole.Broadcaster,
              ),
            ),
          );
        }
      },
    );

    /// 如果您的应用非广州集群则需要在startXG之前调用此函数
    /// 香港：tpns.hk.tencent.com
    /// 新加坡：tpns.sgp.tencent.com
    /// 上海：tpns.sh.tencent.com
    tpush.configureClusterDomainName("tpns.sh.tencent.com");

    /// 启动TPNS服务
    if (Platform.isIOS) {
      tpush.startXg("1680010201", "ITVTSQBZPDCB");
    } else {
      tpush.startXg("1580010201", "AJK6SME97C3D");
    }
  }

  void _savePushToken(String pushToken) async {
    Tool.saveString('pushToken', pushToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: List<Widget>.generate(_tabItems.length, (index) {
            return _tabItems[index].tabView!;
          }),
          controller: pageController,
          onPageChanged: onPageChanged),
      bottomNavigationBar: BottomNavigationBar(
        items:
            List<BottomNavigationBarItem>.generate(_tabItems.length, (index) {
          var tabItem = _tabItems[index];
          return _bottomNavItem(tabItem.title,
              image: tabItem.image,
              selectedImage: tabItem.selectedImage,
              isSelected: index == _selectedIndex);
        }),
        type: BottomNavigationBarType.fixed,
        fixedColor: XCColors.themeColor,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        unselectedItemColor: XCColors.mainTextColor,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }

  BottomNavigationBarItem _bottomNavItem(String title,
      {String? image, String? selectedImage, bool isSelected = false}) {
    return BottomNavigationBarItem(
      label: title,
      icon: Image.asset(
        image!,
        width: 22.0,
        height: 22.0,
      ),
      activeIcon: Image.asset(
        selectedImage!,
        width: 22.0,
        height: 22.0,
        //color: XCColors.themeColor,
      ),
    );
  }

  void _onItemTap(int index) {
    pageController.jumpToPage(index);
  }
}
