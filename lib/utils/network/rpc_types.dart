import 'package:equatable/equatable.dart';

// Request Configuration
class RpcRequest extends Equatable {
  final String namespace;
  final String method;
  final Map<String, dynamic> params;

  const RpcRequest({
    required this.namespace,
    required this.method,
    this.params = const {},
  });

  @override
  List<Object?> get props => [namespace, method, params];
}
