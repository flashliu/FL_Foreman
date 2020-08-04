import 'package:FL_Foreman/providers/user_provider.dart';
import 'package:FL_Foreman/widget/message_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MessageList extends StatefulWidget {
  MessageList({Key key}) : super(key: key);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  RefreshController refreshController = RefreshController();
  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final list = userProvider.messageList;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.chevron_left),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('消息'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SmartRefresher(
          controller: refreshController,
          onRefresh: () async {
            await userProvider.getMessageList();
            refreshController.refreshCompleted();
          },
          header: WaterDropHeader(
            complete: Text('刷新成功！'),
            refresh: CupertinoActivityIndicator(),
          ),
          footer: ClassicFooter(),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return MessageItem(
                info: list[index],
                onTap: () => userProvider.readMessage(list[index].id),
              );
            },
            itemCount: list.length,
          ),
        ),
      ),
    );
  }
}
