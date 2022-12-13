import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/sign/entity.dart';

class SignScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen>
    with AutomaticKeepAliveClientMixin {

  List<SignEntity> _itemEntityList = <SignEntity>[];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      init();
    });
  }

  void init() async {
    ToastHud.loading(context);
    var http =
    await HttpManager.get(DsApi.signList, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      _itemEntityList.clear();
      setState(() {
        http.data.forEach((element) {
          _itemEntityList.add(SignEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _signAction() async {
    ToastHud.loading(context);
    var http =
    await HttpManager.get(DsApi.memberSign, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '签到成功！');
      Navigator.pop(context);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _item(SignEntity entity) {
      return Expanded(
          child: Container(
              child: Column(children: [
        Row(children: [
          Expanded(
              child: Container(height: 5, color: XCColors.bannerSelectedColor)),
          Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: XCColors.bannerSelectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text('+${entity.beautyBean.toString().split('.').first}',
                  style: TextStyle(fontSize: 14, color: Colors.white))),
          Expanded(
              child: Container(height: 5, color: XCColors.bannerSelectedColor)),
        ]),
        SizedBox(height: 10),
        Text(entity.timeStr,
            style: TextStyle(fontSize: 12, color: XCColors.mainTextColor))
      ])));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '签到抽奖', () {
          Navigator.pop(context);
        }),
        body: Container(
            height: double.infinity,
            color: XCColors.signBgColor,
            child: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 10),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: Column(children: [
                    SizedBox(height: 10),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          Expanded(
                              child: Text('我的颜值豆：16',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: XCColors.mainTextColor))),
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                EventCenter.defaultCenter()
                                    .fire(PushTabEvent(0));
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 70,
                                  height: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: XCColors.bannerSelectedColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.5))),
                                  child: Text('轻颜商城',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white))))
                        ])),
                    Text('已连续签到',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: XCColors.mainTextColor)),
                    SizedBox(height: 5),
                    RichText(
                        text: TextSpan(
                            text: '1',
                            style: TextStyle(
                                fontSize: 40,
                                color: XCColors.mainTextColor,
                                fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                              text: '天',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: XCColors.mainTextColor,
                                  fontWeight: FontWeight.bold))
                        ])),
                    SizedBox(height: 5),
                    Text('连续签到每日可递增一个颜值豆',
                        style: TextStyle(
                            fontSize: 10, color: XCColors.tabNormalColor)),
                    Text('签到每满7天/签到中断则从1个豆计算',
                        style: TextStyle(
                            fontSize: 10, color: XCColors.tabNormalColor)),
                    SizedBox(height: 20),
                    _itemEntityList.isEmpty ? Container() : Row(
                        children: List.generate(_itemEntityList.length, (index) {
                      return _item(_itemEntityList[index]);
                    })),
                    SizedBox(height: 15),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _signAction,
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 40,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: XCColors.bannerSelectedColor),
                            child: Text('签到',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))),
                    SizedBox(height: 15)
                  ]))
            ]))));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
