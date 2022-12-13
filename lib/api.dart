class DsApi {
  /// 正式环境
  // static const String server_address = "https://api.xiaoqingyan.com/api/v1.0";

  /// 测试环境
  static const String server_address = "http://api.quebanvip.com/api/v1.0";

  /// 本地环境
  // static const String server_address = "http://192.168.31.20:8085";

  /// 分享链接
  static const String share_url = "https://download-app.quebanvip.com/#/";

  /// 登录
  static const String login = "/api/z/login/phoneLogin";

  /// 微信登录
  static const String wechatLogin = "/api/z/login/wxLogin";

  /// 微信登录绑定手机号
  static const String wechatBindPhone = "/api/z/login/bindPhone";

  /// 获取验证码
  static const String code = "/sms/sendSms";

  /// 用户信息
  static const String userInfo = "/member/getMemberDetail";

  /// 个人中心信息
  static const String personInfo = "/member/myCenter";

  /// 完善会员资料
  static const String saveInfo = "/member/perfectMemberDetail";

  /// 修改会员信息
  static const String changeInfo = "/member/updateMemberDetail";

  /// 我的好友
  static const String teamInfo = "/member/myTeam";

  /// banner
  static const String banner = "/api/z/advertise/getByType";

  /// 粉丝
  static const String fans = "/memberAttention/myFansOrAttention";

  /// 关注或取消
  static const String followOrCancel = "/memberAttention/followOrCancel";

  /// 类别
  static const String tab = "/api/z/category/list/withChildren";

  /// 商品列表
  static const String productList = "/product/list";

  /// 上传图片签名
  static const String ocsSign = "/ocs/sign";

  /// 区域
  static const String area = "/api/z/area/api/z/area/getArea";

  /// 商家
  static const String org = "/api/z/org/orgList";

  /// 商家类型
  static const String orgType = "/api/z/org/orgTypeList";

  /// 商品详情
  static const String productDetail = "/product/detail/";

  /// 购物车
  static const String shoppingCart = "/cart/cartItem";

  /// 猜你喜欢
  static const String guessYouLike = "/product/guessYouLike";

  /// 商品套餐
  static const String productSku = "/product/productSku/";

  /// 商品详情下面的详情
  static const String productChildren = "/product/productDetail/";

  /// 立即购买-展示接口
  static const String productOrder = "/order/initOrder/";

  /// 确认订单
  static const String createOrder = "/order/createOrder";

  /// 支付
  static const String pay = "/pay/getPayParam";

  /// 确认订单
  static const String orderList = "/order/orderPageList";

  /// 开通会员
  static const String openMember = "/memberBuyVipRecord/joinMembership";

  /// 订单详情
  static const String orderDetail = "/order/orderDetail/";

  /// 取消订单
  static const String cancelOrder = "/order/cancelOrder";

  /// 退款
  static const String refundOrder = "/order/refundApplication";

  /// 尾款展示
  static const String finalPaymentShow = "/order/finalPaymentShow/";

  /// 尾款确定
  static const String finalPayment = "/order/finalPayment/";

  /// 生成核销码
  static const String cancelCode = "/order/generateVerificationCode/";

  /// 收藏
  static const String collect = "/collect/collect";

  /// 收藏列表
  static const String collectList = "/collect/collect/";

  /// 商品咨询师列表
  static const String doctorProduct = "/api/z/doctor/productDoctorList/";

  /// 咨询师详情
  static const String doctorDetail = "/api/z/doctor/detail/";

  /// 咨询师商品
  static const String doctorGoods = "/product/doctorProduct/";

  /// 咨询师商品顶部数据
  static const String doctorGoodsTop = "/product/doctorProductTop/";

  /// 咨询师的预约
  static const String doctorReserve = "/product/reserveList";

  /// 海报图列表
  static const String posterList = "/shareImage/list";

  /// 文章内容
  static const String article = "/api/z/article/queryByArticleCode/";

  /// 日记分类
  static const String diaryCategory = "/diary/diaryBookOrderCategory";

  /// 日记列表
  static const String diaryList = "/diary/diaryList";

  /// 日记详情
  static const String diaryDetail = "/diaryDetail/detail";

  /// 入驻申请
  static const String joinApply = "/shop/shopApply";

  /// 获取用户入驻信息
  static const String applyInfo = "/shop/shopApplyInfo";

  static const String joinInfo = "/shop/shopApplyInfo";

  /// 商家详情
  static const String orgDetail = "/api/z/org/details/";

  /// 商家咨询师列表
  static const String orgDoctorList = "/api/z/doctor/list/";

  /// 注销
  static const String logout = "/member/logout";

  /// 修改手机号
  static const String modifyMemberPhoneNumber =
      "/member/modifyMemberPhoneNumber";

  /// 意见反馈
  static const String opinion = "/oms/opinion/add";

  /// 版本控制
  static const String getNewestVersion =
      "/api/z/version/appVersionNumber/getNewestVersion";

  /// 收获地址
  static const String addressList = "/member/address/list";

  /// 添加收获地址
  static const String addressAdd = "/member/address/add";

  /// 删除收获地址
  static const String addressDelete = "/member/address/delete/";

  /// 修改收获地址
  static const String addressChange = "/member/address/update/";

  /// 签到列表
  static const String signList = "/sign/list";

  /// 签到
  static const String memberSign = "/sign/memberSign";

  /// 券列表
  static const String couponList = "/member/coupon/list";

  /// 体验券列表
  static const String experienceList = "/member/coupon/experienceVoucherList";

  /// 热力值兑换
  static const String powerExchange = "/heating/power/values";

  /// 详情页的评价基本信息
  static const String commentBasicInfo = "/api/y/comment/z/basicInfo/";

  /// 详情页的评价
  static const String commentList = "/api/y/comment/z/list/";

  /// 医生评价列表
  static const String doctorCommentList = "/api/y/comment/z/doctorCommentList/";

  /// 通知列表
  static const String noticeList = "/notice/noticeList";

  /// 会员等级列表
  static const String memberLevelList = "/member/level/list";

  /// 日记创建和编辑
  static const String createOrUpdate = "/diary/createOrUpdate";

  /// 添加或者编辑日志
  static const String addOrUpdate = "/diaryDetail/addOrUpdate";

  /// 日记本详情
  static const String diaryBookDetail = "/diary/diaryBookDetail";

  /// 删除日记本
  static const String deleteDiaryBook = "/diary/deleteDiaryBook";

  /// 足迹
  static const String footprintList = "/footprint/list";

  /// 评论详情
  static const String commentDetails = "/api/y/comment/z/commentDetails/";

  /// 评论列表
  static const String commentDetailList = "/api/y/comment/z/commentList/";

  /// 点赞
  static const String commentPraise = "/api/y/comment/commentReplayPraise/";

  /// 回复
  static const String releaseCommentReplay =
      "/api/y/comment/releaseCommentReplay";

  /// 举报
  static const String report = "/member/report/add";

  /// 订单评价发布
  static const String commentRelease = "/api/y/comment/release";

  /// 系统配置
  static const String configParams = "/api/z/sys/getDetail";

  /// 颜值金数据
  static const String beautyBalanceDetail = "/account/beautyBalanceDetail";

  /// 颜值金提现
  static const String withdraw = "/withdraw/withdraw";

  /// 颜值金明细
  static const String beautyBalanceList = "/account/beautyBalanceList";

  /// 是否上架版本
  static const String versionConfig = "/api/z/sys/isItTheListedVersion";

  /// 消息推送
  static const String publishPush = "/notice/publishPush";

  /// 咨询医生列表
  static const String videoList = "/api/z/doctor/pageList";

  /// 添加咨询订单
  static const String addVideoOrder = "/consult/doctor/order/add";

  /// 咨询订单列表
  static const String videoOrderList = "/consult/doctor/order/pageList";

  /// 咨询订单修改
  static const String videoOrderUpdate = "/consult/doctor/order/update/";

  /// 咨询状态修改
  static const String consultStatus = "/api/z/doctor/consultStatus/";

  /// 标签列表
  static const String tagList = "/sms/tag/api/z/all/list";

  /// 医生关注
  static const String focusDoctor = "/member/doctor/attention/followOrCancel";

  /// 参团列表
  static const String openGroupList = "/group/team/list";

  /// 日记评论列表
  static const String diaryCommentList = "/diaryComment/list";

  /// 日记评论
  static const String diaryComment = "/diaryComment/comment";

  /// 点赞日记评论
  static const String praiseDiaryComment = "/diaryComment/likeDiaryComment";

  /// 我的发票信息
  static const String myInvoice = "/member/invoice/queryPageList";

  /// 添加发票信息
  static const String addInvoice = "/member/invoice/save";

  /// 修改发票信息
  static const String updateInvoice = "/member/invoice/update";

  /// 发票申请
  static const String applyInvoice = "/order/invoiceApplication/";

  /// 咨询等待时长
  static const String consultWaitingTime =
      "/consult/doctor/order/judgmentWaitingTime";

  /// 医生商品列表
  static const String doctorGoodsList = "/product/doctorProduct/";

  /// 热力值配置列表
  static const String shareConfigList = "/api/z/heating/powers";
}
