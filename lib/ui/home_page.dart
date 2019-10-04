import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TodoItem> _items = [
    TodoItem(title: "Eat"),
    TodoItem(title: "Sleep"),
  ];

  TextEditingController _titleController;
  bool _filter;

  Bloc get _bloc => Provider.of<Bloc>(context);

  @override
  void initState() {
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      endDrawer: Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              StreamBuilder<Brightness>(
                  stream: _bloc.brightnessStream,
                  builder: (context, snapshot) {
                    bool isLightMode = snapshot.data == Brightness.light;
                    return InkWell(
                      onTap: _bloc.updateBrightness,
                      child: ListTile(
                        trailing: Icon(isLightMode
                            ? Icons.brightness_2
                            : Icons.brightness_high),
                        title: Text(isLightMode ? "Dark" : "Light"),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _buildNestedView(context),
          flex: 1,
        ),
        _buildBottomContent(context),
      ],
    );
  }

  Widget _buildNestedView(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: _buildAppBar,
        body: _buildBodyContent(context),
      ),
    );
  }

  List<Widget> _buildAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 180.0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0xFF433D82)),
        floating: false,
        elevation: 0,
        pinned: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          centerTitle: true,
          title: Text(""),
          background: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildHelloWidget(context: context, name: 'Human'),
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _buildDateWidget(context: context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildBodyContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 20.0),
          Divider(height: 1),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: _buildTaskTypesWidget(context: context),
          ),
          SizedBox(height: 4.0),
          Divider(height: 1),
          _buildListView(context)
        ],
      ),
    );
  }

  Widget _buildHelloWidget(
      {@required BuildContext context, @required String name}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Hello,',
          style: Theme.of(context).textTheme.display1.copyWith(
                color: Color(0xFF433D82),
                fontSize: 24,
              ),
        ),
        Text(
          '$name',
          style: Theme.of(context).textTheme.display2.copyWith(
                color: Color(0xFF433D82),
                fontWeight: FontWeight.w700,
                fontSize: 48,
              ),
        ),
      ],
    );
  }

  Widget _buildDateWidget({@required BuildContext context}) {
    return RichText(
      text: TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF878695),
        ),
        children: <TextSpan>[
          TextSpan(
            text: DateFormat("EEEEE", "en_US").format(DateTime.now()) + ', ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: DateFormat.yMMMMd("en_US").format(DateTime.now()),
            style: TextStyle(),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTypesWidget({@required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildToggleButton(
          context: context,
          text: "All",
          onPressed: () => updateFilter(null),
          focus: _filter == null,
        ),
        _buildToggleButton(
          context: context,
          text: "Active",
          onPressed: () => updateFilter(true),
          focus: _filter == true,
        ),
        _buildToggleButton(
          context: context,
          text: "Completed",
          onPressed: () => updateFilter(false),
          focus: _filter == false,
        ),
      ],
    );
  }

  void updateFilter(bool filter) => this.setState(() => _filter = filter);

  Widget _buildToggleButton(
      {@required BuildContext context,
      @required String text,
      @required Function() onPressed,
      bool focus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ButtonTheme(
        minWidth: 0,
        child: FlatButton(
          child: Text(text),
          onPressed: onPressed,
          shape: focus
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                  side: BorderSide(color: Colors.grey.shade400))
              : null,
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    List<TodoItem> _items = this
        ._items
        .where(
          (item) => item.isCompleted != _filter,
        )
        .toList();
    return Flexible(
      child: _items.isEmpty
          ? Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(32),
              child: Text(
                "No result found.",
                style: Theme.of(context)
                    .textTheme
                    .subtitle
                    .copyWith(color: Theme.of(context).hintColor),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: _items.length,
              itemBuilder: (context, i) {
                return _buildListTile(
                  context: context,
                  item: _items[i],
                );
              },
            ),
    );
  }

  Widget _buildListTile({@required BuildContext context, TodoItem item}) {
    return InkWell(
      onTap: () {
        this.setState(() => item.isCompleted = !item.isCompleted);
      },
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(0, 2, 0, 2),
        leading: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
          child: Opacity(
            child: Icon(
              Icons.done,
              color: Colors.green,
            ),
            opacity: item.isCompleted ? 1 : 0,
          ),
        ),
        title: Text(
          item.title,
          style: item.isCompleted
              ? TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).disabledColor,
                  decoration: TextDecoration.lineThrough,
                )
              : TextStyle(
                  fontSize: 22,
                ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.red,
          ),
          onPressed: () {
            this.setState(() => _items.remove(item));
          },
        ),
      ),
    );
  }

  Widget _buildBottomContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)]),
      child: Column(
        children: <Widget>[
          _buildListInfo(context),
          Divider(height: 1),
          _buildAddForm(context),
        ],
      ),
    );
  }

  Widget _buildListInfo(BuildContext context) {
    int activeCount = _items.where((item) => !item.isCompleted).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 8, 4),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "$activeCount item${activeCount > 1 ? "s" : ""} left",
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.grey),
            ),
          ),
          ButtonTheme(
            minWidth: 0,
            child: FlatButton(
              child: Text(
                "Clear completed",
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.grey),
              ),
              onPressed: () {
                this.setState(
                  () => _items.removeWhere((item) => item.isCompleted),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddForm(BuildContext context) {
    InputBorder border =
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            child: TextFormField(
              controller: _titleController,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                  hintText: "What needs to be done?",
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                  contentPadding: EdgeInsets.fromLTRB(
                      24, 4, 16, MediaQuery.of(context).padding.bottom)),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0)),
          child: MaterialButton(
            height: 75.0 + MediaQuery.of(context).padding.bottom,
            minWidth: 65.0,
            child: Icon(Icons.add, color: Colors.white),
            color: Color(0xFFFF4954),
            onPressed: addTodo,
          ),
        ),
      ],
    );
  }

  void addTodo() {
    if (_titleController.text.isNotEmpty) {
      this.setState(
        () => _items.add(
          TodoItem(
            title: _titleController.text,
          ),
        ),
      );
      _titleController.clear();
    }
  }
}

class TodoItem {
  String title;
  bool isCompleted;
  TodoItem({@required this.title, this.isCompleted = false});
}
