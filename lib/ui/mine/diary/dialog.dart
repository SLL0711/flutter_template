import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

typedef VoidCallback onComfirm(int type);

class DiaryBookDialog {
  static void showTip(BuildContext context, double x, double y, onComfirm) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: x - 80,
            top: y - 20,
            child: Center(
              child: Container(
                width: 100,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(
                      color: XCColors.categoryGoodsShadowColor,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                          onComfirm(1);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '编辑',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 12,
                              color: XCColors.tabNormalColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 1,
                      color: XCColors.messageChatDividerColor,
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          onComfirm(2);
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '删除',
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 12,
                              color: XCColors.tabNormalColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (cxt, state) {
            return _buildBody(state);
          });
        });
  }
}
