import 'package:flutter/foundation.dart';

class NotificationModel extends ChangeNotifier {
  int _notificationCount = 5;
  int _messageCount = 3;

  int get notificationCount => _notificationCount;
  int get messageCount => _messageCount;

  void incrementNotificationCount() {
    _notificationCount++;
    notifyListeners();
  }

  void decrementNotificationCount() {
    if (_notificationCount > 0) {
      _notificationCount--;
      notifyListeners();
    }
  }

  void incrementMessageCount() {
    _messageCount++;
    notifyListeners();
  }

  void decrementMessageCount() {
    if (_messageCount > 0) {
      _messageCount--;
      notifyListeners();
    }
  }
}
