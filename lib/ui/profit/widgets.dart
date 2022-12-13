import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/member/member.dart';
import 'package:flutter_medical_beauty/ui/mine/member/open.dart';
import 'package:flutter_medical_beauty/ui/mine/team/team.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/invitation.dart';

import '../../navigator.dart';
import '../../widgets.dart';
import 'detail/hot.dart';

abstract class ProfitWidgets {
  /// ========= 头部视图 =========
  static profitHeaderView(
    BuildContext context,
    MineEntity entity,
    bool isGrounding,
  ) {
    String memberIcon = '';
    int type = entity.memberLevelId ?? 0;
    if (isGrounding && type == 1) {
      type = 2;
    }
    if (type == 2) {
      memberIcon = 'assets/images/mine/mine_level_one.png';
    } else if (type == 3) {
      memberIcon = 'assets/images/mine/mine_level_two.png';
    } else if (type == 4) {
      memberIcon = 'assets/images/mine/mine_level_three.png';
    } else if (type == 5) {
      memberIcon = 'assets/images/mine/mine_level_four.png';
    }

    /// 主体视图
    Widget _bodyWidget(BuildContext context, int type) {
      return Stack(
        children: [
          Container(
            height: 243 - MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/profit/profit_header_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 27,
            left: 85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (entity.nickName ?? '') == '' ? '雀斑' : entity.nickName!,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  type < 1 ? '暂未开通会员' : '您已经是雀斑会员',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              width: 57,
              height: 57,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: (entity.icon ?? '') == ''
                  ? Image.asset('assets/images/mine/mine_avatar.png')
                  : CommonWidgets.networkImage(entity.icon ?? ''),
            ),
          ),
          Positioned(
            top: 27,
            right: 24,
            child: memberIcon.isNotEmpty
                ? Image.asset(
                    memberIcon,
                    width: 103,
                    height: 38,
                  )
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtil.pushPage(context, OpenMemberScreen());
                    },
                    child: Container(
                      width: 90,
                      height: 30,
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Text(
                        '开通会员',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
          ),
        ],
      );
    }

    return Container(
      height: 173,
      child: _bodyWidget(context, type),
    );
  }

