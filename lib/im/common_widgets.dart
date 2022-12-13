import 'package:flustars/flustars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screen_util;

/// 屏幕宽度
double sWidth(double w) {
  return screen_util.ScreenUtil().setWidth(w);
}

/// 屏幕高度
double sHeight(double h) {
  return screen_util.ScreenUtil().setHeight(h);
}

/// 屏幕字体
double sFontSize(double size) {
  return screen_util.ScreenUtil().setSp(size);
}

/// 根据毫秒返回时间Str
String timeStrByMs(int ms, {bool showTime = false}) {
  String ret = '';
  // 是否当天
  // HH:mm
  if (DateUtil.isToday(ms)) {
    ret = DateUtil.formatDateMs(ms, format: 'HH:mm');
  }
  // // 是否本周
  // // 周一、周二、周三...
  // else if (DateUtil.isWeek(ms)) {
  //   ret = DateUtil.getWeekdayByMs(ms);
  // }

  // 是否本年
  // MM/dd
  else if (DateUtil.yearIsEqualByMs(ms, DateUtil.getNowDateMs())) {
    if (showTime) {
      ret = DateUtil.formatDateMs(ms, format: 'MM月dd日 HH:mm');
    } else {
      ret = DateUtil.formatDateMs(ms, format: 'MM月dd日');
    }
  }
  // yyyy/MM/dd
  else {
    if (showTime) {
      ret = DateUtil.formatDateMs(ms, format: 'yyyy年MM月dd日 HH:mm');
    } else {
      ret = DateUtil.formatDateMs(ms, format: 'yyyy年MM月dd日');
    }
  }

  return ret;
}

/// 时间转换string
