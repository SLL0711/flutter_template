import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/message/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

abstract class MessageWidgets {
  /// ========= 私信的item =========
  static chatItem(BuildContext context, EMConversation con) {
    /// 头像
    Widget _avatarItem() {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 50,
            height: 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Image.network(
              'https://img2.baidu.com/it/u=325567737,3478266281&fm=26&fmt=auto&gp=0.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              left: 39,
              top: 0,
              child: Offstage(
                offstage: con.unreadCount == 0,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XCColors.bannerSelectedColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    '${con.unreadCount}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ))
        ],
      );
    }

    /// 内容
    Widget _contentItem() {
      return Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            con.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '亲，您做的双眼皮手术多久恢复？需要…',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12),
          )
        ],
      ));
    }

    /// 时间
    Widget _createTimeItem() {
      return Column(
        children: [
          SizedBox(
            height: 19,
          ),
          Text(
            '昨天',
            style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 10),
          )
        ],
      );
    }

    return Container(
      height: 80,
      child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                _avatarItem(),
                SizedBox(
                  width: 20,
                ),
                _contentItem(),
                SizedBox(
                  width: 20,
                ),
                _createTimeItem()
              ],
            ),
          )),
          Container(height: 1, color: XCColors.messageChatDividerColor),
        ],
      ),
    );
  }

  /// ========= 评论没图片的item =========
  static commentItem(BuildContext context, int index) {
    /// 头像
    Widget _avatarItem() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 75,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Image.network(
                'https://img2.baidu.com/it/u=325567737,3478266281&fm=26&fmt=auto&gp=0.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Marry',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: XCColors.mainTextColor, fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  index == 1 ? '07-03 12:19' : '1分钟前',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: XCColors.tabNormalColor, fontSize: 12),
                )
              ],
            )),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 60,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(13)),
                border: Border.all(color: XCColors.goodsGrayColor, width: 1),
              ),
              child: Text(
                '回复',
                style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 12),
              ),
            )
          ],
        ),
      );
    }

    /// 回复内容
    Widget _bodyItem() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 15, top: 7),
        padding: const EdgeInsets.only(left: 11, right: 11, bottom: 7, top: 7),
        color: XCColors.addressScreeningNormalColor,
        child: RichText(
          text: TextSpan(
              text: 'Marry：',
              style: TextStyle(fontSize: 16, color: XCColors.mainTextColor),
              children: [
                TextSpan(
                  text: '感觉效果没有达到预期，有点点小失望',
                  style:
                      TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                ),
              ]),
        ),
      );
    }

    /// 回复内容带图片
    Widget _bodyWithImageItem() {
      return Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(left: 16, right: 16, bottom: 15, top: 7),
          padding: const EdgeInsets.only(right: 11),
          color: XCColors.addressScreeningNormalColor,
          child: Row(
            children: [
              Image.network(
                'https://img1.baidu.com/it/u=3812205697,600483799&fm=26&fmt=auto&gp=0.jpg',
                fit: BoxFit.cover,
                width: 70,
                height: 70,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Marry',
                    style:
                        TextStyle(fontSize: 16, color: XCColors.mainTextColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '感觉效果没有达到预期，有点点小失望，感觉效果没有达到预期，有点点小失望',
                    style:
                        TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              ))
            ],
          ));
    }

    /// 回复的item
    Widget _bodyWithCommentItem() {
      return Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, right: 16, top: 7),
            padding:
                const EdgeInsets.only(left: 11, right: 11, bottom: 7, top: 7),
            color: XCColors.addressScreeningNormalColor,
            child: RichText(
              text: TextSpan(
                  text: 'Marry：',
                  style: TextStyle(fontSize: 16, color: XCColors.mainTextColor),
                  children: [
                    TextSpan(
                      text: '感觉效果没有达到预期，有点点小失望',
                      style: TextStyle(
                          fontSize: 12, color: XCColors.tabNormalColor),
                    ),
                  ]),
            ),
          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 15, top: 7),
              padding: const EdgeInsets.only(right: 11),
              color: Colors.white,
              child: Row(
                children: [
                  Image.network(
                    'https://img1.baidu.com/it/u=3812205697,600483799&fm=26&fmt=auto&gp=0.jpg',
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '小可爱',
                        style: TextStyle(
                            fontSize: 16, color: XCColors.mainTextColor),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '感觉效果没有达到预期，有点点小失望，感觉效果没有达到预期，有点点小失望',
                        style: TextStyle(
                            fontSize: 12, color: XCColors.tabNormalColor),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ))
                ],
              ))
        ],
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _avatarItem(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '感觉有变化吗？',
              style: TextStyle(color: XCColors.mainTextColor, fontSize: 16),
            ),
          ),
          index == 1
              ? _bodyItem()
              : (index == 0 ? _bodyWithImageItem() : _bodyWithCommentItem()),
          Container(height: 10, color: XCColors.homeDividerColor),
        ],
      ),
    );
  }

  /// ========= 通知的item =========
  static noticeItem(BuildContext context, NoticeEntity notice) {
    /*String title = '';
    String content = '';
    String image = '';

    if (index == 0) {
      title = '雀斑官方';
      content = '系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知系统通知';
      image = 'assets/images/home/home_notice_official.png';
    } else if (index == 1) {
      title = '会员券';
      content = '您已成为雀斑会员，获得12张免费会员券，快去钱包查看吧';
      image = 'assets/images/home/home_notice_experience.png';
    } else if (index == 2) {
      title = '会员开通';
      content = '您已成为雀斑黄金会员，赶快去查看可以使用的权限吧！';
      image = 'assets/images/home/home_notice_member.png';
    } else if (index == 3) {
      title = '提现通知';
      content = '亲爱的会员，您申请的颜值金正在提现至您的支付宝账户，请注意查收！';
      image = 'assets/images/home/home_notice_withdraw.png';
    } else if (index == 4) {
      title = '颜值金';
      content = '您成功邀请好友：啊23456成为会员，获得58元颜值金奖励！';
      image = 'assets/images/home/home_notice_profit.png';
    }*/

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 15, right: 16, bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: notice.icon == ''
                    ? Image.asset('assets/images/home/home_notice_official.png')
                    : CommonWidgets.networkImage(notice.icon),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notice.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: XCColors.mainTextColor, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        notice.createTime,
                        style: TextStyle(
                            color: XCColors.goodsOtherGrayColor, fontSize: 11),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Html(data: notice.content),
                  /*Text(
                    notice.content,
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 14),
                  )*/
                ],
              ))
            ],
          ),
        ),
        Container(height: 1, color: XCColors.messageChatDividerColor),
      ],
    );
  }
}
