import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:radio_player/models/instance.dart';
import 'package:radio_player/models/radio.dart' as custom;


class RadioView extends StatefulWidget {

  final Instance? instance;
  final Function(custom.Radio) onRadioSelect;
  final custom.Radio? selectedRadio;

  const RadioView({super.key, required this.instance, required this.onRadioSelect, required this.selectedRadio});

  @override
  State<RadioView> createState() => _RadioViewState();
}


class _RadioViewState extends State<RadioView> {

  Object? _error;
  List<custom.Radio>? _radios;

  @override
  Widget build(BuildContext context) {
    if (widget.instance == null) {
      return const Center(
        child: Text("Keine Nextcloud/ownCloud ausgewählt")
      );
    }
    if (_error != null) {
      if (_error is SocketException) {
        return RefreshIndicator(
          onRefresh: _fetchRadios,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ListView(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off,
                          color: Colors.black,
                          size: 80
                        ),
                        Container(
                          height: 10,
                        ),
                        const Text("Keine Internetverbindung")
                      ]
                    )
                  )
                ]
              );
            }
          )
        );
      }
      Fluttertoast.showToast(msg: _error!.toString());
      return Container();
    }
    if (_radios != null) {
      return RefreshIndicator(
        onRefresh: _fetchRadios,
        child: ListView(
          children: _radios!.map((custom.Radio radio) =>
            ListTile(
              selected: radio == widget.selectedRadio,
              title: Text(radio.name),
              onTap: () => widget.onRadioSelect(radio)
            )
          ).toList()
        )
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void didUpdateWidget(RadioView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instance != oldWidget.instance) {
      _fetchRadios();
    }
  }

  Future<void> _fetchRadios() async {
    if (widget.instance == null) {
      return;
    }
    try {
      _error = null;
      _radios = await custom.Radio.getRadiosFor(widget.instance!);
      _radios!.sort((custom.Radio a, custom.Radio b) => a.name.compareTo(b.name));
      setState(() {});
    } catch (exception) {
      _error = exception;
      _radios = null;
      setState(() {});
    }
  }
}
