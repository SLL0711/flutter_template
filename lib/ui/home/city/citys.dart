import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/city_results.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'dart:convert' as convert;

class CityScreen extends StatefulWidget {
  final String currentLocation;
  final ScreeningParams locationParams;
  final ScreeningParams screeningParams;

  CityScreen(this.currentLocation, this.locationParams, this.screeningParams);

  @override
  State<StatefulWidget> createState() => CityScreenState();
}

class CityScreenState extends State<CityScreen>
    with AutomaticKeepAliveClientMixin {
  List<HomeAddressEntity> _cityEntityList = <HomeAddressEntity>[];
  List<HomeAddressEntity> _childrenList = <HomeAddressEntity>[];
  String _provinceCode = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      requestAreaInfo();
    });
  }

  void requestAreaInfo() async {
    Map<String, String> params = Map();
    params['level'] = '1';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.area, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          HomeAddressEntity entity = HomeAddressEntity.fromJson(element);
          if (widget.screeningParams.provinceCode.isNotEmpty) {
            if (entity.id == int.parse(widget.screeningParams.provinceCode)) {
              entity.isSelected = true;
              _provinceCode = entity.id.toString();
              _cityEntityList.insert(0, entity);
              requestCityInfo(entity.id);
            } else {
              _cityEntityList.add(entity);
            }
          } else {
            _cityEntityList.add(entity);
          }
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void requestCityInfo(int parentId) async {
    Map<String, String> params = Map();
    params['parentId'] = parentId.toString();

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.area, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      _childrenList = <HomeAddressEntity>[];
      setState(() {
        http.data.forEach((element) {
          HomeAddressEntity entity = HomeAddressEntity.fromJson(element);
          if (widget.screeningParams.cityCode.isNotEmpty) {
            if (entity.id == int.parse(widget.screeningParams.cityCode)) {
              entity.isSelected = true;
            }
          }
          _childrenList.add(entity);
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 左边列表的item
    Widget _leftListItem(HomeAddressEntity cityEntity) {
      return Container(
        height: 45,
        color: cityEntity.isSelected
            ? Colors.white
            : XCColors.addressScreeningNormalColor,
        child: Row(
          children: [
            Offstage(
                offstage: !cityEntity.isSelected,
                child:
                    Container(width: 3, color: XCColors.bannerSelectedColor)),
            SizedBox(width: cityEntity.isSelected ? 12 : 15),
            Expanded(
              child: Text(
                cityEntity.fullname,
                style: TextStyle(
                  fontSize: 12,
                  color: cityEntity.isSelected
                      ? XCColors.themeColor
                      : XCColors.tabNormalColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 右边列表的item
    Widget _rightListItem() {
      return Container(
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
        child: _childrenList.isEmpty
            ? Container()
            : Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                children: _childrenList.map(
                  (e) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (e.isSelected) return;
                        String location = e.location;
                        Map<String, dynamic> locationMap =
                            convert.jsonDecode(location);
                        widget.screeningParams.cityCode = e.id.toString();
                        widget.screeningParams.latitude =
                            locationMap['lat'].toString();
                        widget.screeningParams.longitude =
                            locationMap['lng'].toString();
                        widget.screeningParams.provinceCode = _provinceCode;
                        EventCenter.defaultCenter()
                            .fire(RefreshProductEvent(5));
                        Navigator.pop(context, e.fullname);
                      },
                      child: Container(
                        height: 25,
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 4),
                        decoration: BoxDecoration(
                          color: e.isSelected
                              ? XCColors.themeColor
                              : XCColors.addressScreeningRightNormalColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.5),
                          ),
                        ),
                        child: Text(
                          e.fullname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: e.isSelected
                                ? Colors.white
                                : XCColors.mainTextColor,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
      );
    }

    return Scaffold(
      appBar: CityWidgets.cityAppBar(context, '城市列表', () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          CityWidgets.citySearchBox(
            context,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CityResultsScreen(widget.screeningParams),
                ),
              );
            },
          ),
          Container(height: 10, color: XCColors.homeDividerColor),
          CityWidgets.cityCurrentLocation(
            context,
            widget.currentLocation,
            () {
              if (widget.locationParams.cityCode.isEmpty) return;
              widget.screeningParams.cityCode = widget.locationParams.cityCode;
              widget.screeningParams.latitude = widget.locationParams.latitude;
              widget.screeningParams.longitude =
                  widget.locationParams.longitude;
              widget.screeningParams.provinceCode =
                  widget.locationParams.provinceCode;
              EventCenter.defaultCenter().fire(RefreshProductEvent(5));
              Navigator.pop(context, widget.currentLocation);
            },
          ),
          Container(height: 1, color: XCColors.homeDividerColor),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 120,
                  color: XCColors.addressScreeningNormalColor,
                  child: _cityEntityList.isEmpty
                      ? Container()
                      : ListView.builder(
                          itemCount: _cityEntityList.length,
                          itemBuilder: (context, index) {
                            HomeAddressEntity entity = _cityEntityList[index];
                            return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    _cityEntityList.forEach((element) {
                                      element.isSelected = false;
                                    });
                                    entity.isSelected = true;
                                  });

                                  _provinceCode = entity.id.toString();
                                  // 请求
                                  requestCityInfo(entity.id);
                                },
                                child: _leftListItem(entity));
                          },
                        ),
                ),
                Expanded(
                  child: _rightListItem(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
