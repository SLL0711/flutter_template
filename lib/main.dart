import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/home.dart';
import 'package:flutter_medical_beauty/im/chat/chat_page.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/home.dart';
import 'package:flutter_medical_beauty/ui/mine/mine.dart';
import 'package:flutter_medical_beauty/welcome.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:fluwx/fluwx.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:package_info/package_info.dart';
import 'package:xinstall_flutter_plugin/xinstall_flutter_plugin.dart';

import 'api.dart';
import 'http.dart';

void main() async {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    EventCenter.defaultCenter().on<AgreePrivacyEvent>().listen((event) {
      _init();
    });
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  _init() async {
    // 判断是否安卓处理初始化问题
    if (Platform.isAndroid) {
      bool isAgree = await Tool.getBool('isAgree');
      if (!isAgree) {
        return;
      }
    }
    // 初始XInstall
    _initXInstall();
    // 初始微信
    _initFluwx();
    // 初始环信
    _initEM();
  }

  _initFluwx() async {
    await registerWxApi(
      appId: "wxbcf8f0aa499278ec",
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://7n3iyf.xinstall.com.cn/tolink/",
    );
  }

  _initEM() async {
    EMPushConfig config = EMPushConfig()..enableAPNs('EaseIM_APNS_Product');
    EMOptions options = EMOptions(appKey: '1133210927200841#demo');
    options.debugModel = true;
    options.pushConfig = config;
    await EMClient.getInstance.init(options);
  }

  _initXInstall() {
    XinstallFlutterPlugin _xInstallFlutterPlugin =
        XinstallFlutterPlugin.getInstance();
    _xInstallFlutterPlugin.init(_xWakeupParamHandler);
    _xInstallFlutterPlugin.getInstallParam(_xWakeupParamHandler);
  }

  Future _xWakeupParamHandler(Map<String, dynamic> data) async {
    try {
      var d = data['data'];
      debugPrint("data == " + d.toString());
      var uo = convert.jsonDecode(d)['uo'];
      debugPrint("uo == " + uo.toString());
      String inviteCode = uo['inviteCode'];
      debugPrint("inviteCode == " + inviteCode);
      if (inviteCode.isNotEmpty) {
        Tool.saveString('inviteCode', inviteCode);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 667),
      builder: () {
        return MaterialApp(
          title: '雀斑',
          debugShowCheckedModeBanner: false,
          onGenerateRoute: onGenerateRoute,
          routes: <String, WidgetBuilder>{
            '/main': (BuildContext context) => new MainPage(),
            '/mine': (BuildContext context) => new MineScreen(),
            '/home': (BuildContext context) => new HomeScreen(),
          },
          home: SplashPage(),
        );
      },
    );
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  var routes = <String, WidgetBuilder>{
    '/chat': (context) => ChatPage(
          (settings.arguments as List)[0],
          (settings.arguments as List)[1],
        ),
  };

  WidgetBuilder builder = routes[settings.name] as WidgetBuilder;
  return MaterialPageRoute(builder: (ctx) => builder(ctx));
}

/// 启动界面
class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  /// 启动页参数
  bool showSplash = false, isGrounding = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    showSplash = await Tool.getBool('splash');
    isGrounding = await Tool.isGrounding();
    // 获取配置参数
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Map<String, dynamic> params = Map();
    params['versionNumber'] = packageInfo.buildNumber;
    var http = await HttpManager.get(
      DsApi.versionConfig,
      context,
      params: params,
    );
    if (http.code == 200) {
      //是否上架中
      isGrounding = http.data == 1;
      Tool.saveBool('isGrounding', isGrounding);
    } else {
      debugPrint(http.toString());
    }
    // 安卓隐私政策处理
    if (Platform.isAndroid) {
      bool isAgree = await Tool.getBool('isAgree');
      if (!isAgree) {
        CommonWidgets.showAgreeDialog(context).then((value) => _goNext());
      } else {
        _goNext();
      }
    } else {
      _goNext();
    }
  }

  void _goNext() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            showSplash || isGrounding ? MainPage() : WelcomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: 0 - MediaQuery.of(context).padding.top,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/home/img_splash.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
