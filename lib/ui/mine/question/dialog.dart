import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class QuestionDialog {
  /// ===========  互动回答删除弹窗  =============
  static void showDeleteDialog(BuildContext context) {
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
                          left: 15, top: 26, right: 15, bottom: 26),
                      child: Text('确定删除吗？',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              color: XCColors.mainTextColor))),
                  Container(height: 1, color: XCColors.messageChatDividerColor),
                  Container(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '再想想',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                      color: XCColors.goodsGrayColor),
                                ))),
                        Container(
                            width: 1, color: XCColors.messageChatDividerColor),
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '确定',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                      color: XCColors.bannerSelectedColor),
                                )))
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
