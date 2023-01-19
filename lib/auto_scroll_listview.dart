import 'dart:async';

import 'package:flutter/material.dart';

class ScrollingListView extends StatefulWidget {
  
  @override
  _ScrollingListViewState createState() => _ScrollingListViewState();
}

class _ScrollingListViewState extends State<ScrollingListView> {
  final ScrollController _controller = ScrollController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
    _startAutoScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _controller,
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 200,
            color: _currentIndex == index ? Colors.red : Colors.white,
            child: Center(child: Text('Item $index')),
          );
        },
      ),
    );
  }

  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentIndex < 99) {
        _currentIndex++;
        _controller.animateTo(_currentIndex * 200.0,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        _currentIndex = 0;
        _controller.jumpTo(0);
      }
    });
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _currentIndex = 0;
    } else if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      _currentIndex = 99;
    } else {
      _currentIndex = (_controller.offset / 200).round();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }
}
