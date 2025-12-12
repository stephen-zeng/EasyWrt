import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../db/models/router_item.dart';
import '../../router/router_controller.dart';

/// RouterDialog
/// 
/// Function: A dialog for adding or editing a router configuration.
/// Inputs: 
///   - [router]: Optional existing router to edit.
/// Outputs: 
///   - [Widget]: Dialog with form fields.
class RouterDialog extends StatefulWidget {
  final RouterItem? router;

  const RouterDialog({super.key, this.router});

  @override
  State<RouterDialog> createState() => _RouterDialogState();
}

class _RouterDialogState extends State<RouterDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _isHttps = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.router?.name ?? '');
    _hostController = TextEditingController(text: widget.router?.host ?? '');
    _portController = TextEditingController(text: widget.router?.port.toString() ?? '80');
    _usernameController = TextEditingController(text: widget.router?.username ?? 'root');
    _passwordController = TextEditingController(text: widget.router?.password ?? '');
    _isHttps = widget.router?.isHttps ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.router == null ? 'Add Router' : 'Edit Router'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: _hostController,
                decoration: const InputDecoration(labelText: 'Host (IP/Domain)'),
                validator: (value) => value!.isEmpty ? 'Please enter host' : null,
              ),
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(labelText: 'Port'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter port' : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Please enter username' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Please enter password' : null,
              ),
              SwitchListTile(
                title: const Text('Use HTTPS'),
                value: _isHttps,
                onChanged: (value) {
                  setState(() {
                    _isHttps = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (context, ref, child) {
            return FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final router = RouterItem(
                    id: widget.router?.id ?? const Uuid().v4(),
                    name: _nameController.text,
                    host: _hostController.text,
                    port: int.parse(_portController.text),
                    username: _usernameController.text,
                    password: _passwordController.text,
                    isHttps: _isHttps,
                  );
                  
                  if (widget.router == null) {
                    ref.read(routerListProvider.notifier).addRouter(router);
                  } else {
                    ref.read(routerListProvider.notifier).updateRouter(router);
                  }
                  
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            );
          },
        ),
      ],
    );
  }
}
