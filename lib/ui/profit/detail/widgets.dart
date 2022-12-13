import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/colors.dart';

abstract class HotWidgets {
  /// ========= 热力值展示视图 =========
  static hotValueView(
    BuildContext context,
    int value,
    bool isGrounding,
    String tip,
    final VoidCallback shareTap,
  ) {
    Widget _bodyWidget() {
      return Column(children: [
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/images/profit/profit_hot_icon.png',
              width: 17, height: 26, fit: BoxFit.cover),
          SizedBox(width: 10),
          Text('$value',
              style:
                  TextStyle(color: XCColors.bannerSelectedColor, fontSize: 30))
        ]),
        SizedBox(height: 4),
        Text('当前好友',
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 14)),
        SizedBox(height: 10),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: shareTap,
            child: Container(
                width: 200,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: XCColors.themeColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text('立即邀请',
                    style: TextStyle(color: Colors.white, fontSize: 14)))),
        SizedBox(height: 10),
        Text(tip,
            style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
      ]);
    }

    return Container(
        height: 174,
        width: double.infinity,
        color: Colors.white,
        child: _bodyWidget());
  }

  /// ========= 热力值兑换视图 =========
  static hotExchangeView(
      BuildContext context, int value, Function(int) exchangeTap) {
    /// 进度条视图
    Widget _progressWidget(int type, int value) {
      String title = '100000个Star积分';
      String number = value > 15 ? '15/15个好友' : '$value/15个好友';
      double fillWidth = 7; // 填充的宽度
      bool isExchange = false; // 是否可以兑现

      /// 屏幕宽度
      double screenWidth = MediaQuery.of(context).size.width;
      double progressWidth = screenWidth - 135;

      if (type == 1) {
        fillWidth = (progressWidth / 15.0) * value;
        isExchange = value >= 15;
      } else {
        title = '300000个Star积分';
        number = '$value/30个好友';
        fillWidth = (progressWidth / 30.0) * value;
        isExchange = value >= 30;
      }

      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(children: [
            Expanded(
                child: Container(
                    child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(title,
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 12)),
                Text(number,
                    style:
                        TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
              ]),
              SizedBox(height: 3),
              Container(
                  height: 6,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: XCColors.bannerNormalColor),
                  child: Stack(children: [
                    Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                            height: 6,
                            width: fillWidth,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    //右上
                                    end: Alignment.centerRight,
                                    //左下
                                    stops: [
                                      0.0,
                                      1.0
                                    ],
                                    //[渐变起始点, 渐变结束点]
                                    //渐变颜色[始点颜色, 结束颜色]
                                    colors: [
                                      Color(0XFFFE90B2),
                                      Color(0XFFAFEAFD)
                                    ]))))
                  ]))
            ]))),
            SizedBox(width: 25),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (isExchange) {
                    exchangeTap(type == 1 ? 15 : 30);
                  }
                },
                child: Container(
                    width: 60,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: isExchange
                            ? XCColors.themeColor
                            : XCColors.bannerNormalColor,
                        borderRadius: BorderRadius.all(Radius.circular(12.5))),
                    child: Text('兑换',
                        style: TextStyle(color: Colors.white, fontSize: 12))))
          ]));
    }

    Widget _bodyWidget(int value) {
      return Column(children: [
        SizedBox(height: 15),
        Text('积分兑换',
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 16)),
        SizedBox(height: 15),
        _progressWidget(1, value),
        SizedBox(height: 49),
        _progressWidget(2, value)
      ]);
    }

    return Container(
        height: 184,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        child: _bodyWidget(value));
  }

  /// ========= 热力值规则视图 =========
  static hotRulesView(
      BuildContext context, int value, bool isGrounding, String rule) {
    // Widget _ruleItem(double index, String rule) {
    //   bool isRichText = rule.isEmpty; // 是否使用富文本
    //
    //   return Container(
    //     padding: const EdgeInsets.only(left: 15, right: 34),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           width: 20,
    //           height: 20,
    //           color: XCColors.bannerSelectedColor,
    //           alignment: Alignment.center,
    //           child: Text(
    //             '$index',
    //             style:
    //                 TextStyle(color: XCColors.hotRuleIndexColor, fontSize: 10),
    //           ),
    //         ),
    //         SizedBox(width: 3),
    //         Expanded(
    //           child: isRichText
    //               ? RichText(
    //                   text: TextSpan(
    //                       text: '热力值兑换后存入颜值金账户，在“',
    //                       style: TextStyle(
    //                           fontSize: 12,
    //                           color: XCColors.tabNormalColor,
    //                           height: 1.6),
    //                       children: [
    //                       TextSpan(
    //                         text: '我的-钱包-颜值金',
    //                         style: TextStyle(
    //                             fontSize: 12,
    //                             color: XCColors.bannerSelectedColor,
    //                             height: 1.6),
    //                       ),
    //                       TextSpan(
    //                         text: '”中查看，可1:1申请提取现金。',
    //                         style: TextStyle(
    //                             fontSize: 12,
    //                             color: XCColors.tabNormalColor,
    //                             height: 1.6),
    //                       ),
    //                     ]))
    //               : Text(rule,
    //                   style: TextStyle(
    //                       color: XCColors.tabNormalColor,
    //                       fontSize: 12,
    //                       height: 1.6)),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    Widget _bodyWidget() {
      return Column(children: [
        SizedBox(height: 15),
        Text('规则说明',
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 16)),
        SizedBox(height: 7),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Html(data: rule))
        // _ruleItem(1,
        //     '热力值获取方式：${isGrounding ? '新注册' : '付费298元'}成为会员后，每成功邀请1位${isGrounding ? '新注册' : '298元付费'}会员获得【热力值1】。'),
        // SizedBox(height: 10),
        // _ruleItem(2, '热力值兑换不限次数，初始值为0 。'),
        // SizedBox(height: 10),
        // _ruleItem(3, ''),
        // SizedBox(height: 10),
        // _ruleItem(4, '每满15个热力值可兑换1000元颜值金，30个热力值可兑换3000颜值金；'),
        // SizedBox(height: 15)
      ]);
    }

    return Container(
        width: double.infinity, color: Colors.white, child: _bodyWidget());
  }
}
