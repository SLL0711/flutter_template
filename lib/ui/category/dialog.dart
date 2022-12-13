import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';

import '../../colors.dart';

typedef VoidCallback tapConfirm(TabEntity result);

class CategoryDialog {
  /// ===========  分类的弹窗  =============
  static void showCategoryDialog(BuildContext context, List<TabEntity> children,
      bool isBanner, tapConfirm) {
    /// 弹窗主要布局
    Widget _buildBody() {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Positioned(
                left: 100,
                right: 0,
                top: isBanner ? kToolbarHeight + 87 : kToolbarHeight + 187,
                bottom: kBottomNavigationBarHeight,
                child: Container(
                  color: Colors.black54,
                )),
            Positioned(
              left: 100,
              right: 0,
              top: isBanner ? kToolbarHeight + 87 : kToolbarHeight + 187,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 15, bottom: 15),
                  color: Colors.white,
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.start,
                    children: children.map(
                      (e) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            tapConfirm(e);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 25,
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4),
                            decoration: BoxDecoration(
                                color: e.isSelected
                                    ? XCColors.themeColor
                                    : XCColors.addressScreeningRightNormalColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.5))),
                            child: Text(
                              e.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.5,
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
            return _buildBody();
          },
        );
      },
    );
  }
}
