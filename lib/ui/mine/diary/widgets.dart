import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/dialog.dart';

import '../../../colors.dart';

typedef VoidCallback onComfirm(int type);

abstract class DiaryWidgets {
  static diaryItem(BuildContext context, DiaryItemEntity itemEntity, onComfirm,
      final VoidCallback onTap) {
    Widget _bodyWidget() {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6)),
            boxShadow: [
              BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 6)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(children: [
              Container(
                width: 60,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  '第${itemEntity.xday}天',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  itemEntity.projectName,
                  style: TextStyle(
                    color: XCColors.mainTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 9),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (TapDownDetails details) {
                  DiaryBookDialog.showTip(
                    context,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    onComfirm,
                  );
                },
                child: Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Image.asset('assets/images/mine/mine_diary_more.png'),
                ),
              ),
              SizedBox(width: 15)
            ]),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                '手术时间：${itemEntity.operationTime}',
                style: TextStyle(
                  color: XCColors.tabNormalColor,
                  fontSize: 10,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text(
                    '共${itemEntity.diaryDetailCount}篇日记',
                    style: TextStyle(
                      color: XCColors.mainTextColor,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '坚持写日记，感受不断变美的自己',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: XCColors.tabNormalColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 19),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 22),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  '写日记',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      );
    }

    return _bodyWidget();
  }
}
