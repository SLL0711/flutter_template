import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';

typedef VoidCallback confirm(int result);

class MineInfoDialog {
  /// ===========  性别  =============
  static void showSexDialog(
      BuildContext context, List<SexEntity> sexList, confirm) {
    Widget _sexItem(StateSetter setState, SexEntity entity) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            confirm(entity.gender);
            Navigator.pop(context);
          },
          child: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 25, right: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entity.sex,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            color: entity.isSelected
                                ? XCColors.mainTextColor
                                : XCColors.tabNormalColor)),
                    Offstage(
                        offstage: !entity.isSelected,
                        child: Container(width: 30, child: Image.asset('assets/images/mine/mine_info_selected_sex.png'),))
                  ])));
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(children: [
        Center(
            child: Container(
                width: 300,
                height: 160,
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: sexList.isEmpty
                    ? Container()
                    : Column(children: [
                        Expanded(
                            child: Text('选择性别',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                    color: XCColors.mainTextColor))),
                        SizedBox(height: 5),
                        _sexItem(setState, sexList.first),
                        Container(height: 1, color: XCColors.homeDividerColor),
                        _sexItem(setState, sexList.last)
                      ])))
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

  /// ===========  头像  =============
  static void showAvatarDialog(BuildContext context, confirm) {
    Widget _item(String title, String image, int tapType) {
      return Expanded(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                confirm(tapType);
                Navigator.pop(context);
              },
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(image, width: 70, height: 70),
                        SizedBox(height: 10),
                        Text(title,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                fontSize: 14,
                                color: XCColors.mainTextColor))
                      ]))));
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(children: [
        Center(
            child: Container(
                width: 300,
                height: 160,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(children: [
                  _item('拍照', 'assets/images/mine/mine_info_upload_camera.png',
                      1),
                  Container(
                      width: 1, height: 90, color: XCColors.homeDividerColor),
                  _item('从相册选择',
                      'assets/images/mine/mine_info_upload_photo.png', 2)
                ])))
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
