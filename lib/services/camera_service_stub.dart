import '../models/camera_error.dart';
import 'camera_service.dart';

/// 非Web環境用のCameraServiceスタブ実装
class CameraServiceImpl implements CameraService {
  final List<String> _errorLog = [];
  
  /// ブラウザがカメラAPIをサポートしているかチェック
  /// 非Web環境では常にfalseを返す
  static bool isBrowserSupported() {
    return false;
  }
  
  @override
  Future<void> initialize() async {
    final error = CameraError(
      'カメラ機能はWeb環境でのみ利用可能です',
      CameraErrorType.notAvailable,
    );
    _logError(error);
    throw error;
  }
  
  @override
  void dispose() {
    // 何もしない
  }
  
  @override
  dynamic get videoElement => null;
  
  @override
  bool get isAvailable => false;
  
  @override
  List<String> get errorLog => List.unmodifiable(_errorLog);
  
  @override
  bool get isReconnecting => false;
  
  @override
  int get reconnectAttempts => 0;
  
  /// エラーをログに記録
  void _logError(CameraError error) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] ${error.type.name}: ${error.message}';
    _errorLog.add(logEntry);
    print(logEntry); // 非Web環境ではprintを使用
  }
}
