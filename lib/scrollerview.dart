library scrollerview;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScrollerView extends StatefulWidget {
  final Widget child;
  final ScrollController horizontalcontroller;
  final ScrollController verticalcontroller;

  ScrollerView({Key key, @required this.child, final ScrollController Verticalcontroller, final ScrollController Horizontalcontroller})
      : verticalcontroller = Verticalcontroller ?? ScrollController(),
        horizontalcontroller = Horizontalcontroller ?? ScrollController(),
        super(key: key);

  @override
  _ScrollerViewState createState() => _ScrollerViewState();
}

class _ScrollerViewState extends State<ScrollerView> {
  ScrollController horizontalcontroller;
  ScrollController verticalcontroller;
  double widthparent;
  double widthchild;
  double widthscrollbar;
  double heightparent;
  double heightchild;
  double heightscrollbar;
  double horizontal;
  double vertical;
  double height;
  double width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    horizontalcontroller = widget.horizontalcontroller;
    verticalcontroller = widget.verticalcontroller;
    horizontalcontroller.addListener(() {
      horizontal = horizontalcontroller.position.pixels * widthparent / widthchild;
      setState(() {});
    });
    verticalcontroller.addListener(() {
      vertical = verticalcontroller.position.pixels * heightparent / heightchild;
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant ScrollerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    widthparent = 1;
    widthchild = 1;
    heightparent = 1;
    heightchild = 1;
    horizontal = 0;
    vertical = 0;
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      postFrameCallback();
      if (widthscrollbar != widthparent * widthparent / widthchild || heightscrollbar != heightparent * heightparent / heightchild) {
        setState(() {});
      }
    });
    widthscrollbar = widthparent * widthparent / widthchild;
    heightscrollbar = heightparent * heightparent / heightchild;
    return Stack(
      children: [
        LayoutBuilder(builder: (context1, constains) {
          build(context);
          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            controller: horizontalcontroller,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: verticalcontroller,
              child: widget.child,
            ),
          );
        }),
        Visibility(
          visible: !(widthscrollbar == widthparent),
          child: GestureDetector(
            onHorizontalDragUpdate: (de) {
              setState(() {});
              if (horizontal + de.delta.dx <= 0) {
                horizontalcontroller.jumpTo(0);
              } else if (horizontal + de.delta.dx <= widthparent - widthscrollbar) {
                horizontalcontroller.jumpTo((horizontal + de.delta.dx) * widthchild / widthparent);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: horizontal, bottom: 1.5, top: heightparent - 11.5),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
                height: 10,
                width: widthscrollbar,
              ),
            ),
          ),
        ),
        Visibility(
          visible: !(heightscrollbar == heightparent),
          child: GestureDetector(
            onVerticalDragUpdate: (de) {
              setState(() {});
              if (vertical + de.delta.dy <= 0) {
                verticalcontroller.jumpTo(0);
              } else if (vertical + de.delta.dy <= heightparent - heightscrollbar) {
                verticalcontroller.jumpTo((vertical + de.delta.dy) * heightchild / heightparent);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: widthparent - 11.5, top: vertical, right: 1.5),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
                width: 10,
                height: heightscrollbar,
              ),
            ),
          ),
        )
      ],
    );
  }

  void postFrameCallback() {
    widthparent = horizontalcontroller.position.viewportDimension;
    widthchild = horizontalcontroller.position.viewportDimension + horizontalcontroller.position.maxScrollExtent;
    horizontal = horizontalcontroller.position.pixels * widthparent / widthchild;
    heightparent = verticalcontroller.position.viewportDimension;
    heightchild = verticalcontroller.position.viewportDimension + verticalcontroller.position.maxScrollExtent;
    vertical = verticalcontroller.position.pixels * heightparent / heightchild;
  }
}