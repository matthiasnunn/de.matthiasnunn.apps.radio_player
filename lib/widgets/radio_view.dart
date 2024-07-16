import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:radio_player/models/radio.dart' as custom;
import 'package:radio_player/services/api_client.dart';


class RadioView extends StatefulWidget {

  final Function(custom.Radio) onRadioSelect;
  final custom.Radio? selectedRadio;

  const RadioView({super.key, required this.onRadioSelect, required this.selectedRadio});

  @override
  State<RadioView> createState() => _RadioViewState();
}


class _RadioViewState extends State<RadioView> {

  Object? _error;
  List<custom.Radio>? _radios;

  @override
  Widget build(BuildContext context) {
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
  void initState() {
    super.initState();
    _fetchRadios();
  }

  Future<void> _fetchRadios() async {
    try {
      _error = null;
      _radios = await ApiClient.getRadios(context);
      _radios!.sort((custom.Radio a, custom.Radio b) => a.name.compareTo(b.name));
      setState(() {});
    } catch (exception) {
      _error = exception;
      _radios = null;
      setState(() {});
    }
  }
}
