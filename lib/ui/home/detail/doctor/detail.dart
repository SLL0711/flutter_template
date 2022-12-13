import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/case.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/doctor_info.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/goods.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/subscribe.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/comment_list.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';

class DoctorDetailScreen extends StatefulWidget {
  final int id;

  DoctorDetailScreen(this.id);

  @override
  State<StatefulWidget> createState() => DoctorDetailScreenState();
}

class DoctorDetailScreenState extends State<DoctorDetailScreen>
    with AutomaticKeepAliveClientMixin {
  DoctorItemEntity _entity = DoctorItemEntity();
  List<ProductItemEntity> _goodsList = <ProductItemEntity>[];
  List<DiaryItemEntity> _diaryList = <DiaryItemEntity>[];
  List<CommentItemEntity> _commentList = <CommentItemEntity>[];
  int _totalGoods = 0, _totalDiary = 0, _totalComment = 0;
  bool _isGrounding = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestInfo();
    _requestGoodsInfo();
    _requestDiaryInfo();
  }

  void _requestInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.doctorDetail + widget.id.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = DoctorItemEntity.fromJson(http.data);
        _requestCommentInfo();
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestGoodsInfo() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '3';
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.doctorGoods + widget.id.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ProductEntity entity = ProductEntity.fromJson(http.data);
      setState(() {
        _goodsList.addAll(entity.list);
        _totalGoods = entity.total;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestDiaryInfo() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '2';
    params['doctorId'] = widget.id;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.diaryList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      DiaryEntity entity = DiaryEntity.fromJson(http.data);
      setState(() {
        _diaryList.addAll(entity.list);
        _totalDiary = entity.total;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestCommentInfo() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '2';
    params['doctorId'] = widget.id;
    params['name'] = _entity.name;

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.doctorCommentList + widget.id.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      CommentEntity entity = CommentEntity.fromJson(http.data);
      setState(() {
        _commentList.addAll(entity.list);
        _totalComment = entity.total;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _pushDoctorInfo(int type) {
    NavigatorUtil.pushPage(context, DoctorDetailInfoScreen(type, _entity));
  }

  void _pushGoodsInfo() {
    NavigatorUtil.pushPage(context, DoctorGoodsView(widget.id));
  }

  void _pushCaseInfo(int type) {
    if (type == 0) {
      NavigatorUtil.pushPage(context, DoctorSubscribeView(widget.id));
    } else {
      NavigatorUtil.pushPage(context, DoctorCaseView(widget.id));
    }
  }

  void _pushDiaryInfo() {
    NavigatorUtil.pushPage(context, DoctorCaseView(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(
        context,
        _isGrounding ? '技师首页' : '咨询师首页',
        () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DoctorWidgets.doctorDetailInfo(
              context,
              _entity,
              _isGrounding,
              _pushCaseInfo,
            ),
            SizedBox(height: 10),
            DoctorWidgets.doctorInfo(
              context,
              _isGrounding,
              _pushDoctorInfo,
            ),
            SizedBox(height: 10),
            DoctorWidgets.doctorAddressInfo(context, _entity),
            _goodsList.isEmpty ? Container() : SizedBox(height: 10),
            _goodsList.isEmpty
                ? Container()
                : DoctorWidgets.doctorGoodsInfo(
                    context,
                    _goodsList,
                    _totalGoods,
                    _pushGoodsInfo,
                  ),
            _diaryList.isEmpty ? Container() : SizedBox(height: 10),
            _diaryList.isEmpty
                ? Container()
                : DoctorWidgets.doctorDiaryInfo(
                    context,
                    _diaryList,
                    _totalDiary,
                    _pushDiaryInfo,
                  ),
            SizedBox(height: 10),
            _commentList.isEmpty
                ? Container()
                : DoctorWidgets.doctorEvaluationInfo(
                    context,
                    _commentList,
                    _totalComment,
                    () {
                      NavigatorUtil.pushPage(
                        context,
                        CommentListScreen(_entity.id, _entity.name),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
