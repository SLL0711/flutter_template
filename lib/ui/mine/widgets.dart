import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/integral/integral.dart';
import 'package:flutter_medical_beauty/ui/mine/team/team.dart';

import '../../widgets.dart';

typedef VoidCallback tapAction(int index);

abstract class MineWidgets {
  /// ========= 头部视图 =========
  static mineHeaderView(
      BuildContext context, int type, MineEntity entity, tapAction) {
    /// 消息
    Widget _messageWidget() {
      bool isHiddenNumber = true;
      if (type != 0 && type != 99) {
        // 判断消息条数
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          tapAction(1);
        },
        child: Stack(
          children: [
            Container(
                height: 42,
                width: 42,
                alignment: Alignment.center,
                child: Image.asset("assets/images/mine/mine_message.png",
                    width: 18, height: 22)),
            Positioned(
              top: 6,
              right: 3,
              child: Offstage(
                offstage: isHiddenNumber,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.bannerSelectedColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('11',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 个人信息的item
    Widget _personItem(String title, dynamic value, int tapType) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            tapAction(tapType);
          },
          child: Column(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: XCColors.tabNormalColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$value',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// 个人信息
    Widget _personWidget() {
      String nickName = '';
      dynamic focus = 0;
      dynamic fans = 0;
      String memberIcon = '';
      dynamic gold = 0; // 颜值金
      dynamic beautyBean = 0;
      int experienceVoucher = 0; // 会员券
      int coupons = 0; // 优惠券

      if (type == 0) {
        nickName = '注册/登录';
      }

      if (type != 0 && type != 99) {
        nickName = entity.nickName!;
        focus = entity.attentionNumber!;
        fans = entity.numberOfFans!;
        gold = entity.beautyBalance!;
        experienceVoucher = entity.experienceVoucher!;
        coupons = entity.coupon!;
        beautyBean = entity.beautyBean!;
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

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15, left: 17, right: 13),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    tapAction(4);
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    child: entity.icon == ''
                        ? Image.asset('assets/images/mine/mine_avatar.png')
                        : CommonWidgets.networkImage(entity.icon ?? ''),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      tapAction(4);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: XCColors.mainTextColor,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          height: 25,
                          // color: Colors.red,
                          child: Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  tapAction(5);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '关注 $focus',
                                      style: TextStyle(
                                        color: XCColors.mainTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      width: 1,
                                      height: 10,
                                      color: XCColors.mineHeaderDividerColor,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '粉丝 $fans',
                                      style: TextStyle(
                                        color: XCColors.mainTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: Container())
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                memberIcon.isEmpty
                    ? Container()
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          tapAction(6);
                        },
                        child: Container(
                          height: 30,
                          child: Image.asset(memberIcon, fit: BoxFit.cover),
                        ),
                      ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0XFFDEDEDE),
                  size: 16,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _personItem('Star积分', gold, 7),
                  // _personItem('颜值豆', beautyBean, 10),
                  _personItem('会员券', experienceVoucher, 8),
                  // _personItem('优惠券', coupons, 9),
                ],
              ),
            ),
          ),
        ],
      );
    }

