import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.0,
      automaticallyImplyLeading: false,
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      floating: false,
      elevation: 0,
      pinned: false,
      backgroundColor: Theme.of(context).canvasColor,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        centerTitle: false,
        title: Text(
          "",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
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
                color: Theme.of(context).primaryColor,
                fontSize: 24,
              ),
        ),
        Text(
          '$name',
          style: Theme.of(context).textTheme.display2.copyWith(
                color: Theme.of(context).primaryColor,
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
}
