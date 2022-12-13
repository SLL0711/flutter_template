import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/detail/widgets.dart';

class OriginalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OriginalScreenState();
}

class OriginalScreenState extends State<OriginalScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: DetailWidgets.detailChildAppBar(context, '雀斑保障', () {
        Navigator.pop(context);
      }, () {}),
      body: Container(
        margin: EdgeInsets.only(top: 1),
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Html(
            data:
                '''雀斑平台在与医学美容商家合作前，都会对商家、咨询师的资质进行严格的审核，每家商家都经过平台实地考察，所用药品均经过国家药品监督管理局检测且拥有批文。层层筛选，安心守护颜粉的青春容颜。'''),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
