import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/message/entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../api.dart';
import '../../../../colors.dart';
import '../../../../http.dart';
import '../../../../toast.dart';
import '../../widgets.dart';
import '../message_detail.dart';
import '../widgets.dart';

class NoticeTabBarView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NoticeTabBarViewState();
}

class NoticeTabBarViewState extends State<NoticeTabBarView>
    with AutomaticKeepAliveClientMixin {
  // 参数
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<NoticeEntity> _list = <NoticeEntity>[];
  int _page = 1;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _init() async {
    ToastHud.loading(context);
    Map<String, dynamic> params = Map();
    params['pageNum'] = _page;
    params['pageSize'] = 20;
    var http = await HttpManager.get(DsApi.noticeList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        NoticeListEntity data = NoticeListEntity.fromJson(http.data);
        if (_page == 1) {
          _list = data.list;
          _refreshController.refreshCompleted();
        } else {
          _list.addAll(data.list);
          _refreshController.loadComplete();
        }
        if (_list.length < data.total) {
          _page++;
        } else {
          _refreshController.loadNoData();
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(height: 10, color: XCColors.homeDividerColor),
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _init,
              onLoading: _init,
              header: MaterialClassicHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  return HomeWidgets.homeRefresherFooter(context, mode);
                },
              ),
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      /// 跳转消息详情
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MessageDetailScreen(_list[index]),
                        ),
                      );
                    },
                    child: MessageWidgets.noticeItem(context, _list[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
