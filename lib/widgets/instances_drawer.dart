import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:radio_player/db/instances.dart';
import 'package:radio_player/models/instance.dart';
import 'package:radio_player/widgets/instance_input_dialog.dart';


class InstancesDrawer extends StatefulWidget {

  final Function(Instance?) onInstanceChange;
  final Instance? selectedInstance;

  const InstancesDrawer({super.key, required this.onInstanceChange, required this.selectedInstance});

  @override
  State<InstancesDrawer> createState() => _InstancesDrawerState();
}


class _InstancesDrawerState extends State<InstancesDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder(
        future: Instances.getInstances(),
        builder: (context, AsyncSnapshot<List<Instance>> snapshot) {
          if (snapshot.hasError) {
            Fluttertoast.showToast(msg: snapshot.error.toString());
            return Container();
          }
          return ListView(
            padding: EdgeInsets.zero,  // remove gap between `DrawerHeader` and top
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    const Spacer(),
                    ListTile(
                      leading: Icon(Icons.add,
                        color: Theme.of(context).appBarTheme.foregroundColor
                      ),
                      title: Text("Nextcloud/ownCloud hinzufügen",
                        style: TextStyle(
                          color: Theme.of(context).appBarTheme.foregroundColor
                        )
                      ),
                      onTap: _addInstance
                    )
                  ]
                )
              ),
              ...(snapshot.data ?? []).map((instance) =>
                ListTile(
                  leading: const Icon(Icons.cloud),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      widget.onInstanceChange(null);
                      await Instances.deleteInstance(instance);
                      setState(() {});
                    }
                  ),
                  selected: instance == widget.selectedInstance,
                  title: Text(instance.name),
                  onTap: () {
                    widget.onInstanceChange(instance);
                    Navigator.pop(context);
                  }
                )
              )
            ]
          );
        }
      )
    );
  }

  Future<void> _addInstance() async {
    final instance = await showDialog<Instance?>(
      context: context,
      builder: (context) {
        return const InstanceInputDialog();
      }
    );
    if (instance != null) {
      widget.onInstanceChange(instance);
      Navigator.pop(context);
    }
  }
}
