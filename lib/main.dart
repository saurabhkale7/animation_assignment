import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final ColorTween bTogColorTween =
  ColorTween(begin: Colors.blue, end: Colors.green);
  final ColorTween gTorColorTween =
  ColorTween(begin: Colors.green, end: Colors.red);

  int state = 0;

  final beginShapeBorder = const PolygonShapeBorder(sides: 4);
  final midShapeBorder = const PolygonShapeBorder(cornerRadius: Length(100));
  final endShapeBorder = const PolygonShapeBorder(sides: 6);

  late final AnimationController firstController;
  late final AnimationController secondController;

  late final Animation bTogColorAnimation;
  late final Animation gTorColorAnimation;
  late final Animation rTocAnimation;
  late final Animation cTohAnimation;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    firstController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    secondController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    rTocAnimation =
        MorphableShapeBorderTween(begin: beginShapeBorder, end: midShapeBorder)
            .animate(firstController);
    cTohAnimation =
        MorphableShapeBorderTween(begin: midShapeBorder, end: endShapeBorder)
            .animate(secondController);

    bTogColorAnimation = bTogColorTween.animate(firstController);
    gTorColorAnimation = gTorColorTween.animate(secondController);

    animation = rTocAnimation;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, _) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            {
                              switch (state) {
                                case 0:
                                  await firstController.forward();
                                  state = 1;
                                  animation = secondController;
                                  break;
                                case 1:
                                  await secondController.forward();
                                  state = 2;
                                  animation = firstController;
                                  break;
                                case 2:
                                  state = 0;
                                  firstController.reset();
                                  secondController.reset();
                                  break;
                              }
                              setState(() {});
                            }
                          },
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: ShapeDecoration(
                              color: state == 0
                                  ? bTogColorAnimation.value
                                  : gTorColorAnimation.value,
                              shape: state == 0
                                  ? rTocAnimation.value
                                  : cTohAnimation.value,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        IconButton(
                            onPressed: () {
                              state = 0;
                              firstController.reset();
                              secondController.reset();
                              animation = firstController;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.refresh,
                              size: 40,
                              color: Colors.deepPurpleAccent,
                            ))
                      ],
                    ));
              }),
        ));
  }
}
