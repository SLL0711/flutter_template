import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/order.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../colors.dart';
import '../../navigator.dart';
import 'entity.dart';

abstract class BoxWidgets {
  /// ========= boxAppbar =========
  static boxAppbar(
      BuildContext context, String title, final VoidCallback managerTap) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: XCColors.mainTextColor,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: managerTap,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text('管理',
                style: TextStyle(
                    fontSize: 12, color: XCColors.goodsOtherGrayColor)),
          ),
        )
      ],
    );
  }

  /// ========= boxBodyWidget =========
  static boxBodyWidget(BuildContext context, List<ProductItemEntity> list) {
    return Container(
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        padding:
            const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
        crossAxisCount: 4,
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              NavigatorUtil.pushPage(context, DetailScreen(list[index].id),
                  needLogin: false);
            },
            child: HomeWidgets.homeGoodsTile(context, list[index])),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 10.0,
      ),
    );
  }

  /// ========= 猜你喜欢 =========
  static boxBodyTipWidget(BuildContext context) {
    return Container(
      height: 41,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 46),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container(height: 1, color: XCColors.themeColor)),
          SizedBox(width: 10),
          Image.asset(
            "assets/images/box/box_icon_left.png",
            width: 11,
            height: 12,
            color: XCColors.themeColor,
          ),
          SizedBox(width: 4),
          Text(
            '猜你喜欢',
            style: TextStyle(
              fontSize: 16,
              color: XCColors.detailSelectedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Image.asset(
            "assets/images/box/box_icon_right.png",
            width: 11,
            height: 12,
            color: XCColors.themeColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: XCColors.themeColor,
            ),
          ),
        ],
      ),
    );
  }

  /// ========= boxBodyEmptyHeader =========
  static boxBodyEmptyHeaderWidget(BuildContext context) {
    return Container(
      height: 220,
      color: Colors.white,
      child: Column(
        children: [
          Container(height: 1, color: XCColors.homeDividerColor),
          SizedBox(height: 11),
          Image.asset(
            "assets/images/box/box_empty.png",
            width: 128,
            height: 106,
          ),
          SizedBox(height: 10),
          Text('您的购物车暂无商品',
              style: TextStyle(fontSize: 12, color: XCColors.mainTextColor)),
          SizedBox(height: 3),
          Text('去挑选喜欢的商品吧',
              style: TextStyle(fontSize: 10, color: XCColors.tabNormalColor)),
          SizedBox(height: 15),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              EventCenter.defaultCenter().fire(PushTabEvent(0));
            },
            child: Container(
              width: 100,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: XCColors.themeColor,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Text(
                '去逛逛',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ========= boxBodyHeaderListWidget =========
  static boxBodyHeaderListWidget(
      BuildContext context, List<ShoppingCartItemEntity> list) {
    /// 商品item
    Widget _goodsItem(ShoppingCartItemEntity entity) {
      return Row(
        children: [
          Container(
            width: 80,
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: CommonWidgets.networkImage(entity.pic),
          ),
          SizedBox(width: 8),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  entity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: XCColors.mainTextColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // SizedBox(width: 13),
                        RichText(
                          text: TextSpan(
                              text: '¥',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: XCColors.bannerSelectedColor,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                    text: '${entity.skuTotalPrice}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: XCColors.themeColor,
                                      fontSize: 22,
                                    ))
                              ]),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '￥${entity.price}',
                            style: TextStyle(
                              color: XCColors.goodsOtherGrayColor,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: XCColors.goodsOtherGrayColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtil.pushPage(
                          context,
                          DetailOrderView(
                            entity.productId,
                            entity.productSkuId,
                            entity.doctorId,
                            shoppingCardId: entity.id,
                          ));
                    },
                    child: Container(
                      width: 80,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: XCColors.themeColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.5),
                        ),
                      ),
                      child: Text(
                        '立即购买',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ))
        ],
      );
    }

    /// item
    Widget _boxItem(ShoppingCartItemEntity entity) {
      return Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 100,
            padding:
                const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
              ],
            ),
            child: _goodsItem(entity),
          ),
        ],
      );
    }

    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _boxItem(list[index]);
        },
      ),
    );
  }

  /// ========= boxManagerAppbar =========
  static boxManagerAppbar(
      BuildContext context, String title, final VoidCallback backTap) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: backTap,
            icon: Image.asset(
              "assets/images/home/back.png",
              width: 28,
              height: 28,
            ),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: XCColors.mainTextColor,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text('完成',
              style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
        )
      ],
    );
  }

  /// ========= boxManagerListWidget =========
  static boxManagerListWidget(BuildContext context,
      List<ShoppingCartItemEntity> list, Function(int) callback) {
    /// 商品item
    Widget _goodsItem(ShoppingCartItemEntity entity) {
      return Row(
        children: [
          Container(
            width: 80,
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: CommonWidgets.networkImage(entity.pic),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  child: Text(
                    entity.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: XCColors.mainTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          //SizedBox(width: 13),
                          RichText(
                            text: TextSpan(
                                text: '¥',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: XCColors.themeColor,
                                  fontSize: 18,
                                ),
                                children: [
                                  TextSpan(
                                      text: '${entity.price}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: XCColors.bannerSelectedColor,
                                        fontSize: 22,
                                      ))
                                ]),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '￥${entity.price}',
                              style: TextStyle(
                                color: XCColors.goodsOtherGrayColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: XCColors.goodsOtherGrayColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        NavigatorUtil.pushPage(
                            context,
                            DetailOrderView(
                              entity.productId,
                              entity.productSkuId,
                              entity.doctorId,
                              shoppingCardId: entity.id,
                            ));
                      },
                      child: Container(
                        width: 80,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: XCColors.themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(12.5)),
                        ),
                        child: Text(
                          '立即购买',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }

    /// item
    Widget _boxItem(int index) {
      return Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 100,
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    callback(index);
                  },
                  child: Container(
                    width: 51,
                    padding: const EdgeInsets.only(left: 20, right: 15),
                    child: Image.asset(
                        list[index].isSelected
                            ? 'assets/images/box/box_check_selected.png'
                            : 'assets/images/box/box_check_normal.png',
                        fit: BoxFit.cover),
                  ),
                ),
                Expanded(
                  child: _goodsItem(list[index]),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _boxItem(index);
        },
      ),
    );
  }
}
