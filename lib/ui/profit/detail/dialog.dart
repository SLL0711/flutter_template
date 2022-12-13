import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

import '../../../api.dart';

class HotDialog {
  /// ===========  兑换热力值提示  =============
  static void showExchangeTip(
      BuildContext context, int value, VoidCallback callback) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 275,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 17, top: 31, right: 11, bottom: 23),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: '兑换',
                            style: TextStyle(
                                fontSize: 14, color: XCColors.mainTextColor),
                            children: [
                              TextSpan(
                                text: value == 15 ? '1000' : '3000',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.bannerSelectedColor),
                              ),
                              TextSpan(
                                text: '元颜值金，将扣除',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.mainTextColor),
                              ),
                              TextSpan(
                                text: '$value',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.bannerSelectedColor),
                              ),
                              TextSpan(
                                text: '个热力值',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.mainTextColor),
                              ),
                            ])),
                  ),
                  Container(height: 1, color: XCColors.messageChatDividerColor),
                  Container(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '再想想',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                    color: XCColors.goodsGrayColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                            width: 1, color: XCColors.messageChatDividerColor),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: callback,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                    color: XCColors.bannerSelectedColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (cxt, state) {
            return _buildBody(state);
          },
        );
      },
    );
  }

  /// ===========  邀请弹窗  =============
  static void showShareDialog(
      BuildContext context, final VoidCallback posterTap) {
    /// 分享item
    Widget _shareItem(String image, String title) {
      return Column(
        children: [
          Container(width: 55, height: 55, child: Image.asset(image)),
          SizedBox(height: 13),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: XCColors.tabNormalColor,
              decoration: TextDecoration.none,
            ),
          )
        ],
      );
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 208,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(height: 11),
                Row(
                  children: [
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: 47,
                        height: 47,
                        child: Icon(Icons.close, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 35),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          posterTap();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: _shareItem(
                            'assets/images/home/home_detail_share_link.png',
                            '二维码邀请海报\n（可分享至朋友圈）'),
                      ),
                    ),
                    SizedBox(width: 35),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          var model = fluwx.WeChatShareWebPageModel(
                              DsApi.share_url,
                              title: '邀请你加入雀斑会员，带你一起变美一起赚钱！',
                              thumbnail: fluwx.WeChatImage.asset(
                                  'assets/images/home/home_notice_official.png'),
                              scene: fluwx.WeChatScene.SESSION);
                          fluwx.shareToWeChat(model);
                        },
                        child: _shareItem(
                            'assets/images/home/home_detail_share_wechat.png',
                            '发送邀请给微信好友\n'),
                      ),
                    ),
                    SizedBox(width: 35),
                  ],
                ),
              ],
            ),
          ),
        )
      ]);
    }

    showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (cxt, state) {
              return _buildBody(state);
            },
          );
        });
  }
}
