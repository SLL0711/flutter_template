import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrgDoctorScreen extends StatefulWidget {
  final int id;

  OrgDoctorScreen(this.id);

  @override
  State<StatefulWidget> createState() => OrgDoctorScreenState();
}

class OrgDoctorScreenState extends State<OrgDoctorScreen>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<DoctorItemEntity> _itemEntityList = <DoctorItemEntity>[];
  int _currentPage = 1;
  int _total = 0;
  bool _isGrounding = false;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestInfo(0);
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.orgDoctorList + widget.id.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      DoctorEntity entity = DoctorEntity.fromJson(http.data);
      if (_currentPage == 1) {
        _itemEntityList.clear();
      }
      _currentPage++;
      setState(() {
        _total = entity.total;
        _itemEntityList.addAll(entity.list);
        if (type == 1) {
          _refreshController.refreshCompleted();
        } else if (type == 2) {
          if (entity.total == _itemEntityList.length) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        }
      });
    } else {
      ToastHud.show(context, http.message!);
      if (type == 1) {
        _refreshController.refreshFailed();
      } else if (type == 2) {
        _refreshController.loadFailed();
      }
    }
  }

  void _onLoading() {
    _requestInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestInfo(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset("assets/images/home/back.png",
                    width: 28, height: 28),
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip);
          }),
          title: Text(_isGrounding ? '技师团队' : '咨询师团队',
              style: TextStyle(
                  fontSize: 18,
                  color: XCColors.mainTextColor,
                  fontWeight: FontWeight.bold)),
          actions: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text('全部（$_total）',
                        style: TextStyle(
                            fontSize: 12, color: XCColors.tabNormalColor))))
          ]),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Container(height: 10, color: XCColors.homeDividerColor),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(),
                onLoading: _onLoading,
                onRefresh: _onRefresh,
                footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                  return HomeWidgets.homeRefresherFooter(context, mode);
                }),
                child: _itemEntityList.isEmpty
                    ? EmptyWidgets.dataEmptyView(context)
                    : ListView.builder(
                        itemCount: _itemEntityList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              NavigatorUtil.pushPage(
                                  context,
                                  DoctorDetailScreen(
                                      _itemEntityList[index].id));
                            },
                            child: FootprintWidgets.doctorItem(
                              context,
                              _itemEntityList[index],
                              _isGrounding,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
