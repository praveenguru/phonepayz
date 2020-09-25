import 'package:flutter/cupertino.dart';

enum ViewState {
  Content,
  Loading,
  Error,
  Empty
}


class MultiStateView extends StatelessWidget {

  final ViewState state;
  final Widget contentView,loaderView,emptyView,errorView;

  MultiStateView({
    @required this.state,
    @required this.contentView,
    this.errorView,
    this.emptyView,
    this.loaderView
  });

  Widget _getView(){
    switch (state) {
      case ViewState.Empty:
        return emptyView??Text("No Empty View Provided");
      case ViewState.Loading:
        return loaderView??Text("No Loading View Provided");
      case ViewState.Error:
        return errorView??Text("No Error View Provided");
      default:
        return contentView;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getView();
  }
}