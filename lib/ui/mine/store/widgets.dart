import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_fake.dart';
import 'package:flutter_medical_beauty/ui/login/article.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import '../../../colors.dart';
import '../../../navigator.dart';

abstract class StoreWidgets {
  /// 构建店铺信息模块
  static storeInfo(
      BuildContext context,
      int applyType,
      TextEditingController nameController,
      TextEditingController describeController,
      String logoUrl,
      bool isGrounding,
      VoidCallback selectLogo,
      Function(int) callback) {
    // 店铺类型组件
    Widget _checkItem(int type, String title) {
      return GestureDetector(
        onTap: () {
          callback(type);
        },
        child: Container(
          width: 80,
          height: double.infinity,
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: 15,
                height: 14.5,
                child: Image.asset(
                  type == applyType
                      ? 'assets/images/box/box_check_selected.png'
                      : 'assets/images/box/box_check_normal.png',
                  fit: BoxFit.cover,
                  color: type == applyType
                      ? XCColors.themeColor
                      : XCColors.mainTextColor,
                ),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: XCColors.mainTextColor),
              ),
            ],
          ),
        ),
      );
    }

    // 输入组件
    Widget _inputItem(TextEditingController controller, String hint) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 13,
            color: XCColors.mainTextColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
          ),
        ),
      );
    }

    // 描述输入组件
    Widget _otherInputItem(TextEditingController controller, String hint) {
      return Container(
        height: 126,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 13, color: XCColors.mainTextColor),
                maxLines: 50,
                maxLength: 120,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle:
                      TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
                ),
              ),
            ),
            SizedBox(height: 10),
            /*Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '0/120',
                style: TextStyle(fontSize: 10, color: XCColors.goodsGrayColor),
              ),
            ),*/
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            child: Row(
              children: [
                Text(
                  '入驻类型 ',
                  style: TextStyle(
                    fontSize: 14,
                    color: XCColors.tabNormalColor,
                  ),
                ),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    color: XCColors.detailSelectedColor,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _checkItem(0, isGrounding ? '技师' : '咨询师'),
                      SizedBox(width: 20),
                      _checkItem(1, isGrounding ? '门店' : '商家')
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: _inputItem(
                  nameController,
                  '请输入您的${applyType == 1 ? '${isGrounding ? '门店' : '商家'}名称' : '姓名'}',
                ),
              ),
              SizedBox(width: 5),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.detailSelectedColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _otherInputItem(
                  describeController,
                  '请输入${applyType == 1 ? '${isGrounding ? '门店' : '商家'}简介' : '个人简介'}',
                ),
              ),
              SizedBox(width: 5),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.detailSelectedColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: selectLogo,
            child: Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: XCColors.storeCameraBgColor),
              child: logoUrl.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/mine/mine_store_upload.png",
                          width: 36,
                          height: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${applyType == 1 ? '${isGrounding ? '门店' : '商家'}LOGO' : '个人头像'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: XCColors.tabNormalColor,
                          ),
                        ),
                      ],
                    )
                  : CommonWidgets.networkImage(logoUrl),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '图片尺寸：300px*300px',
            style: TextStyle(
              fontSize: 12,
              color: XCColors.goodsGrayColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建咨询师信息模块
  static personInfo(
    BuildContext context,
    int gender,
    TextEditingController phoneController,
    TextEditingController weChatController,
    TextEditingController aliPayController,
    String faceUrl,
    String backUrl,
    String qualificationUrl,
    String businessUrl,
    String diagnosisUrl,
    String province,
    String city,
    String area,
    bool isGrounding,
    Function(int) selectArea,
    Function(int) callback,
    Function(int) selectGender,
  ) {
    // 单选
    Widget _checkItem(int type, String title) {
      return GestureDetector(
        onTap: () {
          selectGender(type);
        },
        child: Container(
          width: 80,
          height: double.infinity,
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: 15,
                height: 14.5,
                child: Image.asset(
                  type == gender
                      ? 'assets/images/box/box_check_selected.png'
                      : 'assets/images/box/box_check_normal.png',
                  fit: BoxFit.cover,
                  color: type == gender
                      ? XCColors.themeColor
                      : XCColors.mainTextColor,
                ),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: XCColors.mainTextColor),
              ),
            ],
          ),
        ),
      );
    }

    //输入
    Widget _inputItem(TextEditingController controller, String hint) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(
            width: 1,
            color: XCColors.invoiceBorderColor,
          ),
        ),
        child: TextField(
          controller: controller,
          maxLines: 1,
          style: TextStyle(
            fontSize: 13,
            color: XCColors.mainTextColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
          ),
        ),
      );
    }

    // 图片
    Widget _uploadItem(String title, String url) {
      return Container(
        height: 65,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 1, color: XCColors.invoiceBorderColor),
        ),
        child: url.isNotEmpty
            ? CommonWidgets.networkImage(url)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/mine/mine_store_camera.png",
                    width: 36,
                    height: 28,
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: XCColors.goodsGrayColor,
                    ),
                  ),
                ],
              ),
      );
    }

    // 地址
    Widget _screeningItem(String title) {
      return Container(
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(width: 5),
            Image.asset(
              "assets/images/mine/mine_store_arrow_down.png",
              width: 10,
              height: 5,
            ),
            SizedBox(width: 15),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        children: [
          Container(
            height: 36,
            child: Row(
              children: [
                Text('性别 ',
                    style: TextStyle(
                      fontSize: 14,
                      color: XCColors.tabNormalColor,
                    )),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    color: XCColors.detailSelectedColor,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _checkItem(1, '男'),
                      SizedBox(width: 20),
                      _checkItem(2, '女')
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _inputItem(phoneController, '请输入手机号码')),
              SizedBox(width: 5),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.detailSelectedColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _inputItem(weChatController, '请输入微信号'),
          SizedBox(height: 10),
          _inputItem(aliPayController, '请输入支付宝账号'),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(1),
                child: _uploadItem('身份证正面', faceUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(2),
                child: _uploadItem('身份证反面', backUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(3),
                child: isGrounding
                    ? Container()
                    : _uploadItem('咨询师资格证', qualificationUrl),
              ),
            ),
          ]),
          SizedBox(height: isGrounding ? 0 : 10),
          Offstage(
            offstage: isGrounding,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => callback(4),
                    child: _uploadItem('咨询师执业证', businessUrl),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => callback(5),
                    child: _uploadItem('医疗美容主诊咨询师资格证', diagnosisUrl),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '所在地',
                    style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(0),
                    child: _screeningItem(province),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(1),
                    child: _screeningItem(city),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(2),
                    child: _screeningItem(area),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建商家信息模块
  static companyInfo(
    BuildContext context,
    TextEditingController companyController,
    TextEditingController telPhoneController,
    TextEditingController phoneController,
    TextEditingController bankController,
    TextEditingController openBankController,
    TextEditingController accountController,
    TextEditingController weChatController,
    TextEditingController aliPayController,
    TextEditingController addressController,
    String businessUrl,
    String organizationUrl,
    String brandUrl,
    String tradeUrl,
    String province,
    String city,
    String area,
    bool isGrounding,
    Function(int) selectArea,
    Function(int) callback,
  ) {
    //输入
    Widget _inputItem(TextEditingController controller, String hint) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 13,
            color: XCColors.mainTextColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
          ),
        ),
      );
    }

    // 图片
    Widget _uploadItem(String title, String url) {
      return Container(
        height: 65,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 1, color: XCColors.invoiceBorderColor),
        ),
        child: url.isNotEmpty
            ? CommonWidgets.networkImage(url)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/mine/mine_store_camera.png",
                    width: 36,
                    height: 28,
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: XCColors.goodsGrayColor,
                    ),
                  ),
                ],
              ),
      );
    }

    // 地址
    Widget _screeningItem(String title) {
      return Container(
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(width: 5),
            Image.asset(
              "assets/images/mine/mine_store_arrow_down.png",
              width: 10,
              height: 5,
            ),
            SizedBox(width: 15),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _inputItem(companyController, '请输入公司名称')),
              SizedBox(width: 5),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.detailSelectedColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _inputItem(phoneController, '请输入负责人电话')),
              SizedBox(width: 5),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.detailSelectedColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _inputItem(telPhoneController, '请输入客服联系电话')),
              SizedBox(width: 5),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.detailSelectedColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _inputItem(bankController, '请输入对公账户名称'),
          SizedBox(height: 10),
          _inputItem(openBankController, '请输入开户行'),
          SizedBox(height: 10),
          _inputItem(accountController, '请输入对公账号'),
          SizedBox(height: 10),
          _inputItem(weChatController, '请输入微信号'),
          SizedBox(height: 10),
          _inputItem(aliPayController, '请输入支付宝账号'),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(6),
                child: _uploadItem('营业执照', businessUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(7),
                child: isGrounding
                    ? Container()
                    : _uploadItem('医疗商家执业许可证', organizationUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(8),
                child:
                    isGrounding ? Container() : _uploadItem('品牌授权书', brandUrl),
              ),
            ),
          ]),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => callback(9),
                  child:
                      isGrounding ? Container() : _uploadItem('商标证书', tradeUrl),
                ),
              ),
              SizedBox(width: 10),
              Expanded(child: Container()),
              SizedBox(width: 10),
              Expanded(child: Container()),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '所在地',
                    style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(0),
                    child: _screeningItem(province),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(1),
                    child: _screeningItem(city),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(2),
                    child: _screeningItem(area),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          _inputItem(addressController, '请输入经营详细地址'),
        ],
      ),
    );
  }

  /// 构建个人信息模块
  static storePersonHeaderView(BuildContext context, String faceUrl,
      String backUrl, String handleUrl, Function(int) callback) {
    Widget _uploadItem(String title, String url) {
      return Container(
        height: 65,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 1, color: XCColors.invoiceBorderColor),
        ),
        child: url.isNotEmpty
            ? CommonWidgets.networkImage(url)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/mine/mine_store_camera.png",
                    width: 36,
                    height: 28,
                  ),
                  SizedBox(height: 4),
                  Text(
                    title,
                    style:
                        TextStyle(fontSize: 11, color: XCColors.goodsGrayColor),
                  ),
                ],
              ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: 2, height: 15, color: XCColors.bannerSelectedColor),
              SizedBox(width: 7),
              Text('个人',
                  style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                      fontWeight: FontWeight.bold))
            ],
          ),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(0),
                child: _uploadItem('身份证正面', faceUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(1),
                child: _uploadItem('身份证反面', backUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(2),
                child: _uploadItem('手持身份证照', handleUrl),
              ),
            ),
          ])
        ],
      ),
    );
  }

  /// 构建个人的绑定提款、微信或支付宝信息模块
  static storePersonBankView(
      BuildContext context,
      TextEditingController realNameController,
      TextEditingController identifyController,
      TextEditingController bankCardController,
      TextEditingController phoneController,
      TextEditingController weChatController,
      TextEditingController aliPayController,
      {bool isEnterprise = false}) {
    Widget _inputItem(String hint, TextEditingController controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 13,
            color: XCColors.mainTextColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 2, height: 15, color: XCColors.bannerSelectedColor),
              SizedBox(width: 7),
              Text(isEnterprise ? '企业的绑定提款' : '个人的绑定提款',
                  style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                      fontWeight: FontWeight.bold))
            ],
          ),
          SizedBox(height: 10),
          SizedBox(height: 10),
          Text('银行卡',
              style: TextStyle(
                  fontSize: 12,
                  color: XCColors.mainTextColor,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _inputItem('真实姓名', realNameController),
          SizedBox(height: 10),
          _inputItem('身份证号', identifyController),
          SizedBox(height: 10),
          _inputItem('银行卡卡号', bankCardController),
          SizedBox(height: 10),
          _inputItem('手机号', phoneController),
          SizedBox(height: 10),
          Text('填写您在银行预留的手机号码，以验证银行卡是否属于您本人',
              style: TextStyle(fontSize: 10, color: XCColors.tabNormalColor)),
          SizedBox(height: 20),
          Text('微信或支付宝',
              style: TextStyle(fontSize: 14, color: XCColors.mainTextColor)),
          SizedBox(height: 10),
          _inputItem('微信', weChatController),
          SizedBox(height: 10),
          _inputItem('支付宝', aliPayController),
          SizedBox(height: 10)
        ],
      ),
    );
  }

  static storePersonRuleView(BuildContext context, bool isAgree,
      VoidCallback agreeTap, VoidCallback applyTap) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: agreeTap,
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    child: Image.asset(
                      isAgree
                          ? 'assets/images/box/box_check_selected.png'
                          : 'assets/images/box/box_check_normal.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: '请仔细阅读并同意雀斑',
                        style: TextStyle(
                            fontSize: 12, color: XCColors.goodsGrayColor),
                        children: [
                          TextSpan(
                            text: '《入驻服务协议》',
                            style: TextStyle(
                                fontSize: 12,
                                color: XCColors.bannerSelectedColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigatorUtil.pushPage(
                                    context, ArticleScreen('h0jekec91'),
                                    needLogin: false);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: applyTap,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: XCColors.bannerSelectedColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Text(
                '申请入驻',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  /// 构建企业信息模块
  static storeEnterpriseHeaderView(
      BuildContext context,
      TextEditingController businessController,
      TextEditingController companyNameController,
      TextEditingController registerMoneyController,
      TextEditingController manageController,
      TextEditingController webSiteController,
      TextEditingController brandController,
      String businessLicenseUrl,
      String brandAuthImageUrl,
      String tradeMarkImageUrl,
      Function(int) callback) {
    Widget _inputItem(String hint, TextEditingController controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 13,
            color: XCColors.mainTextColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
          ),
        ),
      );
    }

    Widget _otherInputItem(
        String hint, double height, TextEditingController controller) {
      return Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: TextField(
          controller: controller,
          style: TextStyle(fontSize: 13, color: XCColors.mainTextColor),
          maxLines: 50,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
          ),
        ),
      );
    }

    Widget _inputWithUnitItem(String hint, TextEditingController controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 13,
                  color: XCColors.mainTextColor,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle:
                      TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text('万元',
                style: TextStyle(fontSize: 12, color: XCColors.mainTextColor)),
          ],
        ),
      );
    }

    Widget _uploadItem(String title, String url) {
      return Container(
        height: 65,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 1, color: XCColors.invoiceBorderColor),
        ),
        child: url.isNotEmpty
            ? CommonWidgets.networkImage(url)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/mine/mine_store_camera.png",
                    width: 36,
                    height: 28,
                  ),
                  SizedBox(height: 4),
                  Text(title,
                      style: TextStyle(
                          fontSize: 11, color: XCColors.goodsGrayColor))
                ],
              ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 2, height: 15, color: XCColors.bannerSelectedColor),
              SizedBox(width: 7),
              Text('企业',
                  style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                      fontWeight: FontWeight.bold))
            ],
          ),
          SizedBox(height: 8),
          _inputItem('营业执照注册号', businessController),
          SizedBox(height: 10),
          _inputItem('公司名称', companyNameController),
          SizedBox(height: 10),
          _inputWithUnitItem('注册资金', registerMoneyController),
          SizedBox(height: 10),
          _otherInputItem('经营范围', 117, manageController),
          SizedBox(height: 10),
          Text('经营范围请与营业执照保持一致哦',
              style: TextStyle(fontSize: 12, color: XCColors.mainTextColor)),
          SizedBox(height: 10),
          _inputItem('公司网址', webSiteController),
          SizedBox(height: 10),
          _otherInputItem('旗下/品牌代理', 95, brandController),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(0),
                child: _uploadItem('营业执照', businessLicenseUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(1),
                child: _uploadItem('品牌授权书', brandAuthImageUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(2),
                child: _uploadItem('商标证书', tradeMarkImageUrl),
              ),
            ),
          ]),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  /// 构建企业法人信息模块
  static storeEnterprisePersonView(
      BuildContext context,
      TextEditingController legalNameController,
      TextEditingController legalPhoneController,
      TextEditingController legalAddressController,
      String province,
      String city,
      String area,
      Function(int) selectArea,
      String faceUrl,
      String backUrl,
      Function(int) callback) {
    Widget _inputItem(String hint, TextEditingController controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(width: 1, color: XCColors.invoiceBorderColor)),
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: 13,
            color: XCColors.mainTextColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13, color: XCColors.goodsGrayColor),
          ),
        ),
      );
    }

    Widget _screeningItem(String title) {
      return Container(
        height: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(width: 5),
            Image.asset(
              "assets/images/mine/mine_store_arrow_down.png",
              width: 10,
              height: 5,
            ),
            SizedBox(width: 15),
          ],
        ),
      );
    }

    Widget _uploadItem(String title, String url) {
      return Container(
        height: 65,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          border: Border.all(width: 1, color: XCColors.invoiceBorderColor),
        ),
        child: url.isNotEmpty
            ? CommonWidgets.networkImage(url)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/mine/mine_store_camera.png",
                    width: 36,
                    height: 28,
                  ),
                  SizedBox(height: 4),
                  Text(title,
                      style: TextStyle(
                          fontSize: 11, color: XCColors.goodsGrayColor))
                ],
              ),
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  width: 2, height: 15, color: XCColors.bannerSelectedColor),
              SizedBox(width: 7),
              Text(
                '法人信息',
                style: TextStyle(
                    fontSize: 14,
                    color: XCColors.mainTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          _inputItem('法人姓名', legalNameController),
          SizedBox(height: 10),
          _inputItem('法人手机号码', legalPhoneController),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '所在地',
                    style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(0),
                    child: _screeningItem(province),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(1),
                    child: _screeningItem(city),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => selectArea(2),
                    child: _screeningItem(area),
                  ),
                ),
              ],
            ),
          ),
          _inputItem('街道/小区/门牌号', legalAddressController),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(3),
                child: _uploadItem('身份证正面', faceUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => callback(4),
                child: _uploadItem('身份证反面', backUrl),
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: Container()),
          ]),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
