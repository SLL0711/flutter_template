import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'entity.dart';

abstract class HomeWidgets {
  /// ========= homeAppbar =========
  static homeAppBar(BuildContext context, String location,
      final VoidCallback locationTap, final VoidCallback messageTap) {
    /// 定位地址
    Widget _locationWidget(
        BuildContext context, String location, final VoidCallback locationTap) {
      return Expanded(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.asset(
                "assets/images/home/home_address.png",
                width: 11,
                height: 14,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: locationTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 18, color: XCColors.mainTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// 头部视图
    Widget _titleWidget(BuildContext context, String location,
        final VoidCallback locationTap, final VoidCallback messageTap) {
      return Row(
        children: [
          _locationWidget(context, location, locationTap),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: messageTap,
            child: Stack(
              children: [
                Container(
                  height: kToolbarHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                    "assets/images/home/home_message.png",
                    width: 18,
                    height: 22,
                  ),
                ),
                Positioned(
                    top: 12,
                    right: 3,
                    child: Offstage(
                      offstage: false,
                      child: Container(
                        width: 0,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: XCColors.bannerSelectedColor,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      );
    }

    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: _titleWidget(context, location, locationTap, messageTap),
    );
  }

  /// ===== 刷新的底部 ======
  static homeRefresherFooter(BuildContext context, LoadStatus? mode) {
    Widget _body() {
      if (mode == LoadStatus.idle) {
        return Center(
            child: Text("上拉加载",
                style: TextStyle(
                    fontSize: 11, color: XCColors.goodsOtherGrayColor)));
      } else if (mode == LoadStatus.loading) {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CupertinoActivityIndicator(),
          SizedBox(width: 20),
          Text("加载中...",
              style:
                  TextStyle(fontSize: 11, color: XCColors.goodsOtherGrayColor))
        ]);
      } else if (mode == LoadStatus.failed) {
        return Text("加载失败！点击重试！",
            style:
                TextStyle(fontSize: 11, color: XCColors.goodsOtherGrayColor));
      } else if (mode == LoadStatus.canLoading) {
        return Center(
            child: Text("放开加载更多数据",
                style: TextStyle(
                    fontSize: 11, color: XCColors.goodsOtherGrayColor)));
      } else {
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 50, height: 1, color: XCColors.homeFooterDividerColor),
          SizedBox(width: 5),
          Text("人家也是有底线的哦",
              style:
                  TextStyle(fontSize: 11, color: XCColors.goodsOtherGrayColor)),
          SizedBox(width: 5),
          Container(
              width: 50, height: 1, color: XCColors.homeFooterDividerColor)
        ]);
      }
    }

    return Container(
      height: 50,
      child: _body(),
    );
  }

  /// ========= homeHeader =========
  static homeHeader(BuildContext context, List<BannerEntity> bannerList,
      BannerEntity adEntity, final VoidCallback onTap) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 165,
            child: bannerList.isEmpty
                ? Container()
                : BannerView(
                    children: bannerList.map((e) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Tool.openUrl(context, e.url);
                        },
                        child: CommonWidgets.networkImage(e.pic),
                      );
                    }).toList(),
                  ),
          ),
          Offstage(
            offstage: adEntity.pic.isEmpty,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Tool.openUrl(context, adEntity.url);
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: adEntity.pic.isEmpty
                    ? Container()
                    : CommonWidgets.networkImage(adEntity.pic),
              ),
            ),
          ),
          Container(height: 10, color: XCColors.homeDividerColor),
        ],
      ),
    );
  }

  /// ========= 商品Tile =========
  static homeGoodsTile(BuildContext context, ProductItemEntity itemEntity) {
    /// 标签视图
    Widget _flagItem(String image, String title) {
      return Container(
        width: 16,
        height: 18,
        child: Stack(
          children: [
            Image.asset(image, width: 16, height: 18),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        children: [
          Container(
              height: 164, child: CommonWidgets.networkImage(itemEntity.pic)),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 5, top: 8, right: 5, bottom: 5),
            child: Text(
              itemEntity.name,
              style: TextStyle(color: XCColors.mainTextColor, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Offstage(
            offstage: itemEntity.isEnableFee != 1,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: Row(
                children: [
                  // _flagItem('assets/images/home/home_goods_flag_blue.png', '抢'),
                  // SizedBox(width: 10),
                  _flagItem(
                      'assets/images/home/home_goods_flag_orange.png', '惠')
                ],
              ),
            ),
          ),
          Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¥${itemEntity.price}',
                  style: TextStyle(
                    fontSize: 18,
                    color: XCColors.themeColor,
                  ),
                ),
                Offstage(
                  offstage: itemEntity.isEnableFee != 1,
                  child: Container(
                    height: 20,
                    width: 65,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: XCColors.themeColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      '免费体验',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${itemEntity.reserveNum}人已预约',
                    style:
                        TextStyle(fontSize: 11, color: XCColors.goodsGrayColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // SizedBox(width: 5),
                // RichText(
                //     text: TextSpan(
                //         text: '今日限量',
                //         style: TextStyle(
                //             fontSize: 11, color: XCColors.goodsGrayColor),
                //         children: [
                //       TextSpan(
                //           text: '10',
                //           style: TextStyle(
                //               fontSize: 11,
                //               color: XCColors.bannerSelectedColor)),
                //       TextSpan(
                //           text: '件',
                //           style: TextStyle(
                //               fontSize: 11, color: XCColors.goodsGrayColor))
                //     ])),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    itemEntity.orgName,
                    style: TextStyle(
                        fontSize: 10, color: XCColors.goodsOtherGrayColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                    itemEntity.distance.isEmpty
                        ? ''
                        : '${Tool.formatNum(double.parse(itemEntity.distance), 0)}km',
                    style: TextStyle(
                        fontSize: 10, color: XCColors.goodsOtherGrayColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ========= banner =========
class BannerView extends StatefulWidget {
  final List<Widget> children;
  final Duration switchDuration;

  BannerView(
      {this.children = const <Widget>[],
      this.switchDuration = const Duration(seconds: 5)});

  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late int _currentPageIndex;
  static const Duration animateDuration = const Duration(milliseconds: 500);
  Timer? _timer;
  List<Widget> children = []; // 内部加两个页面 +B(A,B)+A

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
    _tabController = TabController(length: widget.children.length, vsync: this);

    children.addAll(widget.children);

    /// 定时器完成自动翻页
    if (widget.children.length > 1) {
      children.insert(0, widget.children.last);
      children.add(widget.children.first);

      /// 如果大于一页，则会在前后都加上一页，初始页要是 1
      _currentPageIndex = 1;
      _timer = Timer.periodic(widget.switchDuration, _nextBanner);
    }

    /// 初始页面 指定
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  void _nextBanner(Timer timer) {
    _currentPageIndex++;
    _currentPageIndex =
        _currentPageIndex == children.length ? 0 : _currentPageIndex;
    _pageController.animateToPage(_currentPageIndex,
        duration: animateDuration, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: XCColors.bannerShadowColor, blurRadius: 7)
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: XCColors.bannerHintColor),
          child: Listener(
            onPointerDown: (_) {
              _timer!.cancel();
            },
            onPointerUp: (_) {
              if (widget.children.length > 1) {
                _timer = Timer.periodic(widget.switchDuration, _nextBanner);
              }
            },
            child: NotificationListener(
              // ignore: missing_return
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  // 是一个完整页面的偏移
                  if (notification.metrics.atEdge) {
                    if (_currentPageIndex == children.length - 1) {
                      /// 如果是最后一页，让pageView jump到第1页
                      _pageController.jumpToPage(1);
                    } else if (_currentPageIndex == 0) {
                      /// 第1页回滑，滑到第0页，第0页的内容是倒数第二页，是所有真实页面的最后一页的内容
                      /// 指示器 到 tab的最后一个
                      _pageController.jumpToPage(children.length - 2);
                    }
                  }
                }
                return true;
              },
              child: PageView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: children[index],
                  );
                },
                controller: _pageController,

                /// 要到新页面的时候 把新页面的index给我们
                onPageChanged: (index) {
                  // 需要更新下下标
                  _currentPageIndex = index;
                  if (index == children.length - 1) {
                    /// 如果是最后一页，让pageView jump到第1页
                    // _pageController.jumpToPage(1);
                    _tabController.animateTo(0);
                  } else if (index == 0) {
                    /// 第1页回滑，滑到第0页，第0页的内容是倒数第二页，是所有真实页面的最后一页的内容
                    /// 指示器 到 tab的最后一个
                    _tabController.animateTo(_tabController.length - 1);
                  } else {
                    _tabController.animateTo(index - 1);
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 3),
        XCPageSelector(
          controller: _tabController,
          color: XCColors.bannerNormalColor,
          selectedColor: XCColors.bannerSelectedColor,
          indicatorSize: 3,
        ),
      ],
    );
  }
}

/// ========= pageSelector =========
class XCPageSelector extends StatelessWidget {
  const XCPageSelector({
    Key? key,
    this.controller,
    this.indicatorSize = 12.0,
    this.color,
    this.selectedColor,
  })  : assert(indicatorSize != null && indicatorSize > 0.0),
        super(key: key);

  final TabController? controller;
  final double indicatorSize;
  final Color? color;
  final Color? selectedColor;

  Widget _buildTabIndicator(
    int tabIndex,
    TabController tabController,
    ColorTween selectedColorTween,
    ColorTween previousColorTween,
  ) {
    final Color background;
    if (tabController.indexIsChanging) {
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex)
        background = selectedColorTween.lerp(t)!;
      else if (tabController.previousIndex == tabIndex)
        background = previousColorTween.lerp(t)!;
      else
        background = selectedColorTween.begin!;
    } else {
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs())!;
      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset)!;
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset)!;
      } else {
        background = selectedColorTween.begin!;
      }
    }
    double indicatorWidth =
        indicatorSize == 6 ? 20 : (indicatorSize == 4 ? 15 : 10);
    double circular = indicatorSize == 6 ? 3 : 1.5;
    return (background == XCColors.bannerSelectedColor ||
            background == XCColors.detailSelectedColor)
        ? Container(
            width: indicatorWidth,
            height: indicatorSize,
            decoration: BoxDecoration(
                color: background,
                border: Border.all(color: selectedColorTween.end!),
                borderRadius: BorderRadius.all(Radius.circular(circular))),
          )
        : ((indicatorSize == 4 || indicatorSize == 6)
            ? Container(
                width: indicatorSize,
                height: indicatorSize,
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
              )
            : Container(
                width: indicatorSize,
                height: indicatorSize,
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(color: selectedColorTween.end!),
                  shape: BoxShape.circle,
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    final Color fixColor = color ?? Colors.transparent;
    final Color fixSelectedColor =
        selectedColor ?? Theme.of(context).colorScheme.secondary;
    final ColorTween selectedColorTween =
        ColorTween(begin: fixColor, end: fixSelectedColor);
    final ColorTween previousColorTween =
        ColorTween(begin: fixSelectedColor, end: fixColor);
    final TabController? tabController =
        controller ?? DefaultTabController.of(context);
    assert(() {
      if (tabController == null) {
        throw FlutterError(
          'No TabController for $runtimeType.\n'
          'When creating a $runtimeType, you must either provide an explicit TabController '
          'using the "controller" property, or you must ensure that there is a '
          'DefaultTabController above the $runtimeType.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());
    final Animation<double> animation = CurvedAnimation(
      parent: tabController!.animation!,
      curve: Curves.fastOutSlowIn,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Semantics(
          label: 'Page ${tabController.index + 1} of ${tabController.length}',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:
                List<Widget>.generate(tabController.length, (int tabIndex) {
              return _buildTabIndicator(tabIndex, tabController,
                  selectedColorTween, previousColorTween);
            }).toList(),
          ),
        );
      },
    );
  }
}

class SplashPageSelector extends StatelessWidget {
  const SplashPageSelector({
    Key? key,
    this.controller,
    this.indicatorSize = 12.0,
    this.color,
    this.selectedColor,
  })  : assert(indicatorSize != null && indicatorSize > 0.0),
        super(key: key);

  final TabController? controller;
  final double indicatorSize;
  final Color? color;
  final Color? selectedColor;

  Widget _buildTabIndicator(
    int tabIndex,
    TabController tabController,
    ColorTween selectedColorTween,
    ColorTween previousColorTween,
  ) {
    final Color background;
    if (tabController.indexIsChanging) {
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex)
        background = selectedColorTween.lerp(t)!;
      else if (tabController.previousIndex == tabIndex)
        background = previousColorTween.lerp(t)!;
      else
        background = selectedColorTween.begin!;
    } else {
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs())!;
      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset)!;
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset)!;
      } else {
        background = selectedColorTween.begin!;
      }
    }
    double indicatorWidth =
        indicatorSize == 6 ? 20 : (indicatorSize == 4 ? 15 : 10);
    double circular = indicatorSize == 6 ? 3 : 1.5;
    return (background == XCColors.themeColor)
        ? Container(
            width: indicatorWidth,
            height: indicatorSize,
            decoration: BoxDecoration(
                color: background,
                border: Border.all(color: selectedColorTween.end!),
                borderRadius: BorderRadius.all(Radius.circular(circular))),
          )
        : ((indicatorSize == 4 || indicatorSize == 6)
            ? Container(
                width: indicatorSize,
                height: indicatorSize,
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
              )
            : Container(
                width: indicatorSize,
                height: indicatorSize,
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(color: selectedColorTween.end!),
                  shape: BoxShape.circle,
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    final Color fixColor = color ?? Colors.transparent;
    final Color fixSelectedColor =
        selectedColor ?? Theme.of(context).colorScheme.secondary;
    final ColorTween selectedColorTween =
        ColorTween(begin: fixColor, end: fixSelectedColor);
    final ColorTween previousColorTween =
        ColorTween(begin: fixSelectedColor, end: fixColor);
    final TabController? tabController =
        controller ?? DefaultTabController.of(context);
    assert(() {
      if (tabController == null) {
        throw FlutterError(
          'No TabController for $runtimeType.\n'
          'When creating a $runtimeType, you must either provide an explicit TabController '
          'using the "controller" property, or you must ensure that there is a '
          'DefaultTabController above the $runtimeType.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());
    final Animation<double> animation = CurvedAnimation(
      parent: tabController!.animation!,
      curve: Curves.fastOutSlowIn,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Semantics(
          label: 'Page ${tabController.index + 1} of ${tabController.length}',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:
                List<Widget>.generate(tabController.length, (int tabIndex) {
              return _buildTabIndicator(tabIndex, tabController,
                  selectedColorTween, previousColorTween);
            }).toList(),
          ),
        );
      },
    );
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging)
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
}
