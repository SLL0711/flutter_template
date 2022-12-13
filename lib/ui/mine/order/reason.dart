import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/toast.dart';

class MineOrderRefundReasonScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MineOrderRefundReasonScreenState();
}

class MineOrderRefundReasonScreenState
    extends State<MineOrderRefundReasonScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset("assets/images/home/back.png",
                      width: 28, height: 28),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip);
            }),
            title: Text(
              '退款原因',
              style: TextStyle(
                  fontSize: 18,
                  color: XCColors.mainTextColor,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (_textEditingController.text.isEmpty) return ToastHud.show(context, '反馈内容不能为空');
                    Navigator.pop(context, _textEditingController.text);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text('确定',
                          style: TextStyle(
                              fontSize: 18,
                              color: XCColors.bannerSelectedColor))))
            ]),
        body: Container(
            height: 103,
            color: Colors.white,
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: TextField(
                controller: _textEditingController,
                style: TextStyle(fontSize: 12, color: XCColors.mainTextColor),
                decoration: InputDecoration(
                    hintText: '请输入您想要反馈的文字',
                    hintStyle:
                        TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                    border: InputBorder.none))));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
