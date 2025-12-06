import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easywrt/provider/device_provider.dart';
import 'package:easywrt/model/device_profile.dart';

class DeviceListPage extends StatelessWidget {
  const DeviceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Modular.to.pushNamed('/device-edit'); // Navigate to add new device page
            },
          ),
        ],
      ),
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          if (deviceProvider.devices.isEmpty) {
            return const Center(child: Text('No devices added yet.'));
          }
          return ListView.builder(
            itemCount: deviceProvider.devices.length,
            itemBuilder: (context, index) {
              final device = deviceProvider.devices[index];
              final isActive = device.uuid == deviceProvider.activeDevice?.uuid;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                elevation: isActive ? 4 : 1,
                color: isActive ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                child: ListTile(
                  title: Text(device.name),
                  subtitle: Text('${device.protocol}://${device.hostname}:${device.port}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Modular.to.pushNamed('/device-edit', arguments: device); // Navigate to edit device page
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Device'),
                              content: Text('Are you sure you want to delete ${device.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            deviceProvider.deleteDevice(device.uuid);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    deviceProvider.setActiveDevice(device);
                    Modular.to.pop(); // Go back after selecting
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
