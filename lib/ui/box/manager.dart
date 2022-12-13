import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/ui/box/dialog.dart';
import 'package:flutter_medical_beauty/ui/box/widgets.dart';

import '../../../colors.dart';
import '../../api.dart';
import '../../http.dart';
import '../../toast.dart';
import 'entity.dart';

class BoxManagerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BoxManagerScreenState();
}

class BoxManagerScreenState extends State<BoxManagerScreen>
    with AutomaticKeepAliveClientMixin {
  // 购物车
  List<ShoppingCartItemEntity> _shoppingCartList = <ShoppingCartItemEntity>[];

  // 全选
  bool _allSelected = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _requestData();
    });
  }

  /// 请求数据
  void _requestData() async {
    ToastHud.loading(context);
    Map<String, dynamic> params = Map();
    params['pageNum'] = 1;
    params['pageSize'] = 100;
    var http =
        await HttpManager.get(DsApi.shoppingCart, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _shoppingCartList = ShoppingCartEntity.fromJson(http.data).list;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: BoxWidgets.boxManagerAppbar(context, '购物车', () {
        Navigator.pop(context, '1');
      }),
      body: Column(
        children: [
          Expanded(
              child: BoxWidgets.boxManagerListWidget(
                  context, _shoppingCartList, _tapItemSelect)),
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _tapAllSelect,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Container(
                        width: 16,
                        height: 16,
                        child: Image.asset(
                            _allSelected
                                ? 'assets/images/box/box_check_selected.png'
                                : 'assets/images/box/box_check_normal.png',
                            fit: BoxFit.cover),
                      ),
                      SizedBox(width: 10),
                      Text('全选',
                          style: TextStyle(
                              color: XCColors.mainTextColor, fontSize: 12)),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleDelete,
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    color: XCColors.themeColor,
                    child: Text(
                      '删除',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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

  //点击选择
  void _tapItemSelect(int index) {
    setState(() {
      ShoppingCartItemEntity item = _shoppingCartList[index];
      item.isSelected = !item.isSelected;
      bool _isAll = true;
      _shoppingCartList.forEach((item) {
        if (!item.isSelected) {
          _isAll = false;
          return;
        }
      });
      _allSelected = _isAll;
    });
  }

  // 点击全选
  void _tapAllSelect() {
    setState(() {
      _allSelected = !_allSelected;
      _shoppingCartList.forEach((item) {
        item.isSelected = _allSelected;
      });
    });
  }

  // 删除
  void _handleDelete() async {
    List<int> idList = <int>[];
    _shoppingCartList.forEach((item) {
      if (item.isSelected) {
        idList.add(item.id);
      }
    });
    if (idList.isEmpty) {
      ToastHud.show(context, '请选择要删除项');
    } else {
      String? ids = await BoxDialog.showDeleteDialog(context, idList);
      if (ids != null && ids.isNotEmpty) {
        _requestDelete(ids);
      }
    }
  }

  // 请求删除处理
  void _requestDelete(String ids) async {
    ToastHud.loading(context);
    var http =
        await HttpManager.delete(DsApi.shoppingCart + '/' + ids, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      _requestData();
      EventCenter.defaultCenter().fire(RefreshShoppingCartEvent('删除购物车'));
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
