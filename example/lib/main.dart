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
            BreakoutArea(
              insets: BreakoutInsets.horizontal(40),
              child: SliverSafeArea(
                sliver: SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  sliver: SliverList.list(
                    children: [
                      Bounded(child: Text(loremIpsum)),
                      SizedBox(height: 40),
                      ParallaxImageBanner(
                        image: AssetImage(
                          'assets/florian-weichert-CJpET6f24nI-unsplash.jpg',
                        ),
                      ),
                      SizedBox(height: 40),
                      Bounded(child: Text(loremIpsum)),
                      SizedBox(height: 40),
                      ParallaxImageBanner(
                        image: AssetImage(
                          'assets/florian-weichert-gqxjcLXfms4-unsplash.jpg',
                        ),
                      ),
                      SizedBox(height: 40),
                      Bounded(child: Text(loremIpsum)),
                      SizedBox(height: 40),
                      Bounded(child: Text(loremIpsum)),
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
    return GestureDetector(
      onTap: () => print('Image tapped!'),
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Image(image: image, fit: BoxFit.cover),
      ),
    );
  }
}
