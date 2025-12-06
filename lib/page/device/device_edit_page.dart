import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:easywrt/provider/device_provider.dart';
import 'package:easywrt/model/device_profile.dart';
import 'package:provider/provider.dart';
import 'package:easywrt/utils/wrt.dart'; // For Wrt.login

class DeviceEditPage extends StatefulWidget {
  final DeviceProfile? device; // Null for new device, not null for editing

  const DeviceEditPage({super.key, this.device});

  @override
  State<DeviceEditPage> createState() => _DeviceEditPageState();
}

class _DeviceEditPageState extends State<DeviceEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hostnameController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _rootPathController;
  late String _protocol;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device?.name ?? '');
    _hostnameController = TextEditingController(text: widget.device?.hostname ?? '');
    _portController = TextEditingController(text: widget.device?.port.toString() ?? '80');
    _usernameController = TextEditingController(text: widget.device?.username ?? 'root');
    _passwordController = TextEditingController(text: widget.device?.password ?? '');
    _rootPathController = TextEditingController(text: widget.device?.rootPath ?? '/cgi-bin/luci/rpc');
    _protocol = widget.device?.protocol ?? 'http';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostnameController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _rootPathController.dispose();
    super.dispose();
  }

  Future<void> _saveDevice() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);

      // Perform a login test to get a token
      String? token;
      try {
        final baseURL = '$_protocol://${_hostnameController.text}:${_portController.text}/';
        token = await Wrt.login(
          baseURL: baseURL,
          username: _usernameController.text,
          password: _passwordController.text,
        );
      } catch (e) {
        // Handle login error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed: Could not retrieve token')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }


      if (widget.device == null) {
        // Add new device
        deviceProvider.addDevice(
          name: _nameController.text,
          luciUsername: _usernameController.text,
          luciPassword: _passwordController.text,
          luciBaseURL: '$_protocol://${_hostnameController.text}:${_portController.text}/', // Reconstruct baseURL
          token: token,
        );
      } else {
        // Edit existing device
        final updatedDevice = DeviceProfile(
          uuid: widget.device!.uuid,
          name: _nameController.text,
          hostname: _hostnameController.text,
          port: int.parse(_portController.text),
          protocol: _protocol,
          username: _usernameController.text,
          password: _passwordController.text, // Assume password is re-entered or encrypted later
          rootPath: _rootPathController.text,
          token: token, // Update token after successful login
        );
        deviceProvider.editDevice(updatedDevice);
      }
      Modular.to.pop(); // Go back to list page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device == null ? 'Add Device' : 'Edit Device'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Device Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a device name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hostnameController,
                decoration: const InputDecoration(labelText: 'Hostname (IP/Domain)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hostname';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'Port'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null) {
                    return 'Please enter a valid port number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _protocol,
                decoration: const InputDecoration(labelText: 'Protocol'),
                items: ['http', 'https'].map((String protocol) {
                  return DropdownMenuItem<String>(
                    value: protocol,
                    child: Text(protocol),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _protocol = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (widget.device == null && (value == null || value.isEmpty)) {
                    return 'Please enter password for new device';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rootPathController,
                decoration: const InputDecoration(labelText: 'RPC Root Path'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter RPC root path';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDevice,
                child: const Text('Save Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
