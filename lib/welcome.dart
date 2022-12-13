import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/home.dart';
import 'package:flutter_medical_beauty/tool.dart';

/// 欢迎页
class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WelcomePageState();
  }
}

class WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  List<String> _images = <String>['splash_one', 'splash_two', 'splash_three'];
  int _currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {}

  void _pushHome() async {
    if (_currentPage == _images.length - 1) {
      Tool.saveBool('splash', true);
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      _currentPage++;
      _pageController.jumpToPage(_currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.asset('assets/images/home/${_images[index]}.png',
                    fit: BoxFit.cover);
              },
              onPageChanged: (index) {
                setState(
                  () {
                    _currentPage = index;
                  },
                );
              },
            ),
          ),
          Positioned(
            right: 20,
            bottom: 33,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _pushHome,
                child: Container(
                  height: 44,
                  width: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(22),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
