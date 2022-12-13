import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/login/article.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/account/account.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/address/address.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/widgets.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

import '../../../event_center.dart';
import '../../../navigator.dart';
import '../../../user.dart';
import 'about.dart';
import 'contact.dart';
import 'feedback.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen>
    with AutomaticKeepAliveClientMixin {
  String _cacheSize = '0M';
  String _version = '1.0.0';
  bool _isLogin = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isLogin = await UserManager.isLogin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    loadCache();
  }

  void _checkVersion() async {
    Map<String, String> params = Map();
    params['type'] = Platform.isAndroid
        ? '0'
        : Platform.isIOS
            ? '1'
            : '2';
    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.getNewestVersion, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (http.data == null) {
        ToastHud.show(context, '已是最新版本');
      } else {
        VersionEntity entity = VersionEntity.fromJson(http.data);
        SettingDialog.showVersionTip(context, entity);
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '设置', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            SettingWidgets.settingItem('账号与安全', onTap: () {
              NavigatorUtil.pushPage(
                context,
                AccountScreen(),
              );
            }),
            SettingWidgets.settingItem('收货地址', onTap: () {
              NavigatorUtil.pushPage(
                context,
                AddressScreen(),
              );
            }),
            SettingWidgets.settingItem('意见反馈', onTap: () {
              NavigatorUtil.pushPage(
                context,
                FeedbackScreen(),
              );
            }),
            SettingWidgets.settingItem('联系我们', onTap: () {
              NavigatorUtil.pushPage(
                context,
                ContactScreen(),
                needLogin: false,
              );
            }),
            /*SettingWidgets.settingItem('客服热线',
                value: '400-602-5168', onTap: () {}),
            SettingWidgets.settingItem('去App Store评分', onTap: () {}),*/
            SettingWidgets.settingItem('关于我们', onTap: () {
              NavigatorUtil.pushPage(
                context,
                AboutScreen(),
                needLogin: false,
              );
            }),
            SettingWidgets.settingItem('服务协议', onTap: () {
              NavigatorUtil.pushPage(
                context,
                ArticleScreen('asdessaea'),
                needLogin: false,
              );
            }),
            SettingWidgets.settingItem('隐私政策', onTap: () {
              NavigatorUtil.pushPage(
                context,
                ArticleScreen('sqafqm4bm'),
                needLogin: false,
              );
            }),
            SizedBox(height: 10),
            SettingWidgets.settingItem('清除缓存', value: _cacheSize, onTap: () {
              ToastHud.loading(context);
              Future.delayed(Duration(milliseconds: 2000)).then((e) {
                ToastHud.dismiss();
                _clearCache();
              });
            }),
            SettingWidgets.settingItem(
              '检查更新',
              value: '当前版本V$_version',
              onTap: _checkVersion,
            ),
            SizedBox(height: 20),
            Offstage(
              offstage: !_isLogin,
              child: GestureDetector(
                onTap: _logoutDialog,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XCColors.themeColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Text(
                    '退出当前账号',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logoutDialog() async {
    SettingDialog.showLogoutDialog(context).then(
      (value) async {
        if (value ?? false) {
          ToastHud.show(context, '退出成功');
          // IM退出
          await EMClient.getInstance.logout(true);
          EventCenter.defaultCenter().fire(LogoutEvent(0));
          Navigator.of(context).pop();
        }
      },
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;

  ///加载缓存
  Future<Null> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      setState(() {
        _cacheSize = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children.isNotEmpty)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void _clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await loadCache();
      ToastHud.show(context, '清除成功');
      setState(() {
        _cacheSize = '0M';
      });
    } catch (e) {
      print(e);
      ToastHud.show(context, '清除失败');
    }
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  _renderSize(double value) {
    if (value.isNaN) {
      return 0;
    }
    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
