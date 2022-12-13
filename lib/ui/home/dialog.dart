import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';

import 'entity.dart';

typedef VoidCallback confirm(String result);

class HomeDialog {
  /// ===========  区域  =============
  static void showAddressList(
      BuildContext context,
      List<HomeAddressEntity> addressEntityList,
      List<OrganizationEntity> childrenList,
      ScreeningParams screeningParams,
      final VoidCallback onCancel,
      confirm) {
    /// 左边列表的item
    Widget _leftListItem(HomeAddressEntity entity) {
      return Container(
        height: 45,
        color: entity.isSelected
            ? Colors.white
            : XCColors.addressScreeningNormalColor,
        child: Row(
          children: [
            Offstage(
                offstage: !entity.isSelected,
                child: Container(
                  width: 3,
                  color: XCColors.bannerSelectedColor,
                )),
            SizedBox(width: entity.isSelected ? 12 : 15),
            Expanded(
              child: Text(
                entity.name,
                style: TextStyle(
                  fontSize: 12,
                  color: entity.isSelected
                      ? XCColors.bannerSelectedColor
                      : XCColors.tabNormalColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 右边列表的item
    Widget _rightListItem() {
      return Container(
        height: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
        child: childrenList.isEmpty
            ? Container()
            : Wrap(
                spacing: 15,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: childrenList.map(
                  (e) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        childrenList.forEach((element) {
                          element.isSelected = false;
                        });
                        e.isSelected = true;
                        screeningParams.orgId = e.id;
                        confirm('1');
                        EventCenter.defaultCenter()
                            .fire(RefreshProductEvent(1));
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 25,
                        padding:
                            const EdgeInsets.only(left: 6, right: 6, top: 4),
                        decoration: BoxDecoration(
                          color: e.isSelected
                              ? XCColors.bannerSelectedColor
                              : XCColors.addressScreeningRightNormalColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.5),
                          ),
                        ),
                        child: Text(
                          e.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: e.isSelected
                                ? Colors.white
                                : XCColors.mainTextColor,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
      );
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
          onCancel();
        },
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: kToolbarHeight + 78,
                bottom: kBottomNavigationBarHeight,
                child: Container(color: Colors.black54)),
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight + 78,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  height: 408,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(height: 1, color: XCColors.homeScreeningColor),
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                                width: 120,
                                color: XCColors.addressScreeningNormalColor,
                                child: addressEntityList.isEmpty
                                    ? Container()
                                    : ListView.builder(
                                        itemCount: addressEntityList.length,
                                        itemBuilder: (context, index) {
                                          HomeAddressEntity entity =
                                              addressEntityList[index];
                                          return GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                setState(() {
                                                  addressEntityList
                                                      .forEach((element) {
                                                    element.isSelected = false;
                                                  });
                                                  entity.isSelected = true;
                                                });
                                                confirm(
                                                    '${entity.sheng},${entity.shi}');
                                              },
                                              child: _leftListItem(entity));
                                        })),
                            Expanded(
                              child: _rightListItem(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (cxt, state) {
          return _buildBody(state);
        });
      },
    );
  }

  /// ===========  距离  =============
  static void showDistanceList(
      BuildContext context,
      List<HomeDistanceEntity> distanceEntityList,
      ScreeningParams screeningParams,
      final VoidCallback onCancel,
      confirm) {
    /// 距离列表的item
    Widget _distanceListItem(HomeDistanceEntity entity) {
      return Container(
        height: 48,
        color: Colors.white,
        child: Row(
          children: [
            Offstage(
              offstage: !entity.isSelected,
              child: Container(
                width: 3,
                color: XCColors.detailSelectedColor,
              ),
            ),
            SizedBox(width: entity.isSelected ? 12 : 15),
            Expanded(
              child: Text(
                entity.city,
                style: TextStyle(
                  fontSize: 12,
                  color: entity.isSelected
                      ? XCColors.bannerSelectedColor
                      : XCColors.tabNormalColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
          onCancel();
        },
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: kToolbarHeight + 78,
                bottom: kBottomNavigationBarHeight,
                child: Container(color: Colors.black54)),
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight + 78,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  height: 192,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        color: XCColors.homeScreeningColor,
                      ),
                      Expanded(
                        child: distanceEntityList.isEmpty
                            ? Container()
                            : ListView.builder(
                                itemCount: distanceEntityList.length,
                                itemBuilder: (context, index) {
                                  HomeDistanceEntity entity =
                                      distanceEntityList[index];
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      distanceEntityList.forEach((element) {
                                        element.isSelected = false;
                                      });
                                      entity.isSelected = true;
                                      setState(() {
                                        screeningParams.distanceFilterType = 2;
                                        if (index == 0) {
                                          screeningParams.distanceFilterType =
                                              1;
                                        } else if (index == 1) {
                                          screeningParams.minDistance = 0;
                                          screeningParams.maxDistance = 5;
                                        } else if (index == 2) {
                                          screeningParams.minDistance = 5;
                                          screeningParams.maxDistance = 10;
                                        } else if (index == 3) {
                                          screeningParams.minDistance = 10;
                                          screeningParams.maxDistance = 10000;
                                        }
                                      });
                                      confirm('1');
                                      EventCenter.defaultCenter()
                                          .fire(RefreshProductEvent(2));
                                      Navigator.pop(context);
                                    },
                                    child: _distanceListItem(entity),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (cxt, state) {
          return _buildBody(state);
        });
      },
    );
  }

  /// ===========  智能排序  =============
  static void showSmartList(
      BuildContext context,
      List<HomeSmartEntity> smartEntityList,
      ScreeningParams screeningParams,
      final VoidCallback onCancel,
      confirm) {
    /// 距离列表的item
    Widget _distanceListItem(HomeSmartEntity entity) {
      return Container(
        height: 48,
        color: Colors.white,
        child: Row(
          children: [
            Offstage(
              offstage: !entity.isSelected,
              child: Container(
                width: 3,
                color: XCColors.detailSelectedColor,
              ),
            ),
            SizedBox(width: entity.isSelected ? 12 : 15),
            Expanded(
              child: Text(
                entity.city,
                style: TextStyle(
                  fontSize: 12,
                  color: entity.isSelected
                      ? XCColors.bannerSelectedColor
                      : XCColors.tabNormalColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
          onCancel();
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight + 78,
              bottom: kBottomNavigationBarHeight,
              child: Container(color: Colors.black54),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight + 78,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  height: 336,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(height: 1, color: XCColors.homeScreeningColor),
                      Expanded(
                        child: smartEntityList.isEmpty
                            ? Container()
                            : ListView.builder(
                                itemCount: smartEntityList.length,
                                itemBuilder: (context, index) {
                                  HomeSmartEntity entity =
                                      smartEntityList[index];
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      smartEntityList.forEach((element) {
                                        element.isSelected = false;
                                      });
                                      entity.isSelected = true;

                                      screeningParams.cleverSortType =
                                          index + 1;
                                      EventCenter.defaultCenter()
                                          .fire(RefreshProductEvent(3));
                                      confirm('3');
                                      Navigator.pop(context);
                                    },
                                    child: _distanceListItem(entity),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (cxt, state) {
            return _buildBody(state);
          },
        );
      },
    );
  }

  /// ===========  筛选  =============
  static void showScreeningList(
      BuildContext context,
      TextEditingController minTextEditingController,
      TextEditingController maxTextEditingController,
      List<OrganizationTypeEntity> typeEntityList,
      List<HomeScreeningEntity> welfareEntityList,
      ScreeningParams screeningParams,
      final VoidCallback onCancel,
      confirm) {
    /// 商家类型的item
    Widget _typeItem(StateSetter setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text('商家类型：',
                style: TextStyle(fontSize: 14, color: XCColors.mainTextColor)),
            SizedBox(height: 15),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: typeEntityList.map((e) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      typeEntityList.forEach((element) {
                        element.isSelected = false;
                      });
                      e.isSelected = true;
                    });
                  },
                  child: Container(
                    height: 27,
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
                    decoration: BoxDecoration(
                      color: e.isSelected
                          ? XCColors.themeColor
                          : XCColors.addressScreeningRightNormalColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(13.5),
                      ),
                    ),
                    child: Text(
                      e.typeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: e.isSelected
                              ? Colors.white
                              : XCColors.mainTextColor),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 15)
          ],
        ),
      );
    }

    /// 专享福利的item
    Widget _welfareItem(StateSetter setState) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text('专享福利：',
                style: TextStyle(fontSize: 14, color: XCColors.mainTextColor)),
            SizedBox(height: 15),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: welfareEntityList.map(
                (e) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(
                        () {
                          welfareEntityList.forEach((element) {
                            element.isSelected = false;
                          });
                          e.isSelected = true;
                        },
                      );
                    },
                    child: Container(
                      height: 27,
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, top: 4),
                      decoration: BoxDecoration(
                        color: e.isSelected
                            ? XCColors.themeColor
                            : XCColors.addressScreeningRightNormalColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(13.5),
                        ),
                      ),
                      child: Text(
                        e.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: e.isSelected
                              ? Colors.white
                              : XCColors.mainTextColor,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    }

    /// 价格区间
    Widget _priceItem() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              '价格区间：',
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
              ),
            ),
            SizedBox(height: 15),
            Row(children: [
              Container(
                  width: 103,
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: XCColors.addressScreeningRightNormalColor,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextField(
                      controller: minTextEditingController,
                      style: TextStyle(
                          fontSize: 12, color: XCColors.mainTextColor),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '最低价',
                          hintStyle: TextStyle(
                              fontSize: 12, color: XCColors.goodsGrayColor)))),
              SizedBox(width: 20),
              Text('至',
                  style:
                      TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
              SizedBox(width: 20),
              Container(
                width: 103,
                height: 30,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: XCColors.addressScreeningRightNormalColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: TextField(
                  controller: maxTextEditingController,
                  style: TextStyle(fontSize: 12, color: XCColors.mainTextColor),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '最高价',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: XCColors.goodsGrayColor,
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 40)
          ],
        ),
      );
    }

    /// 按钮
    Widget _buttonsItem(StateSetter setState) {
      return Container(
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  minTextEditingController.clear();
                  maxTextEditingController.clear();
                  screeningParams.orgTypeId = 0;
                  screeningParams.groupFlag = 0;
                  screeningParams.minPrice = 0;
                  screeningParams.maxPrice = 0;
                  setState(
                    () {
                      welfareEntityList.forEach((element) {
                        element.isSelected = false;
                      });
                      typeEntityList.forEach((element) {
                        element.isSelected = false;
                      });
                    },
                  );
                  EventCenter.defaultCenter().fire(RefreshProductEvent(4));
                  confirm('4');
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '重置',
                    style: TextStyle(
                      fontSize: 18,
                      color: XCColors.themeColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  int orgTypeId = -1;
                  typeEntityList.forEach((element) {
                    if (element.isSelected) {
                      orgTypeId = element.id;
                    }
                  });
                  int groupFlag = -1;
                  welfareEntityList.forEach((element) {
                    if (element.isSelected) {
                      groupFlag = 1;
                    }
                  });
                  screeningParams.orgTypeId = 0;
                  screeningParams.groupFlag = 0;
                  if (orgTypeId != -1) screeningParams.orgTypeId = orgTypeId;
                  if (groupFlag != -1) screeningParams.groupFlag = 1;
                  if (minTextEditingController.text.isEmpty) {
                    screeningParams.minPrice = 0;
                  } else {
                    screeningParams.minPrice =
                        int.parse(minTextEditingController.text);
                  }
                  if (maxTextEditingController.text.isEmpty) {
                    screeningParams.maxPrice = 0;
                  } else {
                    screeningParams.maxPrice =
                        int.parse(maxTextEditingController.text);
                  }
                  EventCenter.defaultCenter().fire(RefreshProductEvent(4));
                  confirm('4');
                  Navigator.pop(context);
                },
                child: Container(
                  color: XCColors.themeColor,
                  alignment: Alignment.center,
                  child: Text(
                    '确定',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
          onCancel();
        },
        child: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: kToolbarHeight + 78,
                bottom: kBottomNavigationBarHeight,
                child: Container(color: Colors.black54)),
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight + 78,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(height: 1, color: XCColors.homeScreeningColor),
                      typeEntityList.isEmpty
                          ? Container()
                          : _typeItem(setState),
                      Container(height: 1, color: XCColors.homeScreeningColor),
                      welfareEntityList.isEmpty
                          ? Container()
                          : _welfareItem(setState),
                      Container(height: 1, color: XCColors.homeScreeningColor),
                      _priceItem(),
                      Container(height: 1, color: XCColors.homeScreeningColor),
                      _buttonsItem(setState)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (cxt, state) {
          return Scaffold(
              backgroundColor: Colors.transparent, body: _buildBody(state));
        });
      },
    );
  }
}
