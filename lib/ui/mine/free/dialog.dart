import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';

class FreeDialog {
  static void showRuleDialog(BuildContext context, final VoidCallback onTap) {
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: Container(
                width: 275,
                padding: EdgeInsets.symmetric(vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "使用规则",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: XCColors.mainTextColor),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("1.每人每次限用一张：",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: XCColors.mainTextColor))),
                    SizedBox(height: 5),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("2.请提前1天电话进行预约",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: XCColors.mainTextColor))),
                    SizedBox(height: 5),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                            text: TextSpan(
                                text: '预约电话：',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: XCColors.mainTextColor),
                                children: [
                              TextSpan(
                                  text: '4006025168',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('4006025168');
                                    },
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: XCColors.bannerSelectedColor))
                            ]))),
                    SizedBox(height: 16),
                    Container(height: 1, color: XCColors.homeDividerColor),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                "取消",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: XCColors.goodsGrayColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: 1,
                            height: 30,
                            color: XCColors.homeDividerColor),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              onTap();
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                "使用",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: XCColors.bannerSelectedColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        )
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
