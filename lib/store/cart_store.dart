import 'package:flutter/foundation.dart';

class CartStore extends ChangeNotifier {
  bool _isFinalized = false;

  bool get isFinalized => _isFinalized;

  void finalize() {
    _isFinalized = true;
    notifyListeners();
  }

  void reset() {
    _isFinalized = false;
    notifyListeners();
  }
}