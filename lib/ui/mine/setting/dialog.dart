import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/entity.dart';
import 'package:flutter_medical_beauty/user.dart';

class SettingDialog {
  /// ===========  版本升级弹窗  =============
  static void showVersionTip(BuildContext context, VersionEntity entity) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 300,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Container(
                      height: 150,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/mine/mine_setting_version_bg.png',
                        fit: BoxFit.cover,
                      )),
                  SizedBox(height: 10),
                  Text('发现新版本V${entity.versionNumber}',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          color: XCColors.mainTextColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Text(entity.versionTitle,
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: XCColors.tabNormalColor,
                            height: 1.4)),
                  ),
                  Container(
                      height: 73,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 98,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: XCColors.bannerNormalColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Text(
                                '暂不更新',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 98,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: XCColors.bannerSelectedColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Text(
                                '立即更新',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        )
      ]);
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (cxt, state) {
              return _buildBody(state);
            },
          );
        });
  }

  /// =========  退出登录弹窗  ============
  static Future<bool?> showLogoutDialog(BuildContext context) {
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: Container(
                width: 300,
                padding: EdgeInsets.symmetric(vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        "退出登录",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ),
                    Divider(),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "你是否确定退出当前登录？",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "取消",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Theme.of(context).dividerColor,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              UserManager.shared()!.logout();
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "确定",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        )
      ]);
    }

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (cxt, state) {
            return _buildBody((state));
          },
        );
      },
    );
  }

  /// =========  注销弹窗  ============
  static void showCancellationDialog(
      BuildContext context, final VoidCallback onTap) {
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: Container(
                width: 275,
                padding: EdgeInsets.symmetric(vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "用户注销协议",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: XCColors.mainTextColor),
                    ),
                    SizedBox(height: 15),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text("尊敬的雀斑用户：",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: XCColors.mainTextColor))),
                    SizedBox(height: 5),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                            "	您好！我们在此善意的提醒您，在您注销雀斑账号后，您将无法再以此账号登录和使用雀斑所有产品与服务。",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: XCColors.mainTextColor))),
                    SizedBox(height: 5),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: RichText(
                            text: TextSpan(
                                text: '我已阅读并同意',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: XCColors.mainTextColor),
                                children: [
                              TextSpan(
                                  text: '账号注销协议',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('账号注销协议');
                                    },
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: XCColors.bannerSelectedColor))
                            ]))),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              onTap();
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                "确认注销",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: 1,
                            height: 30,
                            color: XCColors.homeDividerColor),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                "再想想",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        )
      ]);
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (cxt, state) {
              return _buildBody(state);
            },
          );
        });
  }
}
