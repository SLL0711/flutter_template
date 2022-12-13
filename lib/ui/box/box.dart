import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/box/entity.dart';
import 'package:flutter_medical_beauty/ui/box/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/login/login.dart';

import '../../../colors.dart';
import '../../api.dart';
import '../../event_center.dart';
import '../../http.dart';
import '../../toast.dart';
import '../../user.dart';
import 'manager.dart';

class BoxScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BoxScreenState();
}

class BoxScreenState extends State<BoxScreen>
    with AutomaticKeepAliveClientMixin {
  // 变量
  ScrollController _scrollController = ScrollController();
  var _userStatusEvent, _shoppingCartEvent, _logoutEvent;

  // 购物车
  List<ShoppingCartItemEntity> _shoppingCartList = <ShoppingCartItemEntity>[];

  // 猜你喜欢
  List<ProductItemEntity> _productList = <ProductItemEntity>[];

  @override
  void initState() {
    _userStatusEvent =
        EventCenter.defaultCenter().on<RefreshMineEvent>().listen((event) {
      _requestData();
    });
    _shoppingCartEvent = EventCenter.defaultCenter()
        .on<RefreshShoppingCartEvent>()
        .listen((event) {
      _requestData();
    });
    _logoutEvent =
        EventCenter.defaultCenter().on<LogoutEvent>().listen((event) {
      setState(() {
        _shoppingCartList = <ShoppingCartItemEntity>[];
      });
    });
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    bool isLogin = await UserManager.isLogin();
    if (isLogin) {
      // 请求
      _requestData();
    }
    _requestGuess();
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
      _shoppingCartList.clear();
      setState(() {
        _shoppingCartList = ShoppingCartEntity.fromJson(http.data).list;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestGuess() async {
    ToastHud.loading(context);
    Map<String, dynamic> params = Map();
    params['pageNum'] = 1;
    params['pageSize'] = 100;
    params['provinceCode'] = await Tool.getString('provinceCode');
    params['cityCode'] = await Tool.getString('cityCode');
    params['latitude'] = await Tool.getString('latitude');
    params['longitude'] = await Tool.getString('longitude');
    var http =
        await HttpManager.get(DsApi.guessYouLike, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _productList = ProductEntity.fromJson(http.data).list;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _userStatusEvent.cancel();
    _shoppingCartEvent.cancel();
    _logoutEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: BoxWidgets.boxAppbar(context, '购物车', () {
        NavigatorUtil.pushPage(context, BoxManagerScreen());
      }),
      body: NestedScrollView(
        controller: _scrollController,
        body: BoxWidgets.boxBodyWidget(context, _productList),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _shoppingCartList.length == 0
                      ? BoxWidgets.boxBodyEmptyHeaderWidget(context)
                      : SizedBox(),
                  BoxWidgets.boxBodyHeaderListWidget(
                      context, _shoppingCartList),
                  BoxWidgets.boxBodyTipWidget(context)
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
