import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/consult/entity.dart';

typedef VoidCallback Confirm(int result);

class VideoDialog {
  static void cancelAlert(BuildContext context, confirm, ConsultOrderEntity order, {int selectedType = 0}) {
    Widget _buildItem(String title, int type, StateSetter setState) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(
            () {
              selectedType = type;
            },
          );
        },
        child: Container(
          height: 47,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: XCColors.homeDividerColor))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF020202),
                    decoration: TextDecoration.none),
              )),
              Container(
                width: 15,
                height: 15,
                child: Image.asset(
                    selectedType == type
                        ? 'assets/images/box/box_check_selected.png'
                        : 'assets/images/box/box_check_normal.png',
                    fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      );
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10))),
                child: Column(children: [
                  SizedBox(height: 20),
                  Text(
                    '取消原因',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF131313),
                        decoration: TextDecoration.none),
                  ),
                  SizedBox(height: 20),
                  _buildItem('拍错了', 0, setState),
                  _buildItem('时间不方便', 1, setState),
                  _buildItem('不需要', 2, setState),
                  Container(
                    height: 88,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            confirm(selectedType, order);
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFE5E5E5))),
                              child: Text(
                                '确定退款',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                    decoration: TextDecoration.none),
                              )),
                        )),
                        SizedBox(width: 10),
                        Expanded(
                            child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.black),
                              child: Text(
                                '考虑一下',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.none),
                              )),
                        ))
                      ],
                    ),
                  )
                ])))
      ]);
    }

    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return StatefulBuilder(builder: (cxt, state) {
            return _buildBody(state);
          });
        });
  }
}
