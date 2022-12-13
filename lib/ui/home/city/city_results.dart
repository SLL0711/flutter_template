import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'dart:convert' as convert;

class CityResultsScreen extends StatefulWidget {
  final ScreeningParams screeningParams;

  CityResultsScreen(this.screeningParams);

  @override
  State<StatefulWidget> createState() => CityResultsScreenState();
}

class CityResultsScreenState extends State<CityResultsScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  bool _isClear = true; // 是否隐藏清除按钮
  int _type = 0;

  List<HomeAddressEntity> _results = <HomeAddressEntity>[];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    _textEditingController.addListener(() {
      setState(() {
        _isClear = _textEditingController.text.isEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void requestCityInfo(String city) async {
    Map<String, String> params = Map();
    params['name'] = city;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.area, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      _results = <HomeAddressEntity>[];
      setState(() {
        http.data.forEach((element) {
          HomeAddressEntity entity = HomeAddressEntity.fromJson(element);
          if (entity.level == 2) _results.add(entity);
        });
        _type = _results.isEmpty ? 1 : 2;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 搜索结果列表
    Widget _resultsListView() {
      return ListView.builder(
          itemCount: _results.length,
          itemBuilder: (context, index) {
            HomeAddressEntity entity = _results[index];
            return Column(children: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    String location = entity.location;
                    Map<String, dynamic> locationMap =
                        convert.jsonDecode(location);
                    widget.screeningParams.cityCode = entity.id.toString();
                    widget.screeningParams.latitude =
                        locationMap['lat'].toString();
                    widget.screeningParams.longitude =
                        locationMap['lng'].toString();
                    widget.screeningParams.provinceCode = entity.pid.toString();
                    EventCenter.defaultCenter().fire(RefreshProductEvent(5));
                    EventCenter.defaultCenter()
                        .fire(AddressEvent(entity.fullname));
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Container(
                      height: 45,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.white,
                      child: Text(entity.fullname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, color: XCColors.mainTextColor)))),
              Container(height: 1, color: XCColors.homeScreeningColor)
            ]);
          });
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityResultsAppBar(
            context, _textEditingController, _focusNode, () {
          Navigator.pop(context);
        }, (value) {
          if (value.toString().isEmpty)
            return ToastHud.show(context, '搜索内容不能为空');
          requestCityInfo(value);
        }, _isClear),
        body: _type == 0
            ? Container()
            : (_results.isEmpty
                ? EmptyWidgets.cityResultsEmptyView(context)
                : _resultsListView()));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
