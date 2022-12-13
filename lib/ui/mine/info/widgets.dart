import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/widgets.dart';

typedef VoidCallback tapAction(int index);

abstract class MineInfoWidgets {
  static infoHeaderView(BuildContext context, var icon, tapAction) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          tapAction(0);
        },
        child: Container(
            height: 93,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: XCColors.homeDividerColor))),
            child: Row(children: [
              Container(
                  width: 63,
                  height: 63,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  child: icon == null || icon == ''
                      ? Image.asset("assets/images/mine/mine_avatar.png",
                          fit: BoxFit.cover)
                      : CommonWidgets.networkImage(icon)),
              SizedBox(width: 10),
              Expanded(
                  child: Text('修改头像',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 14, color: XCColors.mainTextColor))),
              SizedBox(width: 10),
              CommonWidgets.grayRightArrow()
            ])));
  }

  static infoItemView(BuildContext context, String title, String value,
      int tapType, tapAction) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          tapAction(tapType);
        },
        child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: XCColors.homeDividerColor))),
            child: Row(children: [
              Text(title,
                  style:
                      TextStyle(fontSize: 14, color: XCColors.mainTextColor)),
              SizedBox(width: 10),
              Expanded(
                  child: Text(value,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 14, color: XCColors.tabNormalColor))),
              SizedBox(width: 10),
              CommonWidgets.grayRightArrow()
            ])));
  }

  static infoDetailItemView(BuildContext context, String title, String hint,
      TextEditingController textEditingController, TextInputType inputType) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: XCColors.homeDividerColor,
                  ),
                ),
              ),
              child: TextField(
                controller: textEditingController,
                keyboardType: inputType,
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: XCColors.tabNormalColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static infoDetailWithCodeItemView(
      BuildContext context,
      String title,
      String hint,
      TextEditingController textEditingController,
      TextInputType inputType,
      String codeText,
      final VoidCallback onTap) {
    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(children: [
          Container(
              width: 100,
              child: Text(title,
                  style:
                      TextStyle(fontSize: 14, color: XCColors.mainTextColor))),
          Expanded(
              child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                      controller: textEditingController,
                      keyboardType: inputType,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16, color: XCColors.tabNormalColor),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: TextStyle(
                              fontSize: 14, color: XCColors.tabNormalColor))))),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                  height: double.infinity,
                  width: 110,
                  alignment: Alignment.centerRight,
                  child: Text(codeText,
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 14))))
        ]));
  }
}
