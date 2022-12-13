import 'package:flutter/material.dart';

import '../../../colors.dart';

abstract class CityWidgets {
  /// ========= CityAppbar =========
  static cityAppBar(
      BuildContext context, String title, final VoidCallback backTap) {
    return AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: backTap,
              icon: Image.asset("assets/images/home/back.png",
                  width: 28, height: 28),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip);
        }),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18,
              color: XCColors.mainTextColor,
              fontWeight: FontWeight.bold),
        ));
  }

  /// ========= 搜索框 =========
  static citySearchBox(BuildContext context, final VoidCallback boxTap) {
    return Container(
        height: 44,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 18, right: 27, top: 7, bottom: 7),
        child: GestureDetector(
            onTap: boxTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    color: XCColors.bannerHintColor,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Row(children: [
                  Image.asset("assets/images/home/home_search.png",
                      width: 14, height: 14),
                  SizedBox(width: 20),
                  Text('输入城市名或拼音查询',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.goodsOtherGrayColor, fontSize: 13))
                ]))));
  }

  /// ========= 当前定位 =========
  static cityCurrentLocation(
      BuildContext context, String location, final VoidCallback tap) {
    return Container(
        height: 44,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(children: [
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: tap,
              child: Row(children: [
                Text('当前定位城市：',
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 12)),
                Image.asset("assets/images/home/home_address.png",
                    width: 7, height: 9),
                SizedBox(width: 2, height: double.infinity),
                Text(location,
                    style: TextStyle(
                        color: XCColors.bannerSelectedColor, fontSize: 12))
              ])),
          Expanded(child: Container())
        ]));
  }

  /// ========= 城市搜索结果的头部视图 =========
  VoidCallback searchTap(String value);

  static cityResultsAppBar(
      BuildContext context,
      TextEditingController editingController,
      FocusNode focusNode,
      final VoidCallback backTap,
      searchTap,
      bool isClear,
      {isGoodsSearch = false}) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(children: [
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: backTap,
              child: Container(
                  height: kToolbarHeight,
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Image.asset("assets/images/home/back.png",
                      width: 28, height: 28))),
          Expanded(
              child: Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                      color: XCColors.bannerHintColor,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(children: [
                    Image.asset("assets/images/home/home_search.png",
                        width: 14, height: 14),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: searchTap,
                            focusNode: focusNode,
                            controller: editingController,
                            style: TextStyle(
                                color: XCColors.mainTextColor, fontSize: 12),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: isGoodsSearch ? '水光注射' : '输入城市名或拼音查询',
                                hintStyle: TextStyle(
                                    color: XCColors.goodsOtherGrayColor,
                                    fontSize: 12)))),
                    SizedBox(width: 10),
                    Offstage(
                        offstage: isClear,
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              editingController.clear();
                            },
                            child: Container(
                                height: double.infinity,
                                padding: const EdgeInsets.only(right: 12),
                                child: Image.asset(
                                    "assets/images/home/home_city_search_clear.png",
                                    width: 16,
                                    height: 16))))
                  ])))
        ]));
  }
}
