
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:easywrt/utils/wrt.dart';

// Since Wrt class has static methods, we can't easily mock it with Mockito 
// unless we refactor Wrt to be an instance or use a wrapper.
// For now, we will create a Fake Wrt Client that mimics the expected behavior 
// if we were injecting it. But Wrt is a static utility class.

// A better approach for testing static methods is to wrapper them or 
// just test the logic that uses them if possible. 
// However, the task asks for a "Mock implementation".

// Let's assume we will refactor Wrt to use a Client interface later 
// or we just create a Mock class that *could* be used if we change architecture.

class MockOpenWrtClient extends Mock {
  Future<String?> login({
    String? baseURL,
    String? username,
    String? password,
  }) async {
    if (username == 'root' && password == 'password') {
      return 'mock_token';
    }
    return null;
  }

  Future<List<dynamic>> call(String deviceID, List<List<String>> segments) async {
     return [
       {'mock_data': 'value'}
     ];
  }
}
