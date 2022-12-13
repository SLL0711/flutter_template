import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/account/logout.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/widgets.dart';

import 'mobile.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '账号与安全', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 13),
              SettingWidgets.settingItem('修改手机号', onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MobileScreen()));
              }),
              SizedBox(height: 10),
              SettingWidgets.settingItem('注销账号', onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LogoutScreen()));
              }),
            ],
          ),
        ));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