  /// ========= 我的好友视图 =========
  static profitFriendsView(
    BuildContext context,
    MineEntity entity,
    bool isGrounding,
  ) {
    /// item
    Widget _friendItem(String title, Color mainColor, Color crossColor,
        int maxNumber, int minNumber, int value) {
      /// 默认填充高度
      double fillHeight = 4;
      if (value > 0) {
        fillHeight = value * (100 / maxNumber);
      }
      return Expanded(
        child: Column(
          children: [
            SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(color: XCColors.mainTextColor, fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '$maxNumber',
              style: TextStyle(color: XCColors.mainTextColor, fontSize: 12),
            ),
            SizedBox(height: 8),
            Container(
              width: 104,
              height: 104,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(52)),
                border: Border.all(color: mainColor, width: 1),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 1,
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 100,
                      height: 100,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: fillHeight,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter, //右上
                                  end: Alignment.topCenter, //左下
                                  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                                  //渐变颜色[始点颜色, 结束颜色]
                                  colors: [mainColor, crossColor],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: fillHeight + 5,
                    child: Offstage(
                      offstage: value == 0,
                      child: Center(
                        child: Text(
                          '$value',
                          style: TextStyle(color: mainColor, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$minNumber',
              style: TextStyle(color: XCColors.mainTextColor, fontSize: 12),
            ),
            SizedBox(height: 15)
          ],
        ),
      );
    }

    /// 主体视图
    Widget _bodyWidget(BuildContext context, MineEntity entity) {
      int type = entity.memberLevelId ?? 0;
      int leftValue = entity.myFriend ?? 0;
      int rightValue = entity.recommendAFriend ?? 0;
      int leftMaxNumber = 10;
      int rightMaxNumber = 30;
      int leftMinNumber = 0;
      int rightMinNumber = 0;
      String memberTip = '';

      if (isGrounding && type == 1) {
        type = 2;
      }

      if (type == 1) {
        memberTip = '开通即可尊享会员权益';
      } else if (type == 2) {
        memberTip = '满足条件即可升级为黄金会员';
      } else if (type == 3) {
        memberTip = '满足条件即可升级为铂金会员';
      } else if (type == 4) {
        leftMaxNumber = 50;
        rightMaxNumber = 100;
        leftMinNumber = 11;
        rightMinNumber = 31;
        memberTip = '满足条件即可升级为钻石会员';
      } else if (type == 5) {
        leftMaxNumber = 200;
        rightMaxNumber = 400;
        leftMinNumber = 51;
        rightMinNumber = 101;
        memberTip = '积满钻石会员即可专享等级优惠';
      }

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _friendItem('我的好友', Color(0XFF86D2EB), Color(0XFFE5F0F3),
                  leftMaxNumber, leftMinNumber, leftValue),
              /*Container(
                margin: const EdgeInsets.only(top: 50),
                width: 1,
                height: 60,
                color: XCColors.homeScreeningColor,
              ),
              _friendItem('好友推荐', Color(0XFFF699B9), Color(0XFFF3E5EB),
                  rightMaxNumber, rightMinNumber, rightValue),*/
            ],
          ),
          // Text(
          //   memberTip,
          //   style: TextStyle(color: XCColors.bannerSelectedColor, fontSize: 12),
          // ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              if (type > 1) {
                NavigatorUtil.pushPage(context, MemberLevelScreen(),
                    needLogin: true);
              } else {
                NavigatorUtil.pushPage(context, OpenMemberScreen(),
                    needLogin: true);
              }
            },
            child: Container(
              width: 72,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.5)),
                border:
                    Border.all(color: XCColors.bannerSelectedColor, width: 1),
              ),
              child: Text(
                '了解更多',
                style: TextStyle(
                    color: XCColors.bannerSelectedColor, fontSize: 12),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 287,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 4)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: _bodyWidget(context, entity),
    );
  }

  /// ========= 热力值视图 =========
  static profitHotView(
      BuildContext context, MineEntity entity, VoidCallback exchangeTap) {
    /// 进度条视图
    Widget _progressWidget() {
      dynamic value = 0.0; // 具体数值
      double fillWidth = 5; // 填充的宽度
      double valueLeft = 0; // 值距离左边的数值

      /// 屏幕宽度
      double screenWidth = MediaQuery.of(context).size.width;
      int type = entity.memberLevelId ?? 1;

      if (type != 1) {
        value = entity.heatingPowerValue ?? 0.0;
        fillWidth += value * ((screenWidth - 38) / 30.0);
        valueLeft = fillWidth - 6.5;
      }

      return Container(
        height: 98,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 53,
              child: Container(
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: XCColors.profitProcessHintColor),
              ),
            ),
            Positioned(
              left: 0,
              top: 53,
              child: Container(
                height: 6,
                width: fillWidth,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft, //右上
                    end: Alignment.centerRight, //左下
                    stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                    //渐变颜色[始点颜色, 结束颜色]
                    colors: [Color(0xFFFE90B2), Color(0xFFAFEAFD)],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 62,
              child: Container(
                padding: const EdgeInsets.only(left: 5, top: 3, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0好友',
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 12),
                    ),
                    Offstage(
                      offstage: type == 1,
                      child: Text(
                        '¥1000',
                        style:
                            TextStyle(color: Color(0XFFB092B2), fontSize: 10),
                      ),
                    ),
                    Text(
                      '30好友',
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 0,
              top: 27,
              child: Offstage(
                offstage: value < 15.0,
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: exchangeTap,
                    child: Container(
                      width: 27,
                      height: 26,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/profit/profit_receive.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        '领取',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: valueLeft,
              top: 30,
              child: Offstage(
                offstage: value == 0.0,
                child: Container(
                  width: 23,
                  height: 21,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/profit/profit_value.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Text(
                    '${value.floor()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: fillWidth,
              top: 51,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: value > 0.0 ? Color(0xFFB6E2F6) : Color(0xFFFE90B2),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      color:
                          value > 0.0 ? Color(0xFFB6E2F6) : Color(0xFFFE90B2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 主体视图
    Widget _bodyWidget() {
      return Column(
        children: [
          SizedBox(
            height: 15,
          ),
          // Text(
          //   '我的热力值',
          //   style: TextStyle(color: XCColors.mainTextColor, fontSize: 15),
          // ),
          _progressWidget(),
          Text(
            '每满15个好友兑换100000个Star积分',
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 10),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '每满30个好友兑换300000个Star积分',
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 10),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              NavigatorUtil.pushPage(context, HotScreen());
            },
            child: Container(
              width: 72,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.5)),
                border: Border.all(color: XCColors.themeColor, width: 1),
              ),
              child: Text(
                '了解更多',
                style: TextStyle(color: XCColors.themeColor, fontSize: 12),
              ),
            ),
          )
        ],
      );
    }

    return Container(
      height: 217,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 4)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: _bodyWidget(),
    );
  }

  /// ========= 分享视图 =========
  static profitShareView(BuildContext context, MineEntity entity) {
    /// item
    Widget _shareItem(String icon, String title, String value,
        String buttonTitle, VoidCallback operateTap) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 4)
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Container(
                height: 42,
                child: Image.asset(icon),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(color: XCColors.mainTextColor, fontSize: 18),
              ),
              Text(
                value,
                style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: operateTap,
                child: Container(
                  width: 80,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.5)),
                    border: Border.all(
                        color: XCColors.bannerSelectedColor, width: 1),
                  ),
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                        color: XCColors.bannerSelectedColor, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// 主体视图
    Widget _bodyWidget(BuildContext context) {
      int shareNumber = entity.shareCount ?? 0; // 分享人数
      int teamNumber = entity.numberOfMyTeam ?? 0; // 团队人数

      return Row(
        children: [
          _shareItem('assets/images/profit/profit_share_earn.png', '分享赚',
              '已分享$shareNumber次', '去分享', () {
            NavigatorUtil.pushPage(context, InvitationScreen(),
                needLogin: true);
          }),
          SizedBox(
            width: 11,
          ),
          _shareItem('assets/images/profit/profit_team.png', '我的好友',
              '已累计$teamNumber人', '详情', () {
            NavigatorUtil.pushPage(context, TeamScreen(), needLogin: true);
          })
        ],
      );
    }

    return Container(
      height: 156,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: _bodyWidget(context),
    );
  }
}
