import 'dart:html' as html;
import '../models/camera_error.dart';
import 'camera_service.dart';

/// Web用のCameraService実装
class CameraServiceImpl implements CameraService {
  html.MediaStream? _stream;
  html.VideoElement? _videoElement;
  final List<String> _errorLog = [];
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;
  bool _isReconnecting = false;
  
  /// ブラウザがカメラAPIをサポートしているかチェック
  static bool isBrowserSupported() {
    // navigator.mediaDevicesの存在を確認
    return html.window.navigator.mediaDevices != null;
  }
  
  @override
  Future<void> initialize() async {
    try {
      // ブラウザがカメラAPIをサポートしているかチェック
      if (!isBrowserSupported()) {
        throw CameraError(
          'このブラウザはカメラAPIをサポートしていません。Chrome 53+、Firefox 36+、Safari 11+、またはEdge 79+をご利用ください。',
          CameraErrorType.browserNotSupported,
        );
      }
      
      // カメラストリームを取得
      final constraints = {
        'video': {
          'facingMode': 'user', // フロントカメラを指定
        }
      };
      
      _stream = await html.window.navigator.mediaDevices!
          .getUserMedia(constraints);
      
      // VideoElementを作成
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..muted = true;
      
      // ストリームをVideoElementに接続
      _videoElement!.srcObject = _stream;
      
      // ストリーム中断時の再接続リスナーを設定
      _setupStreamListeners();
      
      // 初期化成功時は再接続カウンターをリセット
      _reconnectAttempts = 0;
    } on html.DomException catch (e) {
      // DOMExceptionの詳細なエラーハンドリング
      CameraError error;
      if (e.name == 'NotAllowedError') {
        error = CameraError(
          'カメラへのアクセスが拒否されました。ブラウザの設定でカメラ権限を許可してください。',
          CameraErrorType.permissionDenied,
        );
      } else if (e.name == 'NotFoundError') {
        error = CameraError(
          'カメラデバイスが見つかりません。カメラが接続されているか確認してください。',
          CameraErrorType.notAvailable,
        );
      } else if (e.name == 'NotReadableError') {
        error = CameraError(
          'カメラは他のアプリケーションで使用中です。',
          CameraErrorType.notAvailable,
        );
      } else {
        error = CameraError(
          'カメラの初期化に失敗しました: ${e.message}',
          CameraErrorType.streamError,
        );
      }
      _logError(error);
      throw error;
    } catch (e) {
      final error = CameraError(
        'カメラの初期化中に予期しないエラーが発生しました: $e',
        CameraErrorType.unknown,
      );
      _logError(error);
      throw error;
    }
  }
  
  @override
  void dispose() {
    // ストリームの全トラックを停止
    if (_stream != null) {
      final tracks = _stream!.getTracks();
      for (final track in tracks) {
        track.stop();
      }
      _stream = null;
    }
    
    // VideoElementをクリーンアップ
    if (_videoElement != null) {
      _videoElement!.srcObject = null;
      _videoElement!.remove();
      _videoElement = null;
    }
  }
  
  @override
  html.VideoElement? get videoElement => _videoElement;
  
  @override
  bool get isAvailable => _stream != null && _videoElement != null;
  
  /// エラーログを取得
  @override
  List<String> get errorLog => List.unmodifiable(_errorLog);
  
  /// エラーをログに記録
  void _logError(CameraError error) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] ${error.type.name}: ${error.message}';
    _errorLog.add(logEntry);
    // コンソールにも出力
    html.window.console.error(logEntry);
  }
  
  /// ストリームリスナーを設定
  void _setupStreamListeners() {
    if (_stream == null) return;
    
    // 各トラックの終了イベントをリッスン
    final tracks = _stream!.getTracks();
    for (final track in tracks) {
      track.onEnded.listen((_) {
        _handleStreamInterruption();
      });
    }
  }
  
  /// ストリーム中断時の処理
  Future<void> _handleStreamInterruption() async {
    if (_isReconnecting) return;
    
    _isReconnecting = true;
    final logEntry = '[${DateTime.now().toIso8601String()}] ストリームが中断されました。再接続を試みます...';
    _errorLog.add(logEntry);
    html.window.console.warn(logEntry);
    
    while (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      
      try {
        final attemptLog = '[${DateTime.now().toIso8601String()}] 再接続試行 $_reconnectAttempts/$_maxReconnectAttempts';
        _errorLog.add(attemptLog);
        html.window.console.info(attemptLog);
        
        // 既存のリソースをクリーンアップ
        dispose();
        
        // 再初期化を試みる
        await initialize();
        
        final successLog = '[${DateTime.now().toIso8601String()}] 再接続に成功しました';
        _errorLog.add(successLog);
        html.window.console.info(successLog);
        
        _isReconnecting = false;
        return;
      } catch (e) {
        final errorLog = '[${DateTime.now().toIso8601String()}] 再接続試行 $_reconnectAttempts 失敗: $e';
        _errorLog.add(errorLog);
        html.window.console.error(errorLog);
        
        if (_reconnectAttempts < _maxReconnectAttempts) {
          // 次の試行前に少し待機
          await Future.delayed(Duration(seconds: 1));
        }
      }
    }
    
    // 最大試行回数に達した
    final failLog = '[${DateTime.now().toIso8601String()}] 再接続の最大試行回数に達しました';
    _errorLog.add(failLog);
    html.window.console.error(failLog);
    _isReconnecting = false;
  }
  
  /// 再接続中かどうか
  @override
  bool get isReconnecting => _isReconnecting;
  
  /// 再接続試行回数
  @override
  int get reconnectAttempts => _reconnectAttempts;
}
