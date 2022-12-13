import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../colors.dart';

abstract class PosterWidgets {
  /// ========= posterAppBar =========
  static posterAppBar(BuildContext context, String title,
      final VoidCallback backTap, final VoidCallback editTap) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: backTap,
            icon: Image.asset(
              "assets/images/home/back.png",
              width: 18,
              height: 18,
            ),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: XCColors.mainTextColor,
            fontWeight: FontWeight.bold),
      ),
      actions: [
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: editTap,
            child: Container(
                width: 50,
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset('assets/images/home/home_detail_share.png',
                    width: 18, height: 18)))
      ],
    );
  }

  /// ========= posterWidget =========
  static posterWidget(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
              left: 10,
              right: 10,
              top: 10,
              bottom: 0,
              child: Image.network(
                'https://img2.baidu.com/it/u=112737888,3202574066&fm=26&fmt=auto&gp=0.jpg',
                fit: BoxFit.cover,
              )),
          Positioned(
              left: 23,
              right: 23,
              top: 20,
              child: Row(
                children: [
                  Container(
                      width: 29,
                      height: 27,
                      child: Image.asset(
                          'assets/images/profit/profit_poster_logo.png',
                          fit: BoxFit.cover)),
                  SizedBox(width: 5),
                  Expanded(
                      child: Text('雀斑',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ],
              )),
          Positioned(
              left: 10,
              right: 10,
              bottom: 0,
              child: Container(
                height: 120,
                color: Colors.black54,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text('【伊婉V1ml】【正品保障】长效塑形，自然不捏！伊\n婉。 V隆鼻 丰下巴太阳穴',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: '¥',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                  text: '3280',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ])),
                        SizedBox(width: 10),
                        Text('自购立减¥1000',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  /// ========= 个人信息Widget =========
  static posterInfoWidget(BuildContext context) {
    return Container(
        height: 159,
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 15, top: 6, right: 19, bottom: 6),
              height: 92,
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(27)),
                        ),
                        child: Image.network(
                          'https://img2.baidu.com/it/u=325567737,3478266281&fm=26&fmt=auto&gp=0.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('雀斑',
                          style: TextStyle(
                              fontSize: 10, color: XCColors.mainTextColor))
                    ],
                  ),
                  SizedBox(width: 11),
                  Expanded(
                      child: Text('效果很好的一款玻尿酸，赶紧跟我一起体验吧！',
                          style: TextStyle(
                              fontSize: 12, color: XCColors.mainTextColor))),
                  SizedBox(width: 12),
                  Container(
                    width: 60,
                    height: 60,
                    child: QrImage(
                      data: DsApi.share_url,
                      size: 60,
                      padding: EdgeInsets.zero,
                    ),
                  )
                ],
              ),
            ),
            Container(height: 1, color: XCColors.messageChatDividerColor),
            Expanded(
                child: Center(
              child: Container(
                width: 175,
                height: 36,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: XCColors.bannerSelectedColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('邀请码',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 5),
                    Text('KEO1487',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ))
          ],
        ));
  }

  /// ========= 编辑海报 =========
  static editPosterWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
              child: Container(
                  child: Stack(children: [
            Positioned(
                left: 10,
                right: 10,
                top: 10,
                bottom: 0,
                child: Image.network(
                  'https://img2.baidu.com/it/u=112737888,3202574066&fm=26&fmt=auto&gp=0.jpg',
                  fit: BoxFit.cover,
                )),
            Positioned(
                left: 22,
                right: 22,
                top: 20,
                child: Row(
                  children: [
                    Container(width: 25, height: 23, color: Colors.red),
                    SizedBox(width: 5),
                    Expanded(
                        child: Text('雀斑',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ],
                )),
            Positioned(
                left: 10,
                right: 10,
                bottom: 0,
                child: Container(
                  height: 104,
                  color: Colors.black54,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text('【伊婉V1ml】【正品保障】长效塑形，自然不捏！伊婉。 V隆鼻 丰下巴太阳穴',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: '¥',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                    text: '3280',
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ])),
                          SizedBox(width: 10),
                          Text('自购立减¥1000',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                )),
          ]))),
          Container(
            height: 122,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 14, top: 5, right: 18),
                  height: 81,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Image.network(
                              'https://img2.baidu.com/it/u=325567737,3478266281&fm=26&fmt=auto&gp=0.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text('雀斑',
                              style: TextStyle(
                                  fontSize: 10, color: XCColors.mainTextColor))
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text('效果很好的一款玻尿酸，赶紧跟我一起体验吧！',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: XCColors.mainTextColor))),
                      SizedBox(width: 4),
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
                Container(height: 1, color: XCColors.messageChatDividerColor),
                Expanded(
                    child: Center(
                  child: Container(
                    width: 140,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: XCColors.bannerSelectedColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('邀请码',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                        Text('KEO1487',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ========= 编辑海报按钮 =========
  static editPosterButton(
      BuildContext context, String title, final VoidCallback buttonTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: buttonTap,
      child: Container(
        width: 127,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: XCColors.bannerSelectedColor, width: 1),
        ),
        child: Text(
          title,
          style: TextStyle(color: XCColors.bannerSelectedColor, fontSize: 16),
        ),
      ),
    );
  }
}
