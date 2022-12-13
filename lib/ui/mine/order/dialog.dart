import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrderDialog {
  /// ===========  取消订单弹窗  =============
  static void showCancelDialog(BuildContext context, final VoidCallback onTap) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            left: 0,
            right: 0,
            child: Center(
                child: Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, right: 15, bottom: 15),
                        child: Text(
                          '提示',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: XCColors.mainTextColor),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        child: Text(
                          '该商品很抢手哦，确定要取消吗？',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: XCColors.mainTextColor),
                        ),
                      ),
                      Container(
                          height: 1, color: XCColors.messageChatDividerColor),
                      Container(
                          height: 45,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          onTap();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('坚持取消',
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 18,
                                                    color: XCColors
                                                        .goodsGrayColor))))),
                                Container(
                                    width: 1,
                                    color: XCColors.messageChatDividerColor),
                                Expanded(
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('我再想想',
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 18,
                                                    color: XCColors
                                                        .bannerSelectedColor)))))
                              ]))
                    ]))))
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

  static void showRefundDialog(BuildContext context, final VoidCallback onTap) {
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15, bottom: 15),
                          child: Text('提示',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: XCColors.mainTextColor))),
                      Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: Text('要不要再考虑一下，限时优惠价过来今天可能就没有了哦～',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: XCColors.mainTextColor))),
                      Container(
                          height: 1, color: XCColors.messageChatDividerColor),
                      Container(
                          height: 45,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('不退了',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 18,
                                                    color: XCColors
                                                        .goodsGrayColor))))),
                                Container(
                                    width: 1,
                                    color: XCColors.messageChatDividerColor),
                                Expanded(
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          onTap();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('继续退款',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontSize: 18,
                                                    color: XCColors
                                                        .bannerSelectedColor)))))
                              ]))
                    ]))))
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

  static void showRefundCodeDialog(
      BuildContext context, MineOrderCodeEntity codeEntity) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: 566,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                children: [
                  Stack(children: [
                    Container(
                      width: double.infinity,
                      height: 250,
                      child: CommonWidgets.networkImage(codeEntity.productPic),
                    ),
                    Positioned(
                      top: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 15,
                          height: 15,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                  ]),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 40),
                    child: Column(
                      children: [
                        Text(codeEntity.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                fontSize: 16,
                                color: XCColors.mainTextColor)),
                        SizedBox(height: 20),
                        QrImage(
                          data: codeEntity.verificationCode,
                          version: QrVersions.auto,
                          size: 130.0,
                        ),
                        SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('核销码：',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 14,
                                      color: XCColors.mainTextColor)),
                              Text(codeEntity.verificationCode,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                      fontSize: 14,
                                      color: XCColors.tabNormalColor))
                            ]),
                        SizedBox(height: 10),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (codeEntity.verificationCode.isEmpty) {
                              ToastHud.show(context, '复制失败');
                            } else {
                              Clipboard.setData(ClipboardData(
                                  text: codeEntity.verificationCode));
                              ToastHud.show(context, '复制成功');
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 92,
                            height: 25,
                            decoration: BoxDecoration(
                                color: XCColors.homeDividerColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.5))),
                            child: Text(
                              '复制核销码',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                fontSize: 12,
                                color: XCColors.tabNormalColor,
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
        ],
      );
    }

    showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (cxt, state) {
            return _buildBody(state);
          });
        });
  }
}
