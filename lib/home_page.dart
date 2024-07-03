import 'package:flutter/material.dart';
import 'product.dart';
import 'product_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(6, (index) => GlobalKey());
  final List<GlobalKey> _buttonKeys = List.generate(6, (index) => GlobalKey());
  int _selectedIndex = 0;
  bool _isScrolling = false;

  final List<String> _sections = [
    'Черный кофе',
    'Кофе с молоком',
    'Чай',
    'Авторские напитки',
    'Десерты',
    'Закуски',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isScrolling) return;

    for (int i = 0; i < _sections.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);

        if (position.dy >= 0) {
          setState(() {
            _selectedIndex = i;
          });
          _scrollToSelectedButton();
          break;
        }
      }
    }
  }

  bool _isBoxVisible(RenderBox box) {
    final boxOffset = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    return boxOffset.dy + box.size.height > 0 && boxOffset.dy < screenHeight;
  }

  void _onSectionTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _scrollToSection(index);
    _scrollToSelectedButton();
  }

  void _scrollToSection(int index) {
    setState(() {
      _isScrolling = true;
    });
    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) {
        setState(() {
          _isScrolling = false;
        });
      });
    }
  }

  void _scrollToSelectedButton() {
    final context = _buttonKeys[_selectedIndex].currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero, ancestor: _horizontalScrollController.position.context.storageContext.findRenderObject());
      final offset = position.dx;

      final screenWidth = MediaQuery.of(context).size.width;

      const double horizontalMargin = 5.0;

      final targetOffset = _horizontalScrollController.offset + offset - (screenWidth / 2 - box.size.width / 2);

      if (targetOffset < 0) {
        _horizontalScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (targetOffset > _horizontalScrollController.position.maxScrollExtent) {
        _horizontalScrollController.animateTo(
          _horizontalScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _horizontalScrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 255, 253, 248),
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    controller: _horizontalScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onSectionTapped(index),
                        child: Container(
                          key: _buttonKeys[index],
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: _selectedIndex == index ? Color.fromARGB(255, 152, 199, 221) : Color.fromARGB(255, 241, 251, 255),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _sections[index],
                              style: TextStyle(color: _selectedIndex == index ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _sections.asMap().entries.map((entry) {
                        int index = entry.key;
                        String section = entry.value;
                        return Padding(
                          key: _sectionKeys[index],
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                section,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Placeholder(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
