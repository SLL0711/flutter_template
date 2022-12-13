import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/address/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

typedef VoidCallback onTap(int index);

abstract class AddressWidgets {
  /// ========= item =========
  static addressItem(BuildContext context, AddressEntity entity,
      {required final VoidCallback deleteTap,
      required final VoidCallback defaultTap,
      required final VoidCallback editTap}) {
    /// 主体视图
    Widget _bodyWidget() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 1)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Text(entity.name,
                    style: TextStyle(
                        color: XCColors.mainTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Expanded(
                    child: Text(entity.phoneNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: XCColors.tabNormalColor, fontSize: 14))),
              ],
            ),
            SizedBox(height: 6),
            Text('${entity.province}${entity.city}${entity.detailAddress}',
                style: TextStyle(color: XCColors.mainTextColor, fontSize: 12)),
            SizedBox(height: 7),
            Container(height: 1, color: XCColors.addressDividerColor),
            Container(
              height: 37,
              padding: const EdgeInsets.only(right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: defaultTap,
                    child: Container(
                      height: double.infinity,
                      child: Row(
                        children: [
                          Container(
                              width: 16,
                              height: 16,
                              child: Image.asset(
                                  entity.defaultStatus == 1
                                      ? 'assets/images/box/box_check_selected.png'
                                      : 'assets/images/mine/mine_address_check_normal.png',
                                  fit: BoxFit.cover)),
                          SizedBox(width: 6),
                          Text('设置默认收货地址',
                              style: TextStyle(
                                  color: XCColors.goodsGrayColor,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: editTap,
                          child: Container(
                            padding: const EdgeInsets.only(right: 11),
                            height: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                    width: 12,
                                    height: 12,
                                    child: Image.asset(
                                        'assets/images/mine/mine_address_edit.png',
                                        fit: BoxFit.cover)),
                                SizedBox(width: 2),
                                Text('编辑',
                                    style: TextStyle(
                                        color: XCColors.goodsGrayColor,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: deleteTap,
                          child: Container(
                            padding: const EdgeInsets.only(left: 11),
                            height: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                    width: 12,
                                    height: 12,
                                    child: Image.asset(
                                        'assets/images/mine/mine_address_delete.png',
                                        fit: BoxFit.cover)),
                                SizedBox(width: 3),
                                Text('删除',
                                    style: TextStyle(
                                        color: XCColors.goodsGrayColor,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: _bodyWidget(),
    );
  }

  /// ========= item =========
  static createAddressItem(BuildContext context, String title,
      TextEditingController textEditingController, TextInputType inputType) {
    /// 主体视图
    Widget _bodyWidget() {
      return Row(
        children: [
          Container(
            width: 60,
            child: Text(
              title,
              style: TextStyle(
                color: XCColors.tabNormalColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              keyboardType: inputType,
              controller: textEditingController,
              style: TextStyle(fontSize: 14, color: XCColors.mainTextColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: XCColors.tabNormalColor,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15),
      margin: const EdgeInsets.only(bottom: 1),
      child: _bodyWidget(),
    );
  }

  /// ========= item =========
  static createAddressChooseItem(
      BuildContext context, int type, String value, onTap) {
    /// 主体视图
    Widget _bodyWidget() {
      return Row(
        children: [
          Container(
            width: 60,
            child: Text(
              type == 1 ? '省份' : '市区',
              style: TextStyle(
                color: XCColors.tabNormalColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '请选择' : value,
              style: TextStyle(
                fontSize: 14,
                color: value.isEmpty
                    ? XCColors.tabNormalColor
                    : XCColors.mainTextColor,
              ),
            ),
          ),
          CommonWidgets.grayRightArrow(),
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(type);
      },
      child: Container(
        height: 50,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15, right: 15),
        margin: const EdgeInsets.only(bottom: 1),
        child: _bodyWidget(),
      ),
    );
  }

  /// ========= item =========
  static createAddressDetailItem(
      BuildContext context, TextEditingController textEditingController) {
    return Container(
      height: 80,
      color: Colors.white,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: textEditingController,
        style: TextStyle(fontSize: 14, color: XCColors.mainTextColor),
        maxLines: 30,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '详细地址',
          hintStyle: TextStyle(fontSize: 14, color: XCColors.tabNormalColor),
        ),
      ),
    );
  }
}
