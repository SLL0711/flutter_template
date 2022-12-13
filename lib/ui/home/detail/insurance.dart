import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/detail/widgets.dart';

class InsuranceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InsuranceScreenState();
}

class InsuranceScreenState extends State<InsuranceScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: DetailWidgets.detailChildAppBar(context, '颜值保', () {
          Navigator.pop(context);
        }, () {}),
        body: Container());
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
