import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart'; // Import flutter_modular
import 'package:easywrt/page/dashboard/middleware_page.dart'; // To be created in T021
import 'package:easywrt/page/dashboard/function_page.dart';   // To be created in T022
import 'package:easywrt/page/device/device_list_page.dart';   // For device selection

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0; // Index for selected function/widget page

  void _handleMiddlewareItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Modular.to.pop(); // Pop MiddlewarePage after selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyWRT Dashboard'),
        actions: [
          // Device List button
          IconButton(
            icon: const Icon(Icons.router),
            onPressed: () {
              Modular.to.pushNamed('/device-list'); // Use Modular for navigation
            },
          ),
          // Middleware button for portrait mode
          if (MediaQuery.of(context).size.width <= 600) // Only show in portrait
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Modular.to.pushNamed('/dashboard-single-middleware', arguments: _handleMiddlewareItemSelected);
              },
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Landscape - Split View
            return Row(
              children: [
                // Left Pane (Middleware/Navigation)
                SizedBox(
                  width: 300, // Fixed width for the left pane
                  child: MiddlewarePage(
                    onItemSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
                // Divider between panes
                const VerticalDivider(width: 1),
                // Right Pane (Function/Widget Page)
                Expanded(
                  child: FunctionPage(selectedIndex: _selectedIndex),
                ),
              ],
            );
          } else {
            // Portrait - Single View
            return Column(
              children: [
                // Only show the function page directly in portrait body
                Expanded(
                  child: FunctionPage(selectedIndex: _selectedIndex),
                ),
              ],
            );
          }
        },
      ),
      // No bottom navigation bar in either mode, navigation handled by AppBar actions
    );
  }
}
