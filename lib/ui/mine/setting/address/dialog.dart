import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class AddressDialog {
  /// ===========  地址删除提示  =============
  static void showDeleteTip(BuildContext context, String title, final VoidCallback onTap) {
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
                    padding: const EdgeInsets.only(
                        left: 15, top: 31, right: 15, bottom: 23),
                    child: Text(title, style: TextStyle(fontSize: 14), )
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
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
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
                                onTap();
                                Navigator.pop(context);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '确定',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
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
