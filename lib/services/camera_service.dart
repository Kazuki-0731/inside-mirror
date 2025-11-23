import 'camera_service_stub.dart'
    if (dart.library.html) 'camera_service_web.dart';

/// カメラへのアクセスとストリーム管理を担当するサービスクラス
abstract class CameraService {
  /// CameraServiceのインスタンスを作成
  factory CameraService() = CameraServiceImpl;

  /// ブラウザがカメラAPIをサポートしているかチェック
  static bool isBrowserSupported() {
    return CameraServiceImpl.isBrowserSupported();
  }

  /// カメラストリームを初期化
  Future<void> initialize();
  
  /// カメラストリームを停止
  void dispose();
  
  /// ビデオエレメントを取得
  dynamic get videoElement;
  
  /// カメラが利用可能かチェック
  bool get isAvailable;
  
  /// エラーログを取得
  List<String> get errorLog;
  
  /// 再接続中かどうか
  bool get isReconnecting;
  
  /// 再接続試行回数
  int get reconnectAttempts;
}
