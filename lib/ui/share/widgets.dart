import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/member/open.dart';
import 'package:flutter_medical_beauty/ui/mine/team/team.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/invitation.dart';
import 'package:flutter_medical_beauty/ui/share/entity.dart';

import '../../navigator.dart';
import '../../widgets.dart';

abstract class ShareWidgets {
  /// 导航栏
  static appBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: Colors.black,
      centerTitle: true,
      elevation: 0,
      title: Text(
        "分享会员",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ========= 头部视图 =========
  static headView(
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
          Positioned(
            top: 24,
            left: 98,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (entity.nickName ?? '') == '' ? '雀斑' : entity.nickName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  type < 2 ? '您是普通用户' : '您已经是雀斑会员',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 16,
            child: Container(
              width: 66,
              height: 66,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(33),
                ),
              ),
              child: (entity.icon ?? '') == ''
                  ? Image.asset('assets/images/mine/mine_avatar.png')
                  : CommonWidgets.networkImage(entity.icon),
            ),
          ),
          Positioned(
            top: 28,
            right: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtil.pushPage(
                  context,
                  memberIcon.isEmpty ? OpenMemberScreen() : InvitationScreen(),
                );
              },
              child: Container(
                width: 75,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: XCColors.themeColor),
                child: Text(
                  memberIcon.isEmpty ? '开通会员' : '立即分享',
                  style: TextStyle(
                    color: XCColors.mainTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      height: 106,
      color: Colors.black,
      child: _bodyWidget(context, type),
    );
  }

  /// 模块标题
  static sectionTitle(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: XCColors.mainTextColor,
        ),
      ),
    );
  }

  /// 会员权益
  static membershipInterests(BuildContext context) {
    List<InterestEntity> tabs = <InterestEntity>[];
    tabs.add(
        new InterestEntity('会员体验', 'assets/images/profit/ic_legal_one.png'));
    tabs.add(
        new InterestEntity('分享红利', 'assets/images/profit/ic_legal_two.png'));
    tabs.add(
        new InterestEntity('会员特价', 'assets/images/profit/ic_legal_three.png'));
    tabs.add(
        new InterestEntity('积分兑换', 'assets/images/profit/ic_legal_four.png'));
    tabs.add(
        new InterestEntity('红人打造', 'assets/images/profit/ic_legal_five.png'));
    tabs.add(
        new InterestEntity('严选商家', 'assets/images/profit/ic_legal_six.png'));
    tabs.add(
        new InterestEntity('高阶社群', 'assets/images/profit/ic_legal_seven.png'));
    tabs.add(
        new InterestEntity('线上咨询', 'assets/images/profit/ic_legal_eight.png'));
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: new NeverScrollableScrollPhysics(),
      children: List<Container>.generate(
        tabs.length,
        (int index) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                tabs[index].icon,
                width: 44,
                height: 44,
              ),
              SizedBox(height: 10),
              Text(
                tabs[index].name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: XCColors.mainTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 分享赢积分
  static shareEarn(
    BuildContext context,
    MineEntity entity,
    List<ShareConfigEntity> list,
    callback,
  ) {
    double count = entity.heatingPowerValue ?? 0.0;
    // 创建项
    _buildItem(String icon, int total, int integral) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.only(
            top: 8,
            left: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            color: XCColors.homeDividerColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                width: 44,
                height: 44,
              ),
              Text(
                '每满$total个好友\n兑换$integral个积分',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: XCColors.mainTextColor,
                ),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 4,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        color: XCColors.tabNormalColor,
                      ),
                      child: LinearProgressIndicator(
                        value: count / total,
                        backgroundColor: XCColors.tabNormalColor,
                        color: XCColors.themeColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(
                    '${count ~/ 1}/$total',
                    style: TextStyle(
                      fontSize: 8,
                      color: XCColors.tabNormalColor,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => {
                  if (count >= total)
                    {callback(total)}
                  else
                    {NavigatorUtil.pushPage(context, InvitationScreen())}
                },
                child: Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: count >= total ? Colors.white : XCColors.themeColor,
                    border: Border.all(
                      width: 1,
                      color: count >= total
                          ? XCColors.mainTextColor
                          : XCColors.themeColor,
                    ),
                  ),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 5, right: 15),
                  child: Text(
                    count >= total ? '兑换' : '去完成',
                    style: TextStyle(
                      fontSize: 10,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<String> icons = [
      'assets/images/profit/ic_share_ten.png',
      'assets/images/profit/ic_share_fifteen.png',
      'assets/images/profit/ic_share_thirty.png',
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: List.generate(
          list.length,
          (index) => _buildItem(
            icons[index % 3],
            list[index].changeMixValue.toInt(),
            list[index].beautyBalance.toInt(),
          ),
        ),
      ),
    );
  }

  /// 立即分享
  static nowShare(BuildContext context) {
    //创建项
    _buildItem(String title, String desc, String icon, bool isSmall, callback) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: callback,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, top: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: XCColors.homeDividerColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: XCColors.mainTextColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 10,
                    color: XCColors.tabNormalColor,
                  ),
                ),
                Offstage(
                  offstage: !isSmall,
                  child: SizedBox(height: 6),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  child: Image.asset(icon),
                ),
                Offstage(
                  offstage: !isSmall,
                  child: SizedBox(height: 7),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        SizedBox(width: 16),
        _buildItem(
          '分享赚钱',
          '带您的闺蜜来变美',
          'assets/images/profit/ic_share_earn.png',
          false,
          () => {NavigatorUtil.pushPage(context, InvitationScreen())},
        ),
        SizedBox(width: 12),
        _buildItem(
          '我的邀请',
          '您的邀请记录',
          'assets/images/profit/ic_my_invitation.png',
          true,
          () => {NavigatorUtil.pushPage(context, TeamScreen())},
        ),
        SizedBox(width: 16),
      ],
    );
  }
}
