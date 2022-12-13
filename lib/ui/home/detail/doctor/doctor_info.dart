import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/certificate.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/honor.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/info.dart';

import '../../../../tool.dart';

class DoctorDetailInfoScreen extends StatefulWidget {
  final int type;
  final DoctorItemEntity entity;

  DoctorDetailInfoScreen(this.type, this.entity);

  @override
  State<StatefulWidget> createState() => DoctorDetailInfoScreenState();
}

class DoctorDetailInfoScreenState extends State<DoctorDetailInfoScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['基本资料', '咨询师证件', '荣誉展示'];
  bool _isGrounding = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    if (_isGrounding) {
      setState(() {
        _tabItems = ['基本资料', '技师证件', '荣誉展示'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(
          context,
          _isGrounding ? '技师的资料' : '咨询师的资料',
          () {
            Navigator.pop(context);
          },
        ),
        body: DefaultTabController(
            length: _tabItems.length,
            initialIndex: widget.type,
            child: Column(children: [
              Container(
                  height: 40,
                  color: Colors.white,
                  child: TabBar(
                      isScrollable: false,
                      labelColor: XCColors.bannerSelectedColor,
                      unselectedLabelColor: XCColors.tabNormalColor,
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(fontSize: 16),
                      indicatorColor: XCColors.bannerSelectedColor,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List<Widget>.generate(_tabItems.length, (index) {
                        String title = _tabItems[index];
                        return Tab(text: title);
                      }))),
              Expanded(
                  child: TabBarView(
                      children:
                          List<Widget>.generate(_tabItems.length, (index) {
                if (index == 0) {
                  return DoctorInfoView(widget.entity);
                } else if (index == 1) {
                  return DoctorCertificateView(widget.entity);
                } else {
                  return DoctorHonorView(widget.entity);
                }
              })))
            ])));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
