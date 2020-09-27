import 'package:FL_Foreman/apis/foreman_api.dart';
import 'package:FL_Foreman/common/global.dart';
import 'package:FL_Foreman/common/toast_utils.dart';
import 'package:FL_Foreman/models/foreman_model.dart';
import 'package:FL_Foreman/res/text_styles.dart';
import 'package:FL_Foreman/widget/float_action.dart';
import 'package:FL_Foreman/widget/foreman_item.dart';
import 'package:FL_Foreman/widget/list_content.dart';
import 'package:FL_Foreman/widget/state_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ForemanList extends StatefulWidget {
  ForemanList({Key key}) : super(key: key);

  @override
  _ForemanListState createState() => _ForemanListState();
}

class _ForemanListState extends State<ForemanList> with AutomaticKeepAliveClientMixin {
  RefreshController refreshController;
  List<Foreman> list = [];
  int pageNum = 1;
  int pageSize = 5;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    refreshController = RefreshController();
    refresh();
  }

  getList() {
    return ForemanApi.getForemanList(pageNum: pageNum, pageSize: pageSize);
  }

  refresh() async {
    refreshController.resetNoData();
    pageNum = 1;
    final res = await getList();
    if (mounted) {
      setState(() {
        list = res;
        loading = false;
      });
    }
    if (res.length == 0) {
      refreshController.loadNoData();
    }
    refreshController.refreshCompleted();
  }

  loadMore() async {
    pageNum++;
    final res = await getList();
    setState(() {
      list = list + res;
    });
    if (res.length < pageSize) {
      return refreshController.loadNoData();
    }
    refreshController.loadComplete();
  }

  addForeman() async {
    final user = await Global.scanQrcode(context);
    if (user.type != 3) return ToastUtils.showLong('请扫描服务商二维码');
    if (user.id == Global.userId) return ToastUtils.showLong('不能绑定自己');
    final res = await ForemanApi.addForeman(user.id);
    if (res['code'] == 200) getList();
    ToastUtils.showLong(res['message']);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Wrap(
          children: [
            ForemanItemShimmer(),
            ForemanItemShimmer(),
            ForemanItemShimmer(),
            ForemanItemShimmer(),
            ForemanItemShimmer(),
          ],
        ),
      );
    }
    return Stack(
      children: [
        SmartRefresher(
          enablePullUp: list.length >= pageSize,
          header: WaterDropHeader(
            complete: Text('刷新成功！'),
            refresh: CupertinoActivityIndicator(),
          ),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("上拉加载更多");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("加载失败");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("松开加载");
              } else {
                body = Text("没有更多数据");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          onRefresh: () => refresh(),
          onLoading: () => loadMore(),
          controller: refreshController,
          child: ListContent(
            itemBuilder: (context, index) {
              return ForemanItem(
                info: list[index],
              );
            },
            itemCount: list.length,
            emptyText: "暂时没有内容～",
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: FloatAction(
              onAdd: () => addForeman(),
              onSearch: () => showSearch(
                context: context,
                delegate: ForemanSearchDelegate(),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ForemanSearchDelegate extends SearchDelegate {
  List<String> suggestions = [];

  @override
  String get searchFieldLabel => '请输入工头名字、电话';

  @override
  TextStyle get searchFieldStyle => TextStyle(fontSize: 16);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.search,
        ),
        onPressed: () {
          showResults(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: ForemanApi.getForemanList(keyWord: query),
      builder: (BuildContext context, AsyncSnapshot<List<Foreman>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.length == 0) {
          return StateLayout(
            type: StateType.empty,
            hintText: '没有查询到数据',
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ForemanItem(
                info: snapshot.data[index],
              );
            },
            itemCount: snapshot.data.length,
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filterSuggestions = suggestions.where((f) => f.contains(query)).toList();
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            filterSuggestions[index],
            style: TextStyles.black_14,
          ),
          onTap: () {
            query = filterSuggestions[index];
            this.showResults(context);
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 1,
        );
      },
      itemCount: filterSuggestions.length,
    );
  }
}
