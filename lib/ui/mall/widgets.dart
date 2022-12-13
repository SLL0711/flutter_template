import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/ui/box/box.dart';
import 'package:flutter_medical_beauty/ui/category/category.dart';
import 'package:flutter_medical_beauty/ui/category/search.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';

import '../../colors.dart';
import '../../tool.dart';
import '../../widgets.dart';

abstract class MallWidgets {
  /// ========= MallAppbar =========
  static appBar(
      BuildContext context, String location, final VoidCallback locationTap) {
    /// 定位地址
    Widget _locationWidget(
        BuildContext context, String location, final VoidCallback locationTap) {
      return Container(
        height: kToolbarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Image.asset(
              "assets/images/home/home_address.png",
              width: 16,
              height: 16,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: locationTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                height: double.infinity,
                alignment: Alignment.centerLeft,
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: XCColors.mainTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 头部视图
    Widget _titleWidget(
        BuildContext context, String location, final VoidCallback locationTap) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationWidget(context, location, locationTap),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => {
                NavigatorUtil.pushPage(context, CategorySearchScreen()),
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: XCColors.homeDividerColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/video/ic_search.png',
                      width: 14,
                      height: 14,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "搜索",
                      style: TextStyle(
                        fontSize: 12,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {
              /// 购物车
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BoxScreen()),
              )
            },
            child: Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                "assets/images/home/home_cart.png",
                width: 16,
                height: 16,
              ),
            ),
          )
        ],
      );
    }

    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: _titleWidget(context, location, locationTap),
    );
  }

  /// ========= mallHeader =========
  static mallHeader(BuildContext context, List<TabEntity> tabs,
      List<BannerEntity> banners, final VoidCallback onTap) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ///分类菜单
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: new NeverScrollableScrollPhysics(),
            children: List<GestureDetector>.generate(
              tabs.length,
              (int index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => {
                  NavigatorUtil.pushPage(
                    context,
                    CategoryScreen(id: tabs[index].id),
                  ),
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    tabs[index].icon.isNotEmpty
                        ? Container(
                            width: 44,
                            height: 44,
                            child: CommonWidgets.networkImage(tabs[index].icon),
                          )
                        : Image.asset(
                            'assets/images/home/logo.png',
                            width: 44,
                            height: 44,
                          ),
                    SizedBox(height: 5),
                    Text(
                      tabs[index].name,
                      style: TextStyle(
                        fontSize: 12,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///分隔空间
          Container(height: banners.length == 0 ? 0 : 10),

          ///轮播图
          Offstage(
            offstage: banners.length == 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Tool.openUrl(context, banners[0].url);
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: banners.length == 0 || banners[0].pic.isEmpty
                    ? Container()
                    : CommonWidgets.networkImage(banners[0].pic),
              ),
            ),
          ),

          ///分隔空间
          Container(height: banners.length == 0 ? 0 : 10),
        ],
      ),
    );
  }

  /// ========= 商品item =========
  static mallGoods(BuildContext context, ProductItemEntity itemEntity) {
    /// 标签视图
    Widget _flagItem(String image, String title) {
      return Container(
        width: 16,
        height: 18,
        child: Stack(
          children: [
            Image.asset(image, width: 16, height: 18),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        color: XCColors.homeDividerColor,
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: 165,
            child: CommonWidgets.networkImage(itemEntity.pic),
          ),
          Container(
            height: 25,
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '¥${itemEntity.isEnableFee == 1 ? 0 : itemEntity.minPrice}',
                  style: TextStyle(
                    fontSize: 20,
                    color: XCColors.mainTextColor,
                  ),
                ),
                Offstage(
                  offstage: itemEntity.isEnableFee != 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: Text(
                      '¥${itemEntity.price}',
                      style: TextStyle(
                        fontSize: 11,
                        color: XCColors.tabNormalColor,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: XCColors.tabNormalColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 14,
                  width: 30,
                  margin: const EdgeInsets.only(left: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XCColors.mainTextColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    '正品',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
                Offstage(
                  offstage: itemEntity.isEnableFee != 1,
                  child: Container(
                    height: 14,
                    width: 50,
                    margin: const EdgeInsets.only(left: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: XCColors.mainTextColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      '免费体验',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 5,
              top: 5,
              right: 5,
              bottom: 5,
            ),
            child: Text(
              itemEntity.name,
              style: TextStyle(
                color: XCColors.mainTextColor,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 5,
              top: 3,
              right: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    itemEntity.orgName,
                    style: TextStyle(
                      fontSize: 10,
                      color: XCColors.mainTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  itemEntity.distance.isEmpty
                      ? ''
                      : '${Tool.formatNum(double.parse(itemEntity.distance), 0)}km',
                  style: TextStyle(
                    fontSize: 10,
                    color: XCColors.mainTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
