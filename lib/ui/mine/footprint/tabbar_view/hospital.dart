import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/hospital.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FootprintHospitalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FootprintHospitalScreenState();
}

class FootprintHospitalScreenState extends State<FootprintHospitalScreen>
    with AutomaticKeepAliveClientMixin {
  List<OrgEntity> _itemEntityList = <OrgEntity>[];
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
    _requestData(0);
  }

  void _requestData(int type) async {
    Map<String, String> params = Map();
    params['pageNum'] = '$_currentPage';
    params['pageSize'] = '10';
    params['type'] = '2';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.footprintList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      OrgTotalEntity entity = OrgTotalEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _itemEntityList.clear();
      }

      _currentPage++;
      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      setState(() {
        _itemEntityList.addAll(entity.list);
        if (type == 2) {
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
    _requestData(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestData(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: MaterialClassicHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          return HomeWidgets.homeRefresherFooter(context, mode);
        },
      ),
      child: _itemEntityList.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : ListView.builder(
              itemCount: _itemEntityList.length,
              itemBuilder: (context, index) {
                // if (index == 0 || index == 3) {
                //   return FootprintWidgets.listHeaderItem(context, index != 0);
                // }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HospitalScreen(_itemEntityList[index].id)));
                  },
                  child: FootprintWidgets.hospitalItem(
                    context,
                    _itemEntityList[index],
                    _isGrounding,
                  ),
                );
              },
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
