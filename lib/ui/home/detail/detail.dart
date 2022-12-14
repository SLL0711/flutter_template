import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/box/box.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/doctor.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/order.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/comment.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/diary.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/rule.dart';
import 'package:flutter_medical_beauty/ui/home/detail/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/group/open_group_list.dart';
import 'package:flutter_medical_beauty/ui/login/article.dart';
import 'package:flutter_medical_beauty/ui/mine/bean/rule.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/user.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../../../colors.dart';
import '../../../empty.dart';
import 'Installment.dart';
import 'dialog.dart';
import 'hospital/hospital.dart';
import 'insurance.dart';
import 'tabbar_view/info.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final bool isBean;
  final bool isBeanGoods; // true 兑换实物

  DetailScreen(this.id, {this.isBean = false, this.isBeanGoods = false});

  @override
  State<StatefulWidget> createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  /// 变量
  late TabController _tabController = TabController(length: 5, vsync: this);
  PageController _pageController = PageController();
  List<String> _tabItems = ['详情', '须知', '评价', '日记'];
  int _cartNumber = 0;
  String _comboResult = '';
  ProductDetailEntity _detailEntity = ProductDetailEntity();
  List<DetailComboEntity> _comboEntityList = <DetailComboEntity>[];
  DetailComboEntity _selectedCombo = DetailComboEntity();
  List<DoctorItemEntity> _doctorList = <DoctorItemEntity>[];
  List<GroupItemEntity> _groupList = <GroupItemEntity>[];
  GroupItemEntity _joinGroup = GroupItemEntity();
  bool _isGrounding = false;
  Timer? _timer;

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabItems =
        widget.isBeanGoods ? ['详情', '须知', '评价'] : ['详情', '须知', '评价', '日记'];
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    requestDetailInfo();
    requestDetailSkuInfo();
    requestDoctor();
    _isGrounding = await Tool.isGrounding();
    bool isLogin = await UserManager.isLogin();
    if (isLogin) {
      requestCartInfo();
    }
  }

  void requestDetailInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.productDetail + widget.id.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _detailEntity = ProductDetailEntity.fromJson(http.data);
        _tabController = TabController(
          length: _detailEntity.product.albumPicsList.length,
          vsync: this,
        );
        // 初始页面 指定
        _pageController = PageController(initialPage: 0);
      });
      if (_detailEntity.isGroupProduct == 1) {
        requestGroupList();
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 拼团列表
  void requestGroupList() async {
    Map<String, dynamic> params = new Map();
    params['pageNum'] = 1;
    params['pageSize'] = 3;
    params['productId'] = widget.id;
    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.openGroupList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        GroupListEntity groupList = GroupListEntity.fromJson(http.data);
        _groupList = groupList.list;
        if (_groupList.length > 0) {
          _countdown();
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 拼团倒计时
  void _countdown() {
    if (_timer != null) {
      _timer!.cancel();
    }
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      _groupList.forEach((element) {
        if (element.failureTime != '') {
          int expiration =
              DateTime.parse(element.failureTime).millisecondsSinceEpoch;
          int currentTime = DateTime.now().millisecondsSinceEpoch;
          int countdownTime = int.parse(
              ((expiration - currentTime) / 1000).toString().split('.').first);
          if (countdownTime <= 0) {
            requestGroupList();
          }
          element.countdownTime = Tool.constructTime(countdownTime);
        }
      });
      setState(() {
        _groupList = _groupList;
      });
    });
  }

  /// 请求咨询师
  void requestDoctor() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = 1;
    params['pageSize'] = 100;
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.doctorProduct + widget.id.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      _doctorList = DoctorEntity.fromJson(http.data).list;
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 请求购物车数据
  void requestCartInfo() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '1';
    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.shoppingCart, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _cartNumber = http.data['total'] ?? 0;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 请求规格信息
  void requestDetailSkuInfo() async {
    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.productSku + widget.id.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((v) {
          _comboEntityList.add(DetailComboEntity.fromJson(v));
        });
        if (_comboEntityList.isNotEmpty) {
          DetailComboEntity entity = _comboEntityList.first;
          entity.isSelected = true;
          entity.isRealSelected = true;
          _selectedCombo = entity;
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _bottomToolAction(int index) async {
    if (index == 1) {
      //咨询
      EMConversation? conv =
          await EMClient.getInstance.chatManager.getConversation('13500000000');
      if (conv == null) {
        print('会话创建失败');
        return;
      }
      conv.type = EMConversationType.Chat;
      Navigator.of(context).pushNamed(
        '/chat',
        arguments: [conv.name, conv],
      ).then((value) {
        // eventBus.fire(EventBusManager.updateConversations());
      });
    } else if (index == 2) {
      //跳转购物车
      NavigatorUtil.pushPage(context, BoxScreen());
      // EventCenter.defaultCenter().fire(PushTabEvent(3));
      // Navigator.pop(context);
    } else if (index == 3) {
      //加入购物车
      if (_selectedCombo.id == 0) {
        ToastHud.show(context, '暂无相关套餐可供选择');
      } else {
        showSelectDoctor(1);
      }
    } else if (index == 4) {
      //立即购买
      if (_selectedCombo.id == 0) {
        ToastHud.show(context, '暂无相关套餐可供选择');
      } else {
        showSelectDoctor(0);
      }
    }
  }

  void _beanBottomToolAction(int index) {
    if (index == 1) {
      EventCenter.defaultCenter().fire(PushTabEvent(0));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (index == 2) {
    } else if (index == 3) {}
  }

  void _addCart(int doctorId) async {
    bool isLogin = await UserManager.isLogin();
    if (!isLogin) return ToastHud.show(context, '未登录');

    Map<String, dynamic> params = Map();
    params['productId'] = _detailEntity.product.id;
    params['productSkuId'] = _selectedCombo.id;
    params['doctorId'] = doctorId;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.shoppingCart, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '购物车添加成功');
      setState(() {
        _cartNumber++;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _collectAction() async {
    bool isLogin = await UserManager.isLogin();
    if (!isLogin) return ToastHud.show(context, '未登录');

    Map<String, dynamic> params = Map();
    params['objectId'] = _detailEntity.product.id;
    params['objectType'] = 0;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.collect, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
      setState(() {
        _detailEntity.isCollect = _detailEntity.isCollect == 1 ? 0 : 1;
      });
      EventCenter.defaultCenter().fire(RefreshCollectionEvent(0));
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _shareAction() async {
    bool _isLogin = await UserManager.isLogin();
    if (!_isLogin) {
      return ToastHud.show(context, '未登录');
    }

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      MineEntity entity = MineEntity.fromJson(http.data);
      DetailDialog.showShareDialog(context, (String type) {
        if (int.parse(type) == 1) {
          var model = fluwx.WeChatShareWebPageModel(
              DsApi.share_url + '?inviteCode=${entity.inviteCode ?? ''}',
              title: '雀斑-${_detailEntity.product.name}',
              description: '邀请你加入雀斑会员，带你一起变美一起赚钱！',
              thumbnail: fluwx.WeChatImage.network(
                  _detailEntity.product.pic.split(',').first),
              scene: fluwx.WeChatScene.SESSION);
          fluwx.shareToWeChat(model).then((value) {
            ToastHud.show(context, '分享成功');
          });
        } else if (int.parse(type) == 2) {
          var model = fluwx.WeChatShareWebPageModel(
              DsApi.share_url + '?inviteCode=${entity.inviteCode ?? ''}',
              title: '雀斑-${_detailEntity.product.name}',
              description: '邀请你加入雀斑会员，带你一起变美一起赚钱！',
              thumbnail: fluwx.WeChatImage.network(
                  _detailEntity.product.pic.split(',').first),
              scene: fluwx.WeChatScene.TIMELINE);
          fluwx.shareToWeChat(model).then((value) {
            ToastHud.show(context, '分享成功');
          });
        } else if (int.parse(type) == 3) {
          Clipboard.setData(ClipboardData(
              text:
                  DsApi.share_url + '?inviteCode=${entity.inviteCode ?? ''}'));
          ToastHud.show(context, '复制成功');
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void showSelectDoctor(int type) {
    if (_doctorList.isEmpty) {
      ToastHud.show(context, _isGrounding ? '暂无操作技师' : '暂无操作咨询师');
      return;
    } else if (_doctorList.length == 1) {
      DoctorItemEntity doctor = _doctorList[0];
      _handleNextStep(type, doctor.id);
      return;
    }
    List<String> list = <String>[];
    _doctorList.forEach((element) {
      list.add(element.name);
    });
    new Picker(
      height: 200,
      itemExtent: 35,
      adapter: PickerDataAdapter<String>(pickerdata: list),
      changeToFirst: true,
      columnPadding: const EdgeInsets.all(8.0),
      textAlign: TextAlign.left,
      title: Text(_isGrounding ? '选择技师' : '选择咨询师'),
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
      confirmTextStyle: TextStyle(fontSize: 16, color: XCColors.mainTextColor),
      textStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
      selectedTextStyle: TextStyle(fontSize: 18, color: XCColors.mainTextColor),
      onConfirm: (picker, value) {
        DoctorItemEntity doctor = _doctorList[value[0]];
        _handleNextStep(type, doctor.id);
      },
    ).showModal(context);
  }

  void _handleNextStep(int type, int doctorId) {
    if (type == 3) {
      // 参团
      NavigatorUtil.pushPage(
        context,
        DetailOrderView(
          widget.id,
          _selectedCombo.id,
          doctorId,
          groupType: 1,
          groupTeamId: _joinGroup.id,
        ),
      );
    } else if (type == 1) {
      if (_detailEntity.isGroupProduct == 1) {
        // 团购的单独购买
        NavigatorUtil.pushPage(
          context,
          DetailOrderView(
            widget.id,
            _selectedCombo.id,
            doctorId,
          ),
        );
      } else {
        _addCart(doctorId);
      }
    } else {
      if (_detailEntity.isGroupProduct == 1) {
        // 团购的立即开团
        NavigatorUtil.pushPage(
          context,
          DetailOrderView(
            widget.id,
            _selectedCombo.id,
            doctorId,
            groupType: 0,
          ),
        );
      } else {
        NavigatorUtil.pushPage(
          context,
          DetailOrderView(
            widget.id,
            _selectedCombo.id,
            doctorId,
          ),
        );
      }
    }
  }

  void _tapHeaderAction(int index) {
    if (index == 1) {
      // 套餐
      if (_comboEntityList.isEmpty) return;
      DetailDialog.showComboDialog(context, _comboEntityList, _selectedCombo,
          (result) {
        setState(() {
          _comboEntityList.forEach((element) {
            if (element.isRealSelected) {
              _selectedCombo = element;
            }
          });
          _comboResult = result;
        });
      });
    } else if (index == 2) {
      // 分期
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InstallmentScreen(),
        ),
      );
    } else if (index == 3) {
      // 咨询师
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DoctorScreen(_detailEntity.product.id)));
    } else if (index == 4) {
      // 商家
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HospitalScreen(_detailEntity.product.orgId)));
    } else if (index == 5) {
      // 正品
      if (_isGrounding) {
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ArticleScreen('7t8vxsm6u') /*OriginalScreen()*/
          ));
    } else if (index == 6) {
      // 会员
      if (_isGrounding) {
        return;
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ArticleScreen('d44k1iap3') /*MemberScreen()*/
          ));
    } else if (index == 7) {
      // 分享
      if (_isGrounding) {
        return;
      }
      // DetailDialog.showShareDialog(context);
    } else if (index == 8) {
      // 颜值保
      if (_isGrounding) {
        return;
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => InsuranceScreen()));
    } else if (index == 9) {
      NavigatorUtil.pushPage(context, BeanRuleScreen());
    }
  }

  void _joinGroupAction(GroupItemEntity item) {
    _joinGroup = item;
    showSelectDoctor(3);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildTabController() {
      return DefaultTabController(
        length: _tabItems.length,
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
              height: 50,
              child: TabBar(
                isScrollable: false,
                labelColor: XCColors.bannerSelectedColor,
                unselectedLabelColor: XCColors.tabNormalColor,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 16),
                indicatorColor: XCColors.detailSelectedColor,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: List<Widget>.generate(
                  _tabItems.length,
                  (index) {
                    String title = _tabItems[index];
                    return Tab(text: title);
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: List<Widget>.generate(
                  _tabItems.length,
                  (index) {
                    if (index == 0) {
                      return DetailInfoView(widget.id);
                    } else if (index == 1) {
                      return DetailRuleView();
                    } else if (index == 2) {
                      return DetailCommentView(widget.id);
                    } else {
                      return DetailDiaryView(widget.id);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildDetailHeaderWidget() {
      return Column(
        children: [
          DetailWidgets.detailHeaderWidget(
            context,
            _pageController,
            _tabController,
            _detailEntity,
            (index) {
              _tabController.animateTo(index);
            },
            _tapHeaderAction,
            _comboResult,
            _isGrounding,
            widget.isBean,
            widget.isBeanGoods,
          ),
          widget.isBeanGoods
              ? Container()
              : _detailEntity.productProjectPrices.isEmpty
                  ? Container()
                  : Container(height: 10, color: XCColors.homeDividerColor),
          widget.isBeanGoods
              ? Container()
              : _detailEntity.isGroupProduct == 1
                  ? DetailWidgets.groupListWidget(
                      context,
                      _groupList,
                      _isGrounding,
                      () => {
                        NavigatorUtil.pushPage(
                          context,
                          OpenGroupListScreen(
                            widget.id,
                            _selectedCombo,
                            _doctorList,
                            _isGrounding,
                          ),
                        ),
                      },
                      _joinGroupAction,
                    )
                  : Container(),
          widget.isBeanGoods
              ? Container()
              : _detailEntity.productProjectPrices.isEmpty
                  ? Container()
                  : Container(height: 10, color: XCColors.homeDividerColor),
          widget.isBeanGoods
              ? Container()
              : _detailEntity.productProjectPrices.isEmpty
                  ? Container()
                  : DetailWidgets.detailPriceWidget(
                      context,
                      _detailEntity,
                      _isGrounding,
                    ),
          widget.isBeanGoods
              ? Container()
              : _detailEntity.productAttributeVO.isEmpty
                  ? Container()
                  : Container(height: 10, color: XCColors.homeDividerColor),
          widget.isBeanGoods
              ? Container()
              : _detailEntity.productAttributeVO.isEmpty
                  ? Container()
                  : DetailWidgets.detailOtherPriceWidget(
                      context, _detailEntity),
          Container(height: 10, color: XCColors.homeDividerColor)
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          DetailWidgets.detailAppBar(context, _detailEntity.isCollect == 1, () {
        Navigator.pop(context);
      }, _collectAction, _shareAction),
      body: _detailEntity.product.name.isEmpty
          ? Container(
              height: double.infinity,
              child: EmptyWidgets.dataEmptyView(context),
            )
          : Stack(
              children: [
                NestedScrollView(
                  body: _buildTabController(),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [_buildDetailHeaderWidget()],
                        ),
                      ),
                    ];
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: widget.isBean
                      ? DetailWidgets.detailBeanCart(
                          context, _beanBottomToolAction)
                      : DetailWidgets.detailCart(
                          context,
                          _cartNumber,
                          _selectedCombo,
                          _detailEntity,
                          () {
                            DetailDialog.showGoldTip(context);
                          },
                          _bottomToolAction,
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
