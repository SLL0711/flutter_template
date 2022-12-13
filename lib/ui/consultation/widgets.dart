import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';

import '../../colors.dart';
import '../../tool.dart';
import '../../widgets.dart';

abstract class ConsultationWidgets {
  /// 导航栏
  static appBar(BuildContext context, String title) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: XCColors.mainTextColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  static header(BuildContext context, List<BannerEntity> bannerList) {
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
          Container(height: 10, color: Colors.white),
        ],
      ),
    );
  }

  static scoreStar(BuildContext context, double score) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/video/${score > 0.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 14,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 1.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 14,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 2.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 14,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 3.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 14,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 4.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 14,
        ),
      ],
    );
  }

  static scoreBigStar(BuildContext context, double score) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/video/${score > 0.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 20,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 1.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 20,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 2.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 20,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 3.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 20,
          height: 20,
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/images/video/${score > 4.5 ? 'ic_star_active' : 'ic_star'}.png',
          width: 20,
        ),
      ],
    );
  }

  /// ===========  排序筛选  =============
  static void showActionDialog(
    BuildContext context,
    int current,
    List<String> list,
    callback,
  ) {
    // 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight + 30,
              bottom: kBottomNavigationBarHeight,
              child: Container(
                color: Colors.black54,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: kToolbarHeight + 30,
              child: Container(
                height: 40 * list.length + 1,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        callback(index);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          list[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: current == index
                                ? XCColors.themeColor
                                : XCColors.mainTextColor,
                          ),
                        ),
                      ),
                    );
                  },
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
}
