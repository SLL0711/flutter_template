import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/privacy.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/login/article.dart';

import 'colors.dart';
import 'navigator.dart';

abstract class CommonWidgets {
  static scoreWidget(int score) {
    return Row(
      children: List.generate(
        score,
        (index) {
          return Container(
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset(
              'assets/images/home/home_detail_score.png',
              width: 14,
              height: 14,
            ),
          );
        },
      ),
    );
  }

  static grayRightArrow() {
    return Container(
        width: 7,
        height: 14,
        child: Image.asset('assets/images/mine/mine_gray_arrow_right.png',
            fit: BoxFit.cover));
  }

  static mainButton(String title, final VoidCallback onTap) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: XCColors.themeColor,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Text(title,
                style: TextStyle(color: Colors.white, fontSize: 18))));
  }

  static checkButton(String title, bool isTap, final VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isTap ? XCColors.themeColor : XCColors.buttonDisableColor,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget networkImage(String pathRel) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: pathRel,
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 24.0,
          height: 24.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            color: XCColors.bannerSelectedColor,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static ruleWidget(int index, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 17,
          height: 16,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/mine/mine_tip_start_icon.png'),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
          child: Text(
            '$index',
            style: TextStyle(
              color: XCColors.hotRuleIndexColor,
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(width: 3),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: XCColors.tabNormalColor,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  static Future<dynamic> showAgreeDialog(BuildContext context) {
    String _data = "  亲爱的雀斑用户，感谢您信任并使用雀斑APP！\n" +
        " \n" +
        "雀斑十分重视用户权利及隐私政策并严格按照相关法律法规的要求，对《用户协议》和《隐私政策》进行了更新,特向您说明如下：\n" +
        "1.为向您提供更优质的服务，我们会收集、使用必要的信息，并会采取业界先进的安全措施保护您的信息安全；\n" +
        "2.基于您的明示授权，我们可能会获取设备号信息、包括：设备型号、操作系统版本、设备设置、设备标识符、MAC（媒体访问控制）地址、IMEI（移动设备国际身份码）、广告标识符（“IDFA”与“IDFV”）、集成电路卡识别码（“ICCD”）、软件安装列表。我们将使用三方产品（TNPS,XInstall等）统计使用我们产品的设备数量并进行设备机型数据分析与设备适配性分析。（以保障您的账号与交易安全），且您有权拒绝或取消授权；\n" +
        "3.您可灵活设置伴伴账号的功能内容和互动权限，您可在《隐私政策》中了解到权限的详细应用说明；\n" +
        "4.未经您同意，我们不会从第三方获取、共享或向其提供您的信息；\n" +
        "5.您可以查询、更正、删除您的个人信息，我们也提供账户注销的渠道。\n" +
        " \n" +
        "请您仔细阅读并充分理解相关条款，其中重点条款已为您黑体加粗标识，方便您了解自己的权利。如您点击“同意”，即表示您已仔细阅读并同意本《用户协议》及《隐私政策》，将尽全力保障您的合法权益并继续为您提供优质的产品和服务。如您点击“不同意”，将可能导致您无法继续使用我们的产品和服务。";
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width * .8,
              child: Column(
                children: [
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      '用户隐私政策概要',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: PrivacyView(
                          data: _data,
                          keys: ['《用户协议》', '《隐私政策》'],
                          keyStyle: TextStyle(color: XCColors.themeColor),
                          onTapCallback: (String key) {
                            if (key == '《用户协议》') {
                              NavigatorUtil.pushPage(
                                context,
                                ArticleScreen('asdessaea'),
                                needLogin: false,
                              );
                            } else if (key == '《隐私政策》') {
                              NavigatorUtil.pushPage(
                                context,
                                ArticleScreen('sqafqm4bm'),
                                needLogin: false,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    height: 45,
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('不同意并退出APP'),
                          ),
                          onTap: () {
                            // Tool.saveBool('isAgree', false);
                            // Navigator.pop(context);
                            exit(0);
                          },
                        )),
                        VerticalDivider(
                          width: 1,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              color: XCColors.themeColor,
                              child: Text(
                                '同意',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onTap: () {
                              Tool.saveBool('isAgree', true);
                              EventCenter.defaultCenter()
                                  .fire(new AgreePrivacyEvent('agree'));
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
