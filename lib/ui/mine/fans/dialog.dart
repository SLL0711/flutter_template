import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class FansDialog {
  /// ===========  取消关注提示  =============
  static void showFansTip(BuildContext context, final VoidCallback onComfirm) {
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.only(
                              left: 10, top: 31, right: 10, bottom: 23),
                          child: Text('确定取消关注？',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none,
                                  color: XCColors.mainTextColor))),
                      Container(
                          height: 1, color: XCColors.messageChatDividerColor),
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
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('再想想',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 18,
                                                    color: XCColors
                                                        .goodsGrayColor))))),
                                Container(
                                    width: 1,
                                    color: XCColors.messageChatDividerColor),
                                Expanded(
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          onComfirm();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('确定',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 18,
                                                    color: XCColors
                                                        .bannerSelectedColor)))))
                              ]))
                    ]))))
      ]);
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (cxt, state) {
            return _buildBody(state);
          });
        });
  }
}
