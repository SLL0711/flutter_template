import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/im/contact_model.dart';
import 'package:flutter_medical_beauty/ui/home/message/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../../../../colors.dart';

class ChatTabBarView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatTabBarViewState();
}

class ChatTabBarViewState extends State<ChatTabBarView> {
  List<ContactModel> _contactList = [];
  List<EMConversation> _conversationsList = [];

  @override
  void initState() {
    super.initState();

    _reLoadAllConversations();
  }

  Future<void> _fetchContactsFromServer() async {
    try {
      //TODO:Leo:EMContact type remove
      List<String> contacts =
          await EMClient.getInstance.contactManager.getAllContactsFromServer();

      setState(() {
        _contactList.clear();
        for (var contact in contacts) {
          _contactList.add(ContactModel.contact(contact));
        }
      });
      print('获取成功');
    } on EMError {
      print('获取失败');
      // SmartDialog.showToast('获取失败');
      // _loadLocalContacts();
    } finally {
      // SuspensionUtil.sortListBySuspensionTag(_contactList);
      // SuspensionUtil.setShowSuspensionStatus(_contactList);
      // _contactList.insertAll(0, _topList);
      // setState(() {});
    }
  }

  /// 更新会话列表
  void _reLoadAllConversations() async {
    try {
      List<EMConversation> list =
          await EMClient.getInstance.chatManager.loadAllConversations();
      _conversationsList.clear();
      setState(() {
        _conversationsList.addAll(list);
      });
    } on Error {
      // _refreshController.refreshFailed();
    } finally {
      setState(() {});
    }
  }

  // _contactDidSelected(ContactModel contact) async {
  //   EMConversation conv = await EMClient.getInstance.chatManager
  //       .getConversation(contact.contactId);
  //   if (conv == null) {
  //     print('会话创建失败');
  //     return;
  //   }
  //   Navigator.of(context).pushNamed(
  //     '/chat',
  //     arguments: [contact.contactId, conv],
  //   ).then((value) {
  //     // eventBus.fire(EventBusManager.updateConversations());
  //   });
  // }

  _contactDidSelected(EMConversation conv) async {
    if (conv == null) {
      print('会话创建失败');
      return;
    }
    Navigator.of(context).pushNamed(
      '/chat',
      arguments: [conv.name, conv],
    ).then((value) {
      // eventBus.fire(EventBusManager.updateConversations());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _conversationsList.isEmpty
            ? EmptyWidgets.dataEmptyView(context)
            : ListView.builder(
                itemCount: _conversationsList.length,
                itemBuilder: (context, index) {
                  EMConversation model = _conversationsList[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _contactDidSelected(_conversationsList[index]);
                    },
                    child: MessageWidgets.chatItem(context, _conversationsList[index]),
                  );
                },
              ));
  }

// var notifier;
// @override
// void initState() {
//   super.initState();
//
//   // _loginAction();
//   _fetchContactsFromServer();
//   // _reLoadAllConversations();
// }
//
// void dispose() {
//   // 移除环信回调监听
//   EMClient.getInstance.chatManager.removeListener(this);
//   notifier.cancel();
//   super.dispose();
// }
//
// void _loginAction() async {
//   String username = '1';
//   String passwd = '123456';
//
//   try {
//     await EMClient.getInstance.login(username, passwd);
//     print('成功');
//     _reLoadAllConversations();
//   } on EMError catch (e) {
//     print('失败');
//     _reLoadAllConversations();
//   } finally {
//   }
// }
//
// /// 更新会话列表
// void _reLoadAllConversations() async {
//   try {
//     List<EMConversation> list = await EMClient.getInstance.chatManager.loadAllConversations();
//     _conversationsList.clear();
//     _conversationsList.addAll(list);
//     print('list = $list');
//     num count = 0;
//     for (var conv in _conversationsList) {
//       count += conv.unreadCount;
//     }
//     print('count = $count');
//   } on Error {
//
//   } finally {
//     setState(() {});
//   }
// }
//
// Future<void> _fetchContactsFromServer() async {
//   try {
//     List<EMContact> contacts =
//     await EMClient.getInstance.contactManager.getAllContactsFromServer();
//     _contactList.clear();
//
//     print('list = $contacts');
//     // for (var contact in contacts) {
//     //   _contactList.add(ContactModel.contact(contact));
//     // }
//   } on EMError {
//     // SmartDialog.showToast('获取失败');
//     // _loadLocalContacts();
//   } finally {
//     // SuspensionUtil.sortListBySuspensionTag(_contactList);
//     // SuspensionUtil.setShowSuspensionStatus(_contactList);
//     // _contactList.insertAll(0, _topList);
//     // setState(() {});
//   }
// }
//
// @override
// Widget build(BuildContext context) {
//
//   return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Container(height: 10, color: XCColors.homeDividerColor),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return MessageWidgets.chatItem(context);
//               },
//             ),
//           )
//         ],
//       ));
// }
//
// @override
// onCmdMessagesReceived(List<EMMessage> messages) {}
//
// @override
// onMessagesDelivered(List<EMMessage> messages) {}
//
// @override
// onMessagesRead(List<EMMessage> messages) {
//   bool needReload = false;
//   for (var msg in messages) {
//     if (msg.to == EMClient.getInstance.currentUsername) {
//       needReload = true;
//       break;
//     }
//   }
//   if (needReload) {
//     _reLoadAllConversations();
//   }
// }
//
// @override
// onMessagesRecalled(List<EMMessage> messages) {}
//
// @override
// onMessagesReceived(List<EMMessage> messages) {
//   _reLoadAllConversations();
// }
//
// @override
// onConversationsUpdate() {}
//
// @override
// onConversationRead(String from, String to) {}
}
