import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/category/search.dart';
import 'package:flutter_medical_beauty/ui/category/tabbar_view/category.dart';
import 'package:flutter_medical_beauty/ui/category/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';

import '../../colors.dart';

class CategoryScreen extends StatefulWidget {
  final int id;

  CategoryScreen({this.id = 0});

  @override
  State<StatefulWidget> createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  // 左侧一级分类
  List<TabEntity> _tabItems = <TabEntity>[];

  // 右侧二级分类
  List<TabEntity> _children = <TabEntity>[];

  // 选择一级分类ID
  int _type = 0;

  @override
  void initState() {
    _type = widget.id;
    Future.delayed(Duration.zero, init);
    super.initState();
  }

  void init() {
    requestTabInfo();
  }

  void requestTabInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.tab, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          TabEntity entity = TabEntity.fromJson(element);
          _tabItems.add(entity);
        });
        //默认选中值处理
        if (_tabItems.isNotEmpty) {
          bool needInit = true;
          if (_type != 0) {
            for (int i = 0; i < _tabItems.length; i++) {
              TabEntity item = _tabItems[i];
              if (item.id == _type) {
                item.isSelected = true;
                _children = item.children;
                needInit = false;
                break;
              }
            }
          }
          if (needInit) {
            TabEntity entity = _tabItems.first;
            entity.isSelected = true;
            _children = entity.children;
            _type = entity.id;
          }
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _tapItemAction(int index) {
    setState(() {
      _tabItems.forEach((element) {
        element.isSelected = false;
      });
      TabEntity entity = _tabItems[index];
      entity.isSelected = true;
      _children = entity.children;
      int i = 0;
      int childrenId = 0;
      entity.children.forEach((element) {
        element.isSelected = i == 0;
        if (i == 0) childrenId = element.id;
        i++;
      });
      if (i == 0) childrenId = entity.id;
      _type = entity.id;

      EventCenter.defaultCenter().fire(RefreshCategoryEvent(childrenId));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CategoryWidgets.categoryAppBar(context, '分类'),
      body: Column(
        children: [
          Container(height: 1, color: XCColors.messageChatDividerColor),
          CategoryWidgets.categorySearchBox(context, () {
            NavigatorUtil.pushPage(
              context,
              CategorySearchScreen(),
              needLogin: false,
            );
          }),
          Expanded(
            child: _tabItems.isEmpty
                ? Container()
                : Row(
                    children: [
                      CategoryWidgets.categoryLeftListView(
                        context,
                        _tabItems,
                        _tapItemAction,
                      ),
                      Expanded(
                        child: CategoryTabBarView(_children, _type),
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
