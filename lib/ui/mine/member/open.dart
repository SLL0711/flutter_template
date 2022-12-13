import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/mine/member/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/member/pay.dart';

import '../../../api.dart';
import '../../../http.dart';
import '../../../toast.dart';

class OpenMemberScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OpenMemberScreenState();
}

class OpenMemberScreenState extends State<OpenMemberScreen>
    with AutomaticKeepAliveClientMixin {
  OpenMemberEntity _entity = OpenMemberEntity();
  bool _isOpen = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _requestData();
    });
    super.initState();
  }

  void _requestData() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.openMember,
      context,
      params: {'memberType': 1},
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = OpenMemberEntity.fromJson(http.data);
        _isOpen = false;
      });
    } else {
      ToastHud.show(context, http.message!);
      _isOpen = true;
    }
  }

  void _backTap() {
    Navigator.pop(context);
  }

  void _goPay() {
    // 支付
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PayMemberScreen(_entity))).then(
      (value) => {
        setState(
          () {
            if (value == null) {
              _isOpen = false;
            } else {
              _isOpen = true;
            }
          },
        )
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: _backTap,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip);
          },
        ),
        title: Text(
          '会员介绍',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.black,
                child: Image.asset(
                  'assets/images/mine/img_member.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _isOpen
              ? SizedBox()
              : GestureDetector(
                  onTap: _goPay,
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/mine/ic_open_member.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          right: 0,
                          bottom: 10,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              '加入雀斑会员（¥298）',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFA4724F),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
