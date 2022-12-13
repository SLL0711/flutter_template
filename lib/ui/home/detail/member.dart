import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/detail/widgets.dart';

class MemberScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemberScreenState();
}

class MemberScreenState extends State<MemberScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: DetailWidgets.detailChildAppBar(context, '会员专属', () {
        Navigator.pop(context);
      }, () {}),
      body: Container(
        margin: EdgeInsets.only(top: 1),
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Html(data: '''开通雀斑会员，免费体验12项医学美容产品，轻松分享好友，领取现金福利。'''),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
