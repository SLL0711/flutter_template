import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class ChangeNicknameScreen extends StatefulWidget {
  final String name;

  ChangeNicknameScreen(this.name);

  @override
  State<StatefulWidget> createState() => ChangeNicknameScreenState();
}

class ChangeNicknameScreenState extends State<ChangeNicknameScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  TextEditingController _nameTextController = TextEditingController();
  bool _isSave = false;

  @override
  void dispose() {
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _nameTextController.text = widget.name;
    _nameTextController.addListener(() {
      setState(() {
        _isSave = _nameTextController.text.isNotEmpty;
      });
    });
  }

  // 保存信息
  void _saveInfo() async {
    if (!_isSave) return;
    FocusScope.of(context).requestFocus(FocusNode());

    Map<String, String> params = Map();
    params['nickName'] = _nameTextController.text;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.changeInfo, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '保存成功');
      Navigator.pop(context, _nameTextController.text);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _clearText() {
    _nameTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '修改昵称', () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: double.infinity,
                    child: TextField(
                      controller: _nameTextController,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14, color: XCColors.tabNormalColor),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入昵称',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: XCColors.tabNormalColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: !_isSave,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _clearText,
                    child: Container(
                      width: 30,
                      height: double.infinity,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          CommonWidgets.checkButton('保存', _isSave, _saveInfo)
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
