import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/address/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/address/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/address/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'create.dart';
import 'edit.dart';

class AddressScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<AddressEntity> _itemList = <AddressEntity>[];

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestAddressInfo();
    });
  }

  void _requestAddressInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.addressList, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (http.data != null) {
        setState(() {
          _itemList.clear();
          http.data.forEach((element) {
            _itemList.add(AddressEntity.fromJson(element));
          });
        });
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _setDefaultAction(AddressEntity entity) async {
    Map<String, dynamic> params = Map();
    params['defaultStatus'] = 1;

    ToastHud.loading(context);
    var http = await HttpManager.post(
        DsApi.addressChange + entity.id.toString(), params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '设置成功');
      _requestAddressInfo();
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _deleteAction(AddressEntity entity) async {
    ToastHud.loading(context);
    var http = await HttpManager.post(
        DsApi.addressDelete + entity.id.toString(), Map(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '删除成功');
      _requestAddressInfo();
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '收货地址', () {
        Navigator.pop(context);
      }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: _requestAddressInfo,
              header: MaterialClassicHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  return HomeWidgets.homeRefresherFooter(context, mode);
                },
              ),
              child: _itemList.isEmpty
                  ? EmptyWidgets.dataEmptyView(context)
                  : ListView.builder(
                      itemCount: _itemList.length,
                      itemBuilder: (context, index) {
                        return AddressWidgets.addressItem(
                          context,
                          _itemList[index],
                          deleteTap: () {
                            AddressDialog.showDeleteTip(context, '确定删除此地址？',
                                () {
                              _deleteAction(_itemList[index]);
                            });
                          },
                          defaultTap: () {
                            AddressDialog.showDeleteTip(context, '确定设为默认地址？',
                                () {
                              _setDefaultAction(_itemList[index]);
                            });
                          },
                          editTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditAddressScreen(_itemList[index])));
                          },
                        );
                      },
                    ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAddressScreen()))
                  .then((value) {
                if (value == 1) {
                  _requestAddressInfo();
                }
              });
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              color: XCColors.themeColor,
              child: Text(
                '新增地址',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
