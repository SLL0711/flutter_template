import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/category/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/video/video_list.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<TabEntity> _tabItems = <TabEntity>[];
  int _initIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _init);
  }

  void _init() async {
    requestTabInfo();
  }

  void requestTabInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.tab, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          _tabItems.add(TabEntity.fromJson(element));
        });
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
      appBar: CategoryWidgets.categoryAppBar(context, '咨询'),
      body: _tabItems.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : DefaultTabController(
              initialIndex: _initIndex,
              length: _tabItems.length,
              child: Column(
                children: [
                  Container(
                      color: Colors.white,
                      child: Container(
                        height: 27,
                        margin: const EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft, //右上
                            end: Alignment.centerRight, //左下
                            stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                            //渐变颜色[始点颜色, 结束颜色]
                            colors: [Color(0xFFF996B7), Color(0xFFB1E3FB)],
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 13,
                              height: 12,
                              child: Image.asset(
                                  'assets/images/video/video_ancrown.png',
                                  fit: BoxFit.fill),
                            ),
                            SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                '雀斑会员，足不出户免费1v1咨询',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    width: double.infinity,
                    height: 40,
                    color: Colors.white,
                    child: TabBar(
                      isScrollable: true,
                      labelColor: Colors.black87,
                      unselectedLabelColor: Color(0xFF777777),
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: TextStyle(fontSize: 12),
                      indicatorColor: Color(0xFFF191B6),
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List<Widget>.generate(
                        _tabItems.length,
                        (index) {
                          String title = _tabItems[index].name;
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
                          return VideoListView(_tabItems[index].id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
