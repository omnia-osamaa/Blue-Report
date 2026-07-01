import 'dart:async';




class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  
  final _controller = StreamController<void>.broadcast();
  Stream<void> get notificationStream => _controller.stream;

  Future<void> init() async {
    
  }

  void dispose() {
    _controller.close();
  }
}

