import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

abstract class AccountWidgets {
  /// ========= 修改手机号头部视图 =========
  static changeMobileHeaderView(String mobile) {
    /// 主体视图
    Widget _bodyWidget() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(mobile,
              style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 3),
          Text('当前手机号码',
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 14))
        ],
      );
    }

    return Container(
      height: 90,
      width: double.infinity,
      color: XCColors.changeMobileHeaderColor,
      child: _bodyWidget(),
    );
  }

  /// ========= 修改手机号验证码视图 =========
  static changeMobileView(TextEditingController textEditingController,
      String code, final VoidCallback onTap) {
    /// 主体视图
    Widget _bodyWidget() {
      return Row(
        children: [
          Container(
            width: 64,
            child: Text(
              '+86',
              style: TextStyle(
                color: XCColors.tabNormalColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
              child: Container(
            child: TextField(
              controller: textEditingController,
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
              ),
              decoration: InputDecoration(
                hintText: '请输入新的手机号码',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: XCColors.goodsGrayColor,
                ),
                border: InputBorder.none,
              ),
            ),
          )),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: 90,
              alignment: Alignment.centerRight,
              child: Text(
                code,
                style: TextStyle(
                  color: XCColors.bannerSelectedColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: _bodyWidget(),
    );
  }

  /// ========= 修改手机号验证码视图 =========
  static changeMobileCodeView(TextEditingController textEditingController) {
    /// 主体视图
    Widget _bodyWidget() {
      return Row(
        children: [
          Container(
            width: 64,
            child: Text('验证码',
                style: TextStyle(color: XCColors.tabNormalColor, fontSize: 14)),
          ),
          Expanded(
              child: Container(
            child: TextField(
              controller: textEditingController,
              style: TextStyle(fontSize: 14, color: XCColors.mainTextColor),
              decoration: InputDecoration(
                hintText: '请输入验证码',
                hintStyle:
                    TextStyle(fontSize: 14, color: XCColors.goodsGrayColor),
                border: InputBorder.none,
              ),
            ),
          )),
        ],
      );
    }

    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: _bodyWidget(),
    );
  }

  /// ========= 注销账号注意事项视图 =========
  static logoutTipView(
      BuildContext context, int index, String title, String content) {
    Widget _bodyWidget() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 17,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/mine/mine_tip_start_icon.png'),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            )),
            child: Text(
              '$index',
              style: TextStyle(
                height: 1.4,
                color: XCColors.hotRuleIndexColor,
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(width: 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: XCColors.mainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                    color: XCColors.goodsGrayColor,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 33, right: 59),
      width: double.infinity,
      color: Colors.white,
      child: _bodyWidget(),
    );
  }
}
