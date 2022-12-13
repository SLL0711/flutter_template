import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/order.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../empty.dart';
import '../../../navigator.dart';
import '../../../tool.dart';
import '../../../widgets.dart';

/// 开团列表
class OpenGroupListScreen extends StatefulWidget {
  final int productId;
  final DetailComboEntity selectedCombo;
  final List<DoctorItemEntity> doctorList;
  final bool isGrounding;

  OpenGroupListScreen(
    this.productId,
    this.selectedCombo,
    this.doctorList,
    this.isGrounding,
  );

  @override
  State<StatefulWidget> createState() => OpenGroupListScreenState();
}

class OpenGroupListScreenState extends State<OpenGroupListScreen>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List _orderList = [];
  int _currentPage = 1;
  GroupItemEntity _joinGroup = GroupItemEntity();
  Timer? _timer;

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => {_requestInfo(1)});
    super.initState();
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['productId'] = widget.productId;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.openGroupList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      GroupListEntity entity = GroupListEntity.fromJson(http.data);

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
      if (_orderList.length > 0) {
        _countdown();
      }
    } else {
      ToastHud.show(context, http.message!);
      if (type == 1) {
        _refreshController.refreshFailed();
      } else if (type == 2) {
        _refreshController.loadFailed();
      }
    }
  }

  void showSelectDoctor() {
    if (widget.doctorList.isEmpty) {
      ToastHud.show(context, widget.isGrounding ? '暂无操作技师' : '暂无操作咨询师');
      return;
    } else if (widget.doctorList.length == 1) {
      DoctorItemEntity doctor = widget.doctorList[0];
      _handleNextStep(doctor.id);
      return;
    }
    List<String> list = <String>[];
    widget.doctorList.forEach((element) {
      list.add(element.name);
    });
    new Picker(
      height: 200,
      itemExtent: 35,
      adapter: PickerDataAdapter<String>(pickerdata: list),
      changeToFirst: true,
      columnPadding: const EdgeInsets.all(8.0),
      textAlign: TextAlign.left,
      title: Text(widget.isGrounding ? '选择技师' : '选择咨询师'),
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
      confirmTextStyle: TextStyle(fontSize: 16, color: XCColors.mainTextColor),
      textStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
      selectedTextStyle: TextStyle(fontSize: 18, color: XCColors.mainTextColor),
      onConfirm: (picker, value) {
        DoctorItemEntity doctor = widget.doctorList[value[0]];
        _handleNextStep(doctor.id);
      },
    ).showModal(context);
  }

  void _handleNextStep(int doctorId) {
    // 参团
    NavigatorUtil.pushPage(
      context,
      DetailOrderView(
        widget.productId,
        widget.selectedCombo.id,
        doctorId,
        groupType: 1,
        groupTeamId: _joinGroup.id,
      ),
    );
  }

  /// 拼团倒计时
  void _countdown() {
    if (_timer != null) {
      _timer!.cancel();
    }
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      _orderList.forEach((element) {
        if (element.failureTime != '') {
          int expiration =
              DateTime.parse(element.failureTime).millisecondsSinceEpoch;
          int currentTime = DateTime.now().millisecondsSinceEpoch;
          int countdownTime = int.parse(
              ((expiration - currentTime) / 1000).toString().split('.').first);
          if (countdownTime <= 0) {
            _currentPage = 1;
            _requestInfo(1);
          }
          element.countdownTime = Tool.constructTime(countdownTime);
        }
      });
      setState(() {
        _orderList = _orderList;
      });
    });
  }

  void _onLoading() {
    _requestInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestInfo(1);
  }

  /// 参团
  void _joinGroupAction(GroupItemEntity item) {
    _joinGroup = item;
    showSelectDoctor();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildItem(GroupItemEntity item) {
      return Container(
        height: 50,
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.white,
          border: Border.all(
            color: XCColors.themeColor,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: item.memberAvatar == ''
                  ? Image.asset('assets/images/mine/mine_avatar.png')
                  : CommonWidgets.networkImage(item.memberAvatar),
            ),
            SizedBox(width: 5),
            Text(
              item.memberNickName,
              style: TextStyle(
                fontSize: 12,
                color: XCColors.mainTextColor,
              ),
            ),
            Expanded(child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    text: '还差',
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.tabSelectedColor,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.activityNumber - item.memberNum}',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.detailSelectedColor,
                        ),
                      ),
                      TextSpan(
                        text: '人成团',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.tabSelectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    text: '剩余',
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.tabSelectedColor,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.countdownTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.detailSelectedColor,
                        ),
                      ),
                      TextSpan(
                        text: '结束',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.tabSelectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Container(
              width: 85,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: XCColors.themeColor,
              ),
              child: Text(
                '去参团 >',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '团购', () {
        Navigator.of(context).pop();
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
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => {_joinGroupAction(_orderList[index])},
                    child: _buildItem(_orderList[index]),
                  );
                },
              ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
