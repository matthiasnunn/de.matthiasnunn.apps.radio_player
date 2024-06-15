import 'package:flutter/widgets.dart';


// Implementation from https://stackoverflow.com/questions/51772543/how-to-make-a-text-widget-act-like-marquee-when-the-text-overflows-in-flutter
// because text_scroll (0.2.0) are not working this good and the packages marquee (2.2.3) was not working.

class Marquee extends StatefulWidget {

  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  const Marquee({
    Key? key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 6000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<Marquee> createState() => _MarqueeState();
}


class _MarqueeState extends State<Marquee> {

  late ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: widget.direction,
      controller: scrollController,
      child: widget.child
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.ease
        );
      }
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0.0,
          duration: widget.backDuration,
          curve: Curves.easeOut
        );
      }
    }
  }
}
