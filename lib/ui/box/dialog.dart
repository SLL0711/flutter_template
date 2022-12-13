import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class BoxDialog {
  /// ===========  购物车删除弹窗  =============
  static Future<String?> showDeleteDialog(
      BuildContext context, List<int> list) {
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
                          left: 17, top: 31, right: 11, bottom: 23),
                      child: Text('确定删除这${list.length}种商品吗？',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              color: XCColors.mainTextColor))),
                  Container(height: 1, color: XCColors.messageChatDividerColor),
                  Container(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '取消',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                    color: XCColors.goodsGrayColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: 1, color: XCColors.messageChatDividerColor),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(list.join(','));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                    color: XCColors.bannerSelectedColor),
                              ),
                            ),
                          ),
                        ),
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

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (cxt, state) {
            return _buildBody(state);
          },
        );
      },
    );
  }
}
