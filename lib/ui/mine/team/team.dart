import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/team/widgets.dart';

import 'tabbar_view/category.dart';

class TeamScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TeamScreenState();
}

class TeamScreenState extends State<TeamScreen>
    with AutomaticKeepAliveClientMixin {
  List<Widget> _items = [];
  int _currentIndex = 0;
  TeamEntity _teamEntity = TeamEntity();

  @override
  void initState() {
    super.initState();

    setState(() {
      _items.add(TeamCategoryView(0));
      _items.add(TeamCategoryView(1));
    });

    Future.delayed(Duration.zero, () {
      init();
    });
  }

  void init() async {
    Map<String, String> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '10';
    params['type'] = '0';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.teamInfo, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _teamEntity = TeamEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '我的好友', () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          TeamWidgets.teamHeaderView(context, _currentIndex, _teamEntity, () {
            setState(() {
              _currentIndex = 0;
            });
          }, () {
            setState(() {
              _currentIndex = 1;
            });
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(_currentIndex == 0 ? '我的好友' : '推荐好友',
                        style: TextStyle(
                            fontSize: 14, color: XCColors.mainTextColor))),
                Text(
                  _currentIndex == 0
                      ? '${_teamEntity.myFriends}人'
                      : '${_teamEntity.recommendAFriend}人',
                  style: TextStyle(fontSize: 14, color: XCColors.mainTextColor),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty ? Container() : _items[_currentIndex],
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