    /// 主体视图
    Widget _bodyWidget() {
      return Stack(
        children: [
          Container(
            height: 226 - MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.bottomCenter,
                image: AssetImage('assets/images/mine/mine_header_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(top: 10, left: 3, child: _messageWidget()),
          Positioned(
            top: 10,
            right: 5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapAction(2);
              },
              child: Container(
                height: 42,
                width: 42,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/mine/mine_setting.png",
                  width: 24,
                  height: 22,
                ),
              ),
            ),
          ),
          /*Positioned(
            top: 10,
            right: 46,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  tapAction(3);
                },
                child: Container(
                    height: 42,
                    width: 42,
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/mine/mine_service.png",
                        width: 24, height: 22,),),),),*/
          Positioned(
            top: 57,
            right: 10,
            left: 10,
            bottom: 0,
            child: Card(
              shadowColor: Colors.white,
              elevation: 5,
              child: _personWidget(),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 230,
      child: _bodyWidget(),
    );
  }

  /// ========= 开通会员视图 =========
  static mineMemberView(
      BuildContext context, int type, final VoidCallback openMemberTap) {
    bool isHiddenWidget = type == 0 || type == 1 || type == 99;

    /// 主体视图
    Widget _bodyWidget() {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/images/mine/mine_banner_member.png",
              width: 53,
              height: 53,
            ),
            SizedBox(width: 10),
            Expanded(
                child: Text('加入雀斑会员，多重惊喜好礼',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: XCColors.bannerSelectedColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))),
            SizedBox(width: 10),
            Container(
              width: 72,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: XCColors.themeColor,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, //右上
                  end: Alignment.topCenter, //左下
                  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [Color(0XFFD28B52), Color(0XFFF6C79B)],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
              child: Text(
                '立即开卡',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Offstage(
      offstage: !isHiddenWidget,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: openMemberTap,
        child: Container(
          height: 91,
          padding: const EdgeInsets.only(top: 8, left: 14, right: 14),
          child: _bodyWidget(),
        ),
      ),
    );
  }

  /// ========= 订单视图 =========
  static mineOrderView(BuildContext context, tapAction) {
    Widget _orderItem(String image, String title, int tapType) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            tapAction(tapType);
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(image, width: 43, height: 42),
                ),
              ),
              Text(title,
                  style:
                      TextStyle(color: XCColors.mainTextColor, fontSize: 14)),
              SizedBox(height: 18)
            ],
          ),
        ),
      );
    }

    /// 主体视图
    Widget _bodyWidget() {
      return Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              tapAction(0);
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '我的订单',
                    style: TextStyle(
                      color: XCColors.mainTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                      width: 7,
                      height: 14,
                      child: Image.asset(
                          'assets/images/mine/mine_gray_arrow_right.png',
                          fit: BoxFit.cover))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _orderItem(
                    'assets/images/mine/mine_order_pay.png',
                    '待支付',
                    0,
                  ),
                  _orderItem(
                    'assets/images/mine/mine_order_use.png',
                    '待使用',
                    1,
                  ),
                  _orderItem(
                    'assets/images/mine/mine_order_evaluation.png',
                    '待评价',
                    2,
                  ),
                  _orderItem(
                    'assets/images/mine/mine_order_diary.png',
                    '写日记',
                    3,
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15),
      shadowColor: Colors.white,
      elevation: 5,
      child: Container(
        height: 135,
        child: _bodyWidget(),
      ),
    );
  }

  /// ========= 热力值视图 =========
  static mineHotView(BuildContext context, int type, MineEntity entity,
      final VoidCallback hotTap) {
    /// 主体视图
    Widget _bodyWidget() {
      dynamic hotValue = 0;

      if (type != 0 && type != 99) {
        hotValue = entity.heatingPowerValue!;
      }

      return Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Text(
                      '我的Star积分',
                      style: TextStyle(
                        fontSize: 14,
                        color: XCColors.mainTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '已获得$hotValue积分',
                    style:
                        TextStyle(fontSize: 10, color: XCColors.tabNormalColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 36,
            child: Image.asset('assets/images/mine/mine_power_icon.png'),
          ),
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: hotTap,
      child: Card(
        shadowColor: Colors.white,
        margin: EdgeInsets.only(left: 15, right: 2.5),
        elevation: 5,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: _bodyWidget(),
        ),
      ),
    );
  }

  /// ========= 团队视图 =========
  static mineTeamView(BuildContext context, int type, MineEntity entity,
      final VoidCallback teamTap) {
    /// 主体视图
    Widget _bodyWidget() {
      return Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Text(
                      '我的好友',
                      style: TextStyle(
                        fontSize: 14,
                        color: XCColors.mainTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${entity.myFriend ?? 0}人',
                    style:
                        TextStyle(fontSize: 10, color: XCColors.tabNormalColor),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 36,
            child: Image.asset('assets/images/mine/mine_friend_icon.png'),
          ),
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: teamTap,
      child: Card(
        shadowColor: Colors.white,
        margin: EdgeInsets.only(left: 2.5, right: 15),
        elevation: 5,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: _bodyWidget(),
        ),
      ),
    );
  }

  /// ========= 其他功能 =========
  static mineOtherView(
      BuildContext context, bool isGrounding, MineEntity userInfo, tapAction) {
    Widget _otherItem(String image, String title, int type) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            tapAction(type);
          },
          child: Column(
            children: [
              SizedBox(height: 12),
              Image.asset(image, width: 30, height: 30),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(color: XCColors.mainTextColor, fontSize: 14),
              ),
              SizedBox(height: 12)
            ],
          ),
        ),
      );
    }

    /// 主体视图
    Widget _bodyWidget() {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // _otherItem('assets/images/mine/mine_circle_icon.png', '颜值圈', 1),
          _otherItem('assets/images/mine/mine_collection_icon.png', '我的收藏', 2),
          _otherItem('assets/images/mine/mine_footprint_icon.png', '我的足迹', 3),
          _otherItem('assets/images/mine/mine_diary_icon.png', '我的日记', 4),
          _otherItem('assets/images/mine/mine_store_icon.png',
              isGrounding ? '门店入驻' : '商家入驻', 9),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // _otherItem(
          //     'assets/images/mine/mine_interactive_icon.png', '互动问答', 6),
          // _otherItem('assets/images/mine/mine_insurance_icon.png', '颜值保', 7),
          // _otherItem('assets/images/mine/mine_invoice_icon.png', '发票信息', 8),
          // _otherItem('assets/images/mine/mine_sign_icon.png', '签到领钱', 5),
          Expanded(child: Container())
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _otherItem('assets/images/mine/mine_consult_icon.png', '我的咨询', 10),
            userInfo.doctorId == 0
                ? Expanded(child: Container())
                : _otherItem(
                    'assets/images/mine/mine_consulting_icon.png', '咨询订单', 11),
            Expanded(child: Container()),
            Expanded(child: Container()),
          ],
        ),
      ]);
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15),
      shadowColor: Colors.white,
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
        child: _bodyWidget(),
      ),
    );
  }

  ///头部
  static headView(
    BuildContext context,
    int type,
    MineEntity entity,
    tapAction,
  ) {
    //消息
    Widget _messageWidget(int count) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          tapAction(1);
        },
        child: Stack(
          children: [
            Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/mine/ic_message.png",
                width: 24,
                height: 24,
              ),
            ),
            Positioned(
              top: 6,
              right: 3,
              child: Offstage(
                offstage: count == 0,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XCColors.bannerSelectedColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    //个人信息
    Widget _personWidget() {
      String nickName = '';
      dynamic focus = 0;
      dynamic fans = 0;

      if (type == 0) {
        nickName = '注册/登录';
      }

      if (type != 0 && type != 99) {
        nickName = entity.nickName!;
        focus = entity.attentionNumber!;
        fans = entity.numberOfFans!;
      }

      return Row(
        children: [
          SizedBox(width: 32),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              tapAction(4);
            },
            child: Container(
              width: 66,
              height: 66,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(33),
                ),
              ),
              child: entity.icon == ''
                  ? Image.asset('assets/images/mine/mine_avatar.png')
                  : CommonWidgets.networkImage(entity.icon ?? ''),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapAction(4);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: XCColors.mainTextColor,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    height: 25,
                    // color: Colors.red,
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            tapAction(5);
                          },
                          child: Row(
                            children: [
                              Text(
                                '关注 $focus',
                                style: TextStyle(
                                  color: XCColors.mainTextColor,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                width: 1,
                                height: 10,
                                color: XCColors.mineHeaderDividerColor,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '粉丝 $fans',
                                style: TextStyle(
                                  color: XCColors.mainTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      );
    }

    return Container(
      color: XCColors.homeDividerColor,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            child: _personWidget(),
          ),
          Positioned(top: 10, right: 45, child: _messageWidget(0)),
          Positioned(
            top: 10,
            right: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapAction(2);
              },
              child: Container(
                height: 24,
                width: 24,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/mine/ic_setting.png",
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///开通会员
  static openMember(
      BuildContext context, int type, final VoidCallback openMemberTap) {
    bool isHiddenWidget = type == 0 || type == 1 || type == 99;

    /// 主体视图
    Widget _bodyWidget() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: XCColors.mainTextColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Expanded(
              child: Text(
                '十二项免费体验项目',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 75,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: XCColors.themeColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Text(
                '立即开通',
                style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
        ),
      );
    }

    return Offstage(
      offstage: !isHiddenWidget,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: openMemberTap,
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          child: _bodyWidget(),
        ),
      ),
    );
  }

  /// 订单
  static orderView(BuildContext context, tapAction) {
    //状态项
    Widget _orderItem(String image, String title, int tapType) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            tapAction(tapType);
          },
          child: Column(
            children: [
              SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  image,
                  width: 48,
                  height: 48,
                ),
              ),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 主体视图
    Widget _bodyWidget() {
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '我的订单',
              style: TextStyle(
                color: XCColors.mainTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _orderItem(
                  'assets/images/mine/ic_all_order.png',
                  '全部订单',
                  0,
                ),
                _orderItem(
                  'assets/images/mine/ic_pay_order.png',
                  '待支付',
                  0,
                ),
                _orderItem(
                  'assets/images/mine/ic_consume_order.png',
                  '待消费',
                  1,
                ),
                _orderItem(
                  'assets/images/mine/ic_comment_order.png',
                  '待评价',
                  2,
                ),
                _orderItem(
                  'assets/images/mine/ic_refund_order.png',
                  '退款',
                  3,
                )
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: _bodyWidget(),
    );
  }

  /// 我的
  static myView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {
              NavigatorUtil.pushPage(context, IntegralScreen()),
            },
            child: Container(
              height: 115,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: XCColors.homeDividerColor,
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 43,
                    bottom: 7,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/mine/ic_my_integral.png',
                        width: 89,
                        height: 73,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Text(
                      "我的积分",
                      style: TextStyle(
                        fontSize: 12,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 13),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {
              NavigatorUtil.pushPage(context, TeamScreen()),
            },
            child: Container(
              height: 115,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                color: XCColors.homeDividerColor,
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 60,
                    bottom: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/mine/ic_my_friend.png',
                        width: 85,
                        height: 95,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Text(
                      "我的好友",
                      style: TextStyle(
                        fontSize: 12,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }

  /// 菜单
  static menuView(BuildContext context, bool hideOrder, tapAction) {
    //菜单项
    _buildItem(String name, int position) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => {tapAction(position)},
        child: Container(
          padding: EdgeInsets.only(
            left: 17,
            top: 10,
            right: 17,
            bottom: 10,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    color: XCColors.mainTextColor,
                  ),
                ),
              ),
              Image.asset(
                'assets/images/mine/mine_gray_arrow_right.png',
                color: XCColors.mainTextColor,
                height: 14,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildItem('我的收藏', 2),
        _buildItem('我的足迹', 3),
        _buildItem('官方客服', 1),
        _buildItem('商家入驻', 9),
        _buildItem('我的咨询', 10),
        hideOrder ? Container() : _buildItem('咨询订单', 11),
      ],
    );
  }
}
