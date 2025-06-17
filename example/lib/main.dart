import 'package:breakout/breakout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

final loremIpsum =
    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            Breakoutable(
              insets: HorizontalBreakoutInsets(start: 40, end: 40),
              child: SliverSafeArea(
                minimum: EdgeInsets.symmetric(horizontal: 40),
                sliver: SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  sliver: SliverList.list(
                    children: [
                      Text(loremIpsum),
                      SizedBox(height: 40),
                      Breakout(
                        child: ParallaxImageBanner(
                          image: AssetImage(
                            'assets/florian-weichert-CJpET6f24nI-unsplash.jpg',
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(loremIpsum),
                      SizedBox(height: 40),
                      Breakout(
                        child: ParallaxImageBanner(
                          image: AssetImage(
                            'assets/florian-weichert-gqxjcLXfms4-unsplash.jpg',
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(loremIpsum),
                      SizedBox(height: 40),
                      Text(loremIpsum),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParallaxImageBanner extends StatelessWidget {
  const ParallaxImageBanner({super.key, required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    final scrollController =
        context.findAncestorStateOfType<_MainAppState>()!._scrollController;
    return GestureDetector(
      child: ListenableBuilder(
        listenable: scrollController,
        builder: (context, _) {
          return AspectRatio(
            aspectRatio: 3 / 1,
            child: Image(image: image, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
