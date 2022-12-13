import 'package:ar_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/consult/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/video/dialog.dart';
import 'package:flutter_medical_beauty/ui/video/video_detail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../empty.dart';
import 'call.dart';

class VideoOrderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VideoOrderScreenState();
}

class VideoOrderScreenState extends State<VideoOrderScreen>
    with AutomaticKeepAliveClientMixin {
  var _consultEvent;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List _orderList = [];
  int _currentPage = 1;
  MineEntity _userInfo = MineEntity();

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
      _requestInfo(1);
    });
    Future.delayed(Duration.zero, _requestUserInfo);
    super.initState();
  }

  /// 请求用户信息
  void _requestUserInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _userInfo = MineEntity.fromJson(http.data);
        _requestInfo(1);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['memberId'] = _userInfo.id;

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
    _requestInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestInfo(1);
  }

  /// 立即使用
  void _callConsult(ConsultOrderEntity item) async {
    await [Permission.camera, Permission.microphone, Permission.storage]
        .request();
    String channelCode = item.id.toString();
    Map<String, String> params = Map();
    params['title'] = item.memberName;
    params['content'] = '视频通话邀请';
    params['memberId'] = item.doctorMemberId.toString();
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
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 取消订单
  void _cancelAction(int selectedType, ConsultOrderEntity order) async {
    Map<String, dynamic> params = new Map();
    params['status'] = 3;
    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.videoOrderUpdate + order.id.toString(),
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      _currentPage = 1;
      _requestInfo(1);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildItem(ConsultOrderEntity item) {
      return Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                spreadRadius: 1.0,
                offset: Offset(2, 2),
                blurRadius: 10,
                color: Colors.black12,
              )
            ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      '视频面诊',
                      style: TextStyle(fontSize: 15, color: Color(0xFF333333)),
                    )),
                SizedBox(height: 15),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: RichText(
                                text: TextSpan(
                                    text: '咨询师：',
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xFF777777)),
                                    children: [
                              TextSpan(
                                text: item.doctorName,
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF333333)),
                              ),
                            ]))),
                        Expanded(
                            child: RichText(
                                text: TextSpan(
                                    text: '类别：',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF777777),
                                    ),
                                    children: [
                              TextSpan(
                                text: item.productCategoryName,
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF333333)),
                              ),
                            ]))),
                      ],
                    )),
                SizedBox(height: 10),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: RichText(
                        text: TextSpan(
                            text: '下单时间：',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF777777)),
                            children: [
                          TextSpan(
                            text: item.createTime,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF333333)),
                          ),
                        ]))),
                SizedBox(height: 15),
                Container(height: 1, color: Color(0xFFE5E5E5)),
                Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Offstage(
                        offstage: item.status == 2,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            VideoDialog.cancelAlert(
                                context, _cancelAction, item);
                          },
                          child: Container(
                            height: 27,
                            width: 79,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                                border: Border.all(color: Color(0xFFE5E5E5))),
                            child: Text(
                              '取消订单',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF999999)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (item.status == 1) {
                            _callConsult(item);
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => VideoDetailScreen(
                                  item.productCategoryIId,
                                  item.doctorId,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 27,
                          width: 79,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: XCColors.themeColor),
                              borderRadius: BorderRadius.circular(14),
                              color: item.status == 1
                                  ? XCColors.themeColor
                                  : Colors.white),
                          child: Text(
                            item.status == 1 ? '去使用' : '再次咨询',
                            style: TextStyle(
                              fontSize: 13,
                              color: item.status == 1
                                  ? Colors.white
                                  : XCColors.themeColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Image.asset(
              item.status == 1
                  ? 'assets/images/video/video_order_notused.png'
                  : 'assets/images/video/video_order_completed.png',
              width: 45,
              height: 45,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '我的咨询', () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }),
      body: SmartRefresher(
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
                  return _buildItem(_orderList[index]);
                },
              ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
