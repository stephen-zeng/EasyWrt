import 'package:flutter/material.dart';

class MiddlewarePage extends StatelessWidget {
  final ValueChanged<int> onItemSelected;

  const MiddlewarePage({super.key, required this.onItemSelected});

  // For now, a static list of items. This will be dynamic with MenuConfig later.
  final List<String> _middlewareItems = const [
    'System Overview',
    'Network Status',
    'Wireless',
    'DHCP/DNS',
    'Firewall',
    'VPN',
    'Custom Actions', // Placeholder for "Function Pages"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Middleware'),
        automaticallyImplyLeading: false, // Don't show back button by default
      ),
      body: ListView.builder(
        itemCount: _middlewareItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_middlewareItems[index]),
            onTap: () {
              onItemSelected(index); // Notify parent dashboard page
            },
          );
        },
      ),
    );
  }
}