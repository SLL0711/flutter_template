import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

abstract class SettingWidgets {

  /// ========= 头部视图 =========
  static settingItem(String title, {String value = '', required final VoidCallback onTap}) {
    /// 主体视图
    Widget _bodyWidget() {

      bool isValue = value.isEmpty;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: XCColors.tabNormalColor, fontSize: 14)),
          isValue ? Container(width: 7, height: 14, child: Image.asset(
              'assets/images/mine/mine_gray_arrow_right.png',
              fit: BoxFit.cover
          )) : Text(value, style: TextStyle(color: XCColors.mainTextColor, fontSize: 14, fontWeight: FontWeight.bold))
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 50,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 1),
        child: _bodyWidget(),
      ),
    );
  }
}