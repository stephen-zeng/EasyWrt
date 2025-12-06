import 'package:flutter/material.dart';

class FunctionPage extends StatelessWidget {
  final int selectedIndex;

  const FunctionPage({super.key, required this.selectedIndex});

  // A simple mapping for content based on selected index
  Widget _buildContent(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const Center(child: Text('Displaying System Overview'));
      case 1:
        return const Center(child: Text('Displaying Network Status'));
      case 2:
        return const Center(child: Text('Displaying Wireless Settings'));
      case 3:
        return const Center(child: Text('Displaying DHCP/DNS Settings'));
      case 4:
        return const Center(child: Text('Displaying Firewall Rules'));
      case 5:
        return const Center(child: Text('Displaying VPN Configuration'));
      case 6:
        return const Center(child: Text('Displaying Custom Actions/Widgets'));
      default:
        return const Center(child: Text('No function selected'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Function Details'),
        automaticallyImplyLeading: false, // Don't show back button by default
      ),
      body: _buildContent(context),
    );
  }
}
