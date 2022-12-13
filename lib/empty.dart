import 'package:flutter/material.dart';

import 'colors.dart';

abstract class EmptyWidgets {
  /// ========= 搜索城市为空 =========
  static cityResultsEmptyView(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset("assets/images/home/home_search_empty.png",
          width: 169, height: 153),
      SizedBox(height: 31),
      Text('抱歉，未找到相关城市',
          style: TextStyle(fontSize: 12, color: XCColors.goodsGrayColor)),
      SizedBox(height: 5),
      Text('请输入城市名、首字母或拼音重试',
          style: TextStyle(fontSize: 12, color: XCColors.goodsGrayColor)),
      SizedBox(height: 100)
    ]));
  }

  /// ========= 数据为空 =========
  static dataEmptyView(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
      Image.asset("assets/images/box/box_empty.png", width: 128, height: 106),
      SizedBox(height: 20),
      Text('当前页面没有内容哦！',
          style: TextStyle(fontSize: 12, color: XCColors.goodsGrayColor))
    ]));
  }
}
