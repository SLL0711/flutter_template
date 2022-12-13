
import 'package:fluwx/fluwx.dart' as fluwx;

final wx_AppId = 'wx057e463333183921';
final ios_universalLink = 'https://www.heshengliangyou.com/';

class SdkManager {
  static void initSdk() {
    _initSdk();
  }
}

void _initSdk() async {
  await fluwx.registerWxApi(
      appId: "wx057e463333183921",
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://your.univerallink.com/link/");
  var result = await fluwx.isWeChatInstalled;
  print("is installed $result");
}

void initWechatSDK() {
  /// 初始化支付SDK
  fluwx.registerWxApi(appId: wx_AppId, universalLink: ios_universalLink);

  /// 微信分享回调
  // fluwx.responseFromShare.listen((response) {
  //   debugPrint('微信分享回调：${response}');
  //   EventCenter.defaultCenter().fire(ShareResponseEvent());
  // });
  //
  // /// 微信登录回调
  // fluwx.responseFromAuth.listen((response) {
  //   debugPrint('${response.code}');
  //   debugPrint('${response.state}');
  //   if (response.errCode == 0) {
  //     getWechatToken(response.code);
  //   }
  // });

  /// 微信支付回调
  // fluwx.responseFromPayment.listen((response) {
  //   debugPrint('${response}');
  //   if (response.errCode == 0) {
  //     EventCenter.defaultCenter().fire(PayResponseEvent(true));
  //   } else {
  //     debugPrint('微信支付回调失败：errCode：${response.errCode}, errStr:${response.errStr}');
  //     EventCenter.defaultCenter().fire(PayResponseEvent(false));
  //   }
  // });
}