import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/mine/invoice/invoice.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/item.dart';
import 'package:flutter_medical_beauty/ui/mine/order/use_detail.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'balance.dart';

abstract class MineOrderWidgets {
  static payOrderItemWidget(BuildContext context, MineOrderEntity entity) {
    /// item
    Widget _orderItem() {
      return Column(
        children: [
          Container(height: 10, color: XCColors.homeDividerColor),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: OrderPayItem(entity),
          ),
        ],
      );
    }

    return Container(child: _orderItem());
  }

  static useOrderItemWidget(
      BuildContext context, int type, MineOrderEntity entity) {
    String status = '';
    String buttonText = '';
    if (type == 1) {
      status = '待使用';
      buttonText = '支付尾款';
    } else if (type == 2) {
      status = '待评价';
      buttonText = '去评价';
    } else if (type == 3) {
      status = '待写日记';
      buttonText = '待写日记';
    } else if (type == 4) {
      status = '完成';
      buttonText = '晒单';
    }

    /// 商品item
    Widget _goodsItem() {
      if (type == 1) {
        buttonText = entity.payFinalStatus == 1 ? '核销码' : '支付尾款';
      }
      return Column(
        children: [
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '订单号：${entity.orderSn}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                      fontSize: 14, color: XCColors.bannerSelectedColor),
                ),
              ],
            ),
          ),
          Container(
            height: 82,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: CommonWidgets.networkImage(entity.productPic),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 14),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        children: [
                          Text(
                            '订单合计：',
                            style: TextStyle(
                                color: XCColors.tabNormalColor, fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              '¥${entity.isAllPay == 1 ? entity.allPayAmount : entity.totalAmount}',
                              style: TextStyle(
                                color: XCColors.themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            'x1',
                            style: TextStyle(
                              color: XCColors.goodsGrayColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(height: 1, color: XCColors.homeDividerColor),
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Offstage(
                  offstage: type != 4 ||
                      entity.status != 3 ||
                      entity.isInvoicing == 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtil.pushPage(
                        context,
                        InvoiceScreen(orderId: entity.id),
                      );
                    },
                    child: Container(
                      width: 75,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          width: 1,
                          color: XCColors.themeColor,
                        ),
                      ),
                      child: Text(
                        '发票申请',
                        style: TextStyle(
                          color: XCColors.themeColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (buttonText == '支付尾款') {
                      NavigatorUtil.pushPage(
                        context,
                        MineOrderFinalScreen(entity),
                      );
                    } else {
                      NavigatorUtil.pushPage(
                        context,
                        OrderUseDetailScreen(
                          entity.id,
                          type,
                          isShow: type == 1,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 75,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: XCColors.themeColor,
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    /// item
    Widget _orderItem() {
      return Column(
        children: [
          Container(height: 10, color: XCColors.homeDividerColor),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtil.pushPage(
                  context,
                  OrderUseDetailScreen(entity.id, type),
                );
              },
              child: _goodsItem(),
            ),
          ),
        ],
      );
    }

    return Container(
      child: _orderItem(),
    );
  }

  static orderDetailHeaderWidget(
    BuildContext context,
    MineOrderEntity entity,
    bool isGrounding,
  ) {
    String status = '';
    int type = entity.status;
    if (type == 1) {
      status = '商品合计：';
    } else if (type == 2) {
      status = '待评价';
    } else if (type == 3) {
      status = '待写日记';
    } else if (type == 4) {
      status = '完成';
    } else {
      status = '预约金：';
    }

    /// 商品item
    Widget _goodsInfo() {
      return Container(
        height: 100,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Row(
          children: [
            Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: CommonWidgets.networkImage(entity.productPic)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entity.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 14)),
                  Expanded(child: Container()),
                  Row(
                    children: [
                      Text(status,
                          style: TextStyle(
                              color: XCColors.tabNormalColor, fontSize: 14)),
                      Expanded(
                        child: Text(
                          '¥${entity.isAllPay == 1 ? entity.allPayAmount : entity.totalAmount}',
                          style: TextStyle(
                            color: XCColors.themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        'x1',
                        style: TextStyle(
                            color: XCColors.goodsGrayColor, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// 联系信息
    Widget _contactInfo() {
      return Container(
          child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 30,
          alignment: Alignment.centerLeft,
          child: Text(
            '联系信息',
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 14),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 50,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: XCColors.homeDividerColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  entity.orgName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: XCColors.mainTextColor, fontSize: 12),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (entity.telephone.isEmpty) {
                    ToastHud.show(
                        context, '当前${isGrounding ? '门店' : '商家'}无联系号码，无法拨打电话！');
                  } else {
                    String phone = 'tel:${entity.telephone}';
                    launch(phone);
                  }
                },
                child: Container(
                  width: 50,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: XCColors.mineHeaderDividerColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    '咨询',
                    style:
                        TextStyle(color: XCColors.goodsGrayColor, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(children: [
              Expanded(
                  child: Text(entity.orgAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 12))),
              SizedBox(width: 10),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (entity.telephone.isEmpty) {
                      ToastHud.show(context,
                          '当前${isGrounding ? '门店' : '商家'}无联系号码，无法拨打电话！');
                    } else {
                      String phone = 'tel:${entity.telephone}';
                      launch(phone);
                    }
                  },
                  child: Container(
                      width: 50,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: XCColors.mineHeaderDividerColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text('电话',
                          style: TextStyle(
                              color: XCColors.goodsGrayColor, fontSize: 12))))
            ]))
      ]));
    }

    Widget _orderInfoItem(String title, String value, {bool isFirst = false}) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 27,
          child: Row(children: [
            Container(
                width: 65,
                child: Text(title,
                    style: TextStyle(
                        color: XCColors.tabNormalColor, fontSize: 12))),
            Text(value,
                style: TextStyle(
                    color: isFirst
                        ? XCColors.bannerSelectedColor
                        : XCColors.mainTextColor,
                    fontSize: 12))
          ]));
    }

    Widget _orderInfoOtherItem(String title, String value) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 27,
          child: Row(children: [
            Container(
                width: 65,
                child: Text(title,
                    style: TextStyle(
                        color: XCColors.tabNormalColor, fontSize: 12))),
            Expanded(
                child: Text(value,
                    style: TextStyle(
                        color: XCColors.mainTextColor, fontSize: 12))),
            SizedBox(width: 10),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (entity.orderSn.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: entity.orderSn));
                    ToastHud.show(context, '复制成功');
                  } else {
                    ToastHud.show(context, '复制失败');
                  }
                },
                child: Container(
                    width: 50,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: XCColors.bannerSelectedColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text('复制',
                        style: TextStyle(
                            color: XCColors.bannerSelectedColor,
                            fontSize: 12))))
          ]));
    }

    /// 订单信息
    Widget _orderInfo() {
      return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(width: 1, color: XCColors.homeDividerColor))),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 30,
                alignment: Alignment.centerLeft,
                child: Text('订单信息',
                    style: TextStyle(
                        color: XCColors.mainTextColor, fontSize: 14))),
            SizedBox(height: 5),
            _orderInfoItem('商品金额', '¥${entity.totalProductPrice}',
                isFirst: true),
            _orderInfoItem('订单合计', '¥${entity.totalAmount}'),
            _orderInfoItem('商品数量', '1'),
            _orderInfoItem('到店支付', '¥${entity.finalPrice}'),
            _orderInfoItem('订单时间', entity.createTime),
            _orderInfoOtherItem('订单编号', entity.orderSn),
            _orderInfoItem('预约时间', entity.arriveTime),
            _orderInfoItem('手机号码', entity.phone),
            Container(height: 1, color: XCColors.homeDividerColor),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (entity.telephone.isEmpty) {
                  ToastHud.show(
                      context, '当前${isGrounding ? '门店' : '商家'}无联系号码，无法拨打电话！');
                } else {
                  String phone = 'tel:${entity.telephone}';
                  launch(phone);
                }
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Image.asset(
                        'assets/images/home/home_detail_hospital_call.png',
                        width: 20,
                        height: 18),
                    SizedBox(width: 10),
                    Text(
                      '联系客服',
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(height: 10, color: XCColors.homeDividerColor),
          _goodsInfo(),
          Container(height: 10, color: XCColors.homeDividerColor),
          _contactInfo(),
          Container(height: 10, color: XCColors.homeDividerColor),
          _orderInfo()
        ],
      ),
    );
  }
}
