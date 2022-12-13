import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/member/entity.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/invitation.dart';

import '../../../api.dart';
import '../../../http.dart';
import '../../../toast.dart';

class MemberLevelScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemberLevelScreenState();
}

class MemberLevelScreenState extends State<MemberLevelScreen>
    with AutomaticKeepAliveClientMixin {
  /// 用户信息
  MineEntity _entity = MineEntity();

  /// 会员等级列表
  List<MemberEntity> _list = <MemberEntity>[];

  bool _isGrounding = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestData();
    _requestList();
  }

  void _requestData() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = MineEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestList() async {
    Map<String, dynamic> params = Map();
    params['defaultStatus'] = 0;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.memberLevelList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach(
          (item) => _list.add(
            MemberEntity.fromJson(item),
          ),
        );
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  Widget _buildMemberLevelItem(BuildContext context, MemberEntity member) {
    String icon = 'assets/images/mine/mine_level_one.png';
    // String condition = '条件：邀请好友${member.inviteNum}-${member.teamNum}人';
    // String reward = '奖励：${member.inviteCommissionI}元';
    // if (member.sort == 5) {
    //   icon = 'assets/images/mine/mine_level_four.png';
    // } else if (member.sort == 4) {
    //   icon = 'assets/images/mine/mine_level_three.png';
    // } else if (member.sort == 3) {
    //   icon = 'assets/images/mine/mine_level_two.png';
    // } else {
    //   condition = _isGrounding ? '条件：注册成为雀斑会员' : '条件：支付298元开通会员';
    // }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black38,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('雀斑会员',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(member.memberEquity,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400))
                  ])),
              SizedBox(width: 10),
              // Image.asset(icon, height: 48),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    String levelName = _entity.levelName;
    levelName = levelName.replaceAll('小轻颜', '雀斑');
    if (_isGrounding) {
      if ((_entity.memberLevelId) < 2) {
        levelName = '雀斑会员';
      }
    }

    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mine/mine_level_bg.png'),
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  "assets/images/home/back.png",
                  width: 28,
                  height: 28,
                  color: Colors.white,
                ),
                tooltip: MaterialLocalizations.of(context).previousPageTooltip,
              );
            },
          ),
          title: Text(
            levelName,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(children: [
          Stack(
            children: [
              Container(
                height:
                    296 - MediaQuery.of(context).padding.top - kToolbarHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.bottomCenter,
                    image: AssetImage('assets/images/mine/mine_level_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 9, horizontal: 11),
                width: double.infinity,
                child: Image.asset(
                  'assets/images/mine/mine_level_one_card.png',
                ),
              ),
              Positioned(
                left: 41,
                top: 30,
                child: Row(
                  children: [
                    Text(
                      levelName,
                      style: TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 61,
                      height: 20,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.white60, width: 1),
                      ),
                      child: Text(
                        '当前等级',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 41,
                top: 60,
                child: _isGrounding
                    ? Container()
                    : Text(
                        '会员将于${_entity.vipValidDate}到期',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    '${_isGrounding ? '注册' : '支付298元'}加入会员后，成功邀请好友奖励如下：',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                      itemCount: _list.isEmpty ? _list.length : 1,
                      itemBuilder: (context, index) =>
                          _buildMemberLevelItem(context, _list[index])))),
          Container(
              color: Colors.white,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InvitationScreen()));
                  },
                  child: Container(
                      margin: EdgeInsets.all(15),
                      height: 50,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: XCColors.themeColor),
                      child: Center(
                          child: Text("立即邀请",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white))))))
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
