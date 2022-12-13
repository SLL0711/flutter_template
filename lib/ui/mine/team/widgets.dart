import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

abstract class TeamWidgets {
  /// ========= 头部视图 =========
  static teamHeaderView(
    BuildContext context,
    int currentIndex,
    TeamEntity teamEntity,
    final VoidCallback myTap,
    final VoidCallback recommendTap,
  ) {
    Widget _tabItem(String value, String title, bool isSelected) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
                color: isSelected
                    ? XCColors.bannerSelectedColor
                    : XCColors.mainTextColor,
                fontSize: 16),
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
                color: isSelected
                    ? XCColors.bannerSelectedColor
                    : XCColors.tabNormalColor,
                fontSize: 12),
          ),
        ],
      );
    }

    return Container(
      height: 175,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/profit/profit_header_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    child: CommonWidgets.networkImage(teamEntity.icon),
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(teamEntity.nickName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        SizedBox(height: 5),
                        Text('我的好友：${teamEntity.cumulativeLowerLevelMembers}人',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 11))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            right: 15,
            top: 86,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: XCColors.categoryGoodsShadowColor, blurRadius: 6)
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: myTap,
                      child: _tabItem(
                          '${teamEntity.myFriends}', '我的好友', currentIndex == 0),
                    ),
                  ),
                  /*Container(
                        width: 1,
                        height: 33,
                        color: XCColors.categoryGoodsShadowColor),
                    Expanded(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: recommendTap,
                            child: _tabItem('${teamEntity.recommendAFriend}',
                                '推荐好友', currentIndex == 1)))*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ========= Item视图 =========
  static teamItemView(BuildContext context, TeamItemEntity itemEntity) {
    return Container(
      height: 70,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 13),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: itemEntity.icon == ''
                        ? Image.asset('assets/images/mine/mine_avatar.png')
                        : CommonWidgets.networkImage(itemEntity.icon),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemEntity.nickName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: XCColors.mainTextColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          itemEntity.createTime,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11, color: XCColors.tabNormalColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '+${itemEntity.awardAmount}元',
                    style: TextStyle(
                      fontSize: 18,
                      color: XCColors.bannerSelectedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: XCColors.homeDividerColor,
          )
        ],
      ),
    );
  }
}
