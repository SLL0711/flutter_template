import 'dart:async';
import 'dart:ffi';

import 'package:ar_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/consult/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/video/call.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets.dart';

class ConsultListScreen extends StatefulWidget {
  final int type;
  final MineEntity userInfo;

  ConsultListScreen(this.type, this.userInfo);

  @override
  State<StatefulWidget> createState() => ConsultListScreenState();
}

class ConsultListScreenState extends State<ConsultListScreen>
    with AutomaticKeepAliveClientMixin {
  var _consultEvent;
  List<ConsultOrderEntity> _orderList = <ConsultOrderEntity>[];
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _consultEvent.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _consultEvent =
        EventCenter.defaultCenter().on<ConsultEvent>().listen((event) {
      _currentPage = 1;
      _requestList(1);
    });
    Future.delayed(Duration.zero, () {
      _requestList(1);
    });
    super.initState();
  }

  /// 请求
  void _requestList(int type) async {
    // 1->待使用； 2->已使用；3->取消订单
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['doctorId'] = widget.userInfo.doctorId;
    params['status'] = widget.type + 1;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.videoOrderList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ConsultEntity entity = ConsultEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _orderList.clear();
      }

      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      _currentPage++;

      setState(() {
        _orderList.addAll(entity.list);
        if (type == 2) {
          if (entity.total == _orderList.length) {
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
    _requestList(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestList(1);
  }

  /// 发起咨询
  void callConsult(ConsultOrderEntity item) async {
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();
    String channelCode = item.id.toString();
    Map<String, String> params = Map();
    params['title'] = item.doctorName;
    params['content'] = '视频通话邀请';
    params['memberId'] = item.memberId.toString();
    params['expandInformation'] = channelCode;
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.publishPush, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(channelCode, ClientRole.Broadcaster),
        ),
      );
      _updateDoctorStatus(2);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 修改医生状态 咨询状态 0离线 1在线 2咨询中
  void _updateDoctorStatus(int status) {
    Map<String, dynamic> params = new Map();
    params['status'] = status;
    HttpManager.get(
      DsApi.consultStatus + widget.userInfo.doctorId.toString(),
      context,
      params: params,
    );
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
      child: _orderList.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : ListView.builder(
              itemCount: _orderList.length,
              itemBuilder: (context, index) {
                return consultOrderItem(_orderList[index]);
              },
            ),
    );
  }

  Widget consultOrderItem(ConsultOrderEntity item) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1.0,
            offset: Offset(2, 2),
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.fromLTRB(15, 15, 10, 15),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: CommonWidgets.networkImage(item.memberAvatar),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 21),
                    Text(
                      item.memberName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '下单时间：${item.createTime}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xFFF0FEF4),
                        border: Border.all(
                          color: XCColors.goldOutColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item.type == 1
                            ? '该用户选择${item.subscribeBeginTime}咨询'
                            : '该用户选择立即咨询',
                        style: TextStyle(
                          color: XCColors.goldOutColor,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: Container()),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (item.status == 1) {
                      callConsult(item);
                    }
                  },
                  child: Container(
                    width: 75,
                    height: 27,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(27)),
                      color:
                          item.status == 1 ? XCColors.themeColor : Colors.white,
                    ),
                    child: Text(
                      item.status == 1
                          ? '发起咨询'
                          : item.status == 2
                              ? '已完成'
                              : '已取消',
                      style: TextStyle(
                        color: item.status == 1
                            ? Colors.white
                            : XCColors.themeColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
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
