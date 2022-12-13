import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'dart:convert' as convert;

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategorySearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CategorySearchScreenState();
}

class CategorySearchScreenState extends State<CategorySearchScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  bool _isClear = true; // 是否隐藏清除按钮
  int _type = 0;

  List<ProductItemEntity> _results = <ProductItemEntity>[];

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

  void requestInfo(String value) async {
    Map<String, String> params = Map();
    params['productName'] = value;
    params['pageNum'] = '1';
    params['pageSize'] = '50';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.productList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ProductEntity entity = ProductEntity.fromJson(http.data);
      _results.clear();
      setState(() {
        _results.addAll(entity.list);
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
      return StaggeredGridView.countBuilder(
          shrinkWrap: true,
          padding:
              const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
          crossAxisCount: 4,
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtil.pushPage(
                    context, DetailScreen(_results[index].id),
                    needLogin: false);
              },
              child: HomeWidgets.homeGoodsTile(context, _results[index])),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0);
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
          requestInfo(value);
        }, _isClear, isGoodsSearch: true),
        body: _type == 0
            ? Container()
            : (_results.isEmpty
                ? EmptyWidgets.dataEmptyView(context)
                : _resultsListView()));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
