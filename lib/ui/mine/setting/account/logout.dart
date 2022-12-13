import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/account/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/account/logout_code.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/account/widgets.dart';

class LogoutScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogoutScreenState();
}

class LogoutScreenState extends State<LogoutScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '注销账号', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1, color: XCColors.homeDividerColor),
            SizedBox(height: 40),
            Text('注销前，请确认以下内容',
                style: TextStyle(
                    fontSize: 18,
                    color: XCColors.mainTextColor,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            AccountWidgets.logoutTipView(context, 1, '账号无任何资产',
                '账号资产包括但不限于雀斑产品会员、积分、颜值金、颜值豆、银行卡快捷支付、上传图片、评论等。'),
            SizedBox(height: 20),
            AccountWidgets.logoutTipView(
                context, 2, '账号处于安全状态', '近3个月内无异常登录记录、且账号无修改手机号等敏感操作。'),
            SizedBox(height: 20),
            AccountWidgets.logoutTipView(
                context, 3, '账号将不可找回', '注销后、账号相关信息将被释放，账号内资产将无法找回。'),
            SizedBox(height: 30),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                AccountDialog.showLogoutTip(context, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LogoutCodeScreen()));
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
                  '确认注销',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
