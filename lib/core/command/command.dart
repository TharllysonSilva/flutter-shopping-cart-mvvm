import 'package:flutter/foundation.dart';
import '../result/result.dart';

class Command<T> extends ChangeNotifier {
  bool _isExecuting = false;
  Result<T>? _result;

  bool get isExecuting => _isExecuting;
  Result<T>? get result => _result;

  Future<void> execute(Future<Result<T>> Function() action) async {
    _isExecuting = true;
    _result = null;
    notifyListeners();

    _result = await action();

    _isExecuting = false;
    notifyListeners();
  }

  void clear() {
    _result = null;
    notifyListeners();
  }
}