import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class AccountDialog {
  /// ===========  注销账号弹窗  =============
  static void showLogoutTip(
      BuildContext context, final VoidCallback submitTap) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 275,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Text('用户注销协议',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: XCColors.mainTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 15, left: 24, right: 27),
                    alignment: Alignment.topLeft,
                    child: Text('尊敬的雀斑用户：',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: XCColors.mainTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, left: 24, right: 27),
                    alignment: Alignment.topLeft,
                    child: Text(
                        '	   您好！我们在此善意的提醒您，在您注销雀斑账号后，您将无法再以此账号登录和使用雀斑所有产品与服务。',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: XCColors.mainTextColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            height: 1.6)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 21),
                    alignment: Alignment.center,
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '我已阅读并同意',
                            style: TextStyle(
                                fontSize: 14,
                                color: XCColors.mainTextColor,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '账号注销协议',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('账号注销协议');
                                  },
                                style: TextStyle(
                                    fontSize: 16,
                                    color: XCColors.bannerSelectedColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ])),
                  ),
                  Container(height: 1, color: XCColors.messageChatDividerColor),
                  Container(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(context);
                            submitTap();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '确认注销',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: XCColors.goodsGrayColor),
                              )),
                        )),
                        Container(
                            width: 1, color: XCColors.messageChatDividerColor),
                        Expanded(
                            child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '再想想',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: XCColors.bannerSelectedColor),
                              )),
                        ))
                      ],
                    ),
                  ),
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
}
