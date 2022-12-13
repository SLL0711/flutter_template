import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';

import '../../colors.dart';

typedef VoidCallback tapAction(int index);

abstract class CategoryWidgets {
  /// ========= CategoryAppbar =========
  static categoryAppBar(BuildContext context, String title) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Image.asset("assets/images/home/back.png",
                width: 28, height: 28),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip);
      }),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: XCColors.mainTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ========= 搜索框 =========
  static categorySearchBox(BuildContext context, final VoidCallback boxTap) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 14, right: 15, top: 10, bottom: 10),
      child: GestureDetector(
        onTap: boxTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: XCColors.bannerHintColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                "assets/images/home/home_search.png",
                width: 14,
                height: 14,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '水光注射',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: XCColors.categorySearchHintColor, fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ========= 左边列表 =========
  static categoryLeftListView(
      BuildContext context, List<TabEntity> tabItems, tapAction) {
    /// 列表的item
    Widget _listItem(int index) {
      TabEntity entity = tabItems[index];
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          tapAction(index);
        },
        child: Container(
          height: 45,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: entity.isSelected
              ? Colors.white
              : XCColors.addressScreeningNormalColor,
          child: Text(
            entity.name,
            style: TextStyle(
              fontSize: entity.isSelected ? 14 : 12,
              fontWeight: FontWeight.bold,
              color: entity.isSelected
                  ? XCColors.themeColor
                  : XCColors.mainTextColor,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 100,
      color: Colors.white,
      child: ListView.builder(
        itemCount: tabItems.length,
        itemBuilder: (context, index) {
          return _listItem(index);
        },
      ),
    );
  }
}
