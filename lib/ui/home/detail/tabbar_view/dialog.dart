import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/toast.dart';

typedef VoidCallback confirm(int result);

class ReplyDialog {
  static void show(BuildContext context, String content, confirm) {
    Widget _item(String title, int type) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            confirm(type);
            Navigator.pop(context);
          },
          child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: XCColors.homeDividerColor))),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      color: XCColors.mainTextColor,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none))));
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            left: 15,
            right: 15,
            bottom: 10,
            child: Center(
                child: Column(children: [
              Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(children: [
                    Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: XCColors.homeDividerColor))),
                        child: Text(content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 12,
                                color: XCColors.goodsGrayColor,
                                fontWeight: FontWeight.normal))),
                    _item('回复', 1),
                    _item('举报', 2),
                    // _item('删除', 3)
                  ])),
              SizedBox(height: 10),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Text('取消',
                          style: TextStyle(
                              fontSize: 16,
                              color: XCColors.mainTextColor,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none))))
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

  static void showComment(BuildContext context,
      TextEditingController textEditingController, FocusNode focusNode, final VoidCallback sendTap) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState, BuildContext ctx) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                color: Colors.white,
                height: 50,
                child: Row(children: [
                  SizedBox(width: 15),
                  Expanded(
                      child: Container(
                          height: 35,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: XCColors.homeDividerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17.5))),
                          child: TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              style: TextStyle(
                                  fontSize: 14, color: XCColors.mainTextColor),
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '请输入评论内容',
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: XCColors.goodsGrayColor))))),
                  SizedBox(width: 15),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (textEditingController.text.isEmpty) return ToastHud.show(context, '内容不能为空');
                      Navigator.pop(ctx);
                      sendTap();
                    },
                    child: Container(
                        height: 35,
                        width: 75,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: XCColors.themeColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(17.5))),
                        child: Text('发送',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white)))
                  ),
                  SizedBox(width: 15)
                ])))
      ]);
    }

    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (cxt, state) {
            Future.delayed(Duration(milliseconds: 200)).then((e) {
              FocusScope.of(ctx).requestFocus(focusNode);
            });
            return Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: _buildBody(state, ctx)));
          });
        });
  }
}
