import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../colors.dart';

abstract class QuestionWidgets {
  /// ========= 提问 =========
  static problemItem(
      BuildContext context, int index, final VoidCallback deleteTap) {
    Widget _item(String title) {
      return Row(
        children: [
          Container(height: 17, width: 17, child: Image.asset(
              'assets/images/mine/mine_question_ask.png',
            fit: BoxFit.cover
          )),
          SizedBox(width: 3),
          Text(title,
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
        ],
      );
    }

    Widget _bodyItem() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('昨天早上做了开眼角+下眼脸下至手术，术后感觉右眼角伤口裂开，晚上有黄色水泡，这是什么情况。',
              style: TextStyle(
                  fontSize: 14,
                  color: XCColors.mainTextColor,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.addressDividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('开内眼角',
                      style: TextStyle(
                          fontSize: 11, color: XCColors.tabNormalColor))),
              SizedBox(width: 10),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.addressDividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('切开双眼皮',
                      style: TextStyle(
                          fontSize: 11, color: XCColors.tabNormalColor))),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: Text(
                '发布与2019-07-03',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: XCColors.goodsGrayColor),
              )),
              SizedBox(width: 5),
              Row(
                children: [
                  _item('12.1万'),
                  SizedBox(width: 15),
                  _item('12.1万'),
                  SizedBox(width: 15),
                  _item('4567'),
                ],
              )
            ],
          ),
        ],
      );
    }

    Widget _bodyWithImageItem() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text('昨天早上做了开眼角+下眼脸下至手术，术后感觉右眼角伤口裂开，晚上有黄色水泡，这是什么情…',
                      style: TextStyle(
                          fontSize: 14,
                          color: XCColors.mainTextColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          height: 16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: XCColors.addressDividerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Text('开内眼角',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: XCColors.tabNormalColor))),
                      SizedBox(width: 10),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          height: 16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: XCColors.addressDividerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Text('切开双眼皮',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: XCColors.tabNormalColor))),
                    ],
                  ),
                ],
              )),
              SizedBox(width: 10),
              Container(
                height: 120,
                width: 120,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Image.network(
                  'https://img1.baidu.com/it/u=3812205697,600483799&fm=26&fmt=auto&gp=0.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            children: [
              Expanded(
                  child: Text(
                '发布与2019-07-03',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: XCColors.goodsGrayColor),
              )),
              SizedBox(width: 5),
              Row(
                children: [
                  _item('12.1万'),
                  SizedBox(width: 15),
                  _item('12.1万'),
                  SizedBox(width: 15),
                  _item('4567'),
                ],
              )
            ],
          ),
        ],
      );
    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.only(left: 15, top: 15, right: 12, bottom: 13),
        child: index == 0 ? _bodyWithImageItem() : _bodyItem(),
      ),
        secondaryActions: <Widget>[
    IconSlideAction(
    caption: '删除',
      color: Colors.red,
      icon: Icons.delete,
    )
          // child: Container(
          //   alignment: Alignment.center,
          //   // width: 80,
          //   color: XCColors.questionDeleteColor,
          //   child: Text(
          //     '删除',
          //     style: TextStyle(color: Colors.white, fontSize: 18),
          //   ),
          // ),

      ]
    );
  }

  /// ========= 回答 =========
  static answerItem(BuildContext context) {
    Widget _item(String title) {
      return Row(
        children: [
          Container(height: 17, width: 17, child: Image.asset(
              'assets/images/mine/mine_question_answer.png',
              fit: BoxFit.cover
          )),
          SizedBox(width: 3),
          Text(title,
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
        ],
      );
    }

    Widget _bodyItem() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 16,
                    height: 16,
                    child: Image.asset(
                        'assets/images/mine/mine_question_ask.png',
                        fit: BoxFit.cover
                    )
                  )
                  // Image.asset(
                  //   '',
                  //   width: 16,
                  //   height: 16,
                  // ),
                  ),
              TextSpan(
                text: '  昨天早上做了开眼角+下眼脸下至手术，术后感觉右眼角伤口裂开，晚上有黄色水泡，这是什么情况。',
                style: TextStyle(
                    color: XCColors.mainTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.addressDividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('开内眼角',
                      style: TextStyle(
                          fontSize: 11, color: XCColors.tabNormalColor))),
              SizedBox(width: 10),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.addressDividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('切开双眼皮',
                      style: TextStyle(
                          fontSize: 11, color: XCColors.tabNormalColor))),
            ],
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 16,
                    height: 16,
                      child: Image.asset(
                          'assets/images/mine/mine_question_answer.png',
                          fit: BoxFit.cover
                      )
                  )),
              TextSpan(
                text: '  放心没什么问题，之前问题比你这还严重，放心吧。',
                style: TextStyle(color: XCColors.mainTextColor, fontSize: 12),
              ),
            ]),
          ),
          SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                  child: Text(
                '我回答于2019-07-03',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: XCColors.goodsGrayColor),
              )),
              SizedBox(width: 5),
              Row(
                children: [
                  _item('12.1万'),
                  SizedBox(width: 15),
                  _item('12.1万'),
                  SizedBox(width: 15),
                  _item('4567'),
                ],
              )
            ],
          ),
        ],
      );
    }

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 15, top: 15, right: 12, bottom: 15),
      child: _bodyItem(),
    );
  }

  /// ========= 推荐 =========
  static recommendItem(BuildContext context) {
    Widget _item(String title) {
      return Row(
        children: [
          Container(height: 17, width: 17, color: Colors.red),
          SizedBox(width: 3),
          Text(title,
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
        ],
      );
    }

    Widget _bodyItem() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 16,
                    height: 16,
                    color: Colors.red,
                  )),
              TextSpan(
                text: '  昨天早上做了开眼角+下眼脸下至手术，术后感觉右眼角伤口裂开，晚上有黄色水泡，这是什么情况。',
                style: TextStyle(
                    color: XCColors.mainTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.addressDividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('开内眼角',
                      style: TextStyle(
                          fontSize: 11, color: XCColors.tabNormalColor))),
              SizedBox(width: 10),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.addressDividerColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text('切开双眼皮',
                      style: TextStyle(
                          fontSize: 11, color: XCColors.tabNormalColor))),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _item('12.1万'),
                    SizedBox(width: 15),
                    _item('12.1万'),
                    SizedBox(width: 15),
                    _item('4567'),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 60,
                height: 25,
                margin: const EdgeInsets.only(right: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.bannerSelectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(12.5)),
                ),
                child: Text(
                  '回答',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 15, top: 15, right: 12, bottom: 15),
      child: _bodyItem(),
    );
  }
}
