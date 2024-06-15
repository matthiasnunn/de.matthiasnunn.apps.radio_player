import 'package:flutter/widgets.dart';


class DoubleStreamBuilder<T1, T2> extends StatelessWidget {

  Stream<T1> stream1;
  Stream<T2> stream2;
  Widget Function(BuildContext, AsyncSnapshot<T1>, AsyncSnapshot<T2>) builder;

  DoubleStreamBuilder({required this.stream1, required this.stream2, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream1,
      builder: (context, snapshot1) {
        return StreamBuilder(
          stream: stream2,
          builder: (context, snapshot2) {
            return builder(context, snapshot1, snapshot2);
          }
        );
      }
    );
  }
}
