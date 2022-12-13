import 'package:event_bus/event_bus.dart';

class EventCenter extends EventBus {
  static EventCenter? _instance;

  EventCenter._();

  static EventCenter defaultCenter() {
    if (_instance == null) {
      _instance = EventCenter._();
    }
    return _instance!;
  }
}

/// 隐私事件
class AgreePrivacyEvent {
  String result = '';

  AgreePrivacyEvent(String result) {
    this.result = result;
  }
}

/// 搜索城市结果传值
class AddressEvent {
  String result = '';

  AddressEvent(String result) {
    this.result = result;
  }
}

/// 刷新个人界面
class RefreshMineEvent {
  String result = '';

  RefreshMineEvent(String result) {
    this.result = result;
  }
}

/// 刷新商品界面
class RefreshProductEvent {
  int result = 0;

  RefreshProductEvent(int result) {
    this.result = result;
  }
}

/// 刷新分类界面
class RefreshCategoryEvent {
  int result = 0;

  RefreshCategoryEvent(int result) {
    this.result = result;
  }
}

/// 刷新订单界面
class RefreshOrderEvent {
  int result = 0;

  RefreshOrderEvent(int result) {
    this.result = result;
  }
}

/// 刷新购物车界面
class RefreshShoppingCartEvent {
  String event = '';

  RefreshShoppingCartEvent(String event) {
    this.event = event;
  }
}

/// 刷新分类界面
class PushTabEvent {
  int result = 0;

  PushTabEvent(int result) {
    this.result = result;
  }
}

/// 退出登录
class LogoutEvent {
  int result = 0;

  LogoutEvent(int result) {
    this.result = result;
  }
}

/// 刷新咨询事件
class RefreshConsultEvent {
  int type = 0;
  int value = -1;

  RefreshConsultEvent(int type, int value) {
    this.type = type;
    this.value = value;
  }
}

/// 咨询事件
class ConsultEvent {
  int type = 0;

  ConsultEvent(int type) {
    this.type = type;
  }
}

/// 刷新收藏
class RefreshCollectionEvent {
  int type = 0;

  RefreshCollectionEvent(int type) {
    this.type = type;
  }
}

/// 刷新日记
class RefreshDiaryEvent {
  int type = 0;

  RefreshDiaryEvent(int type) {
    this.type = type;
  }
}
