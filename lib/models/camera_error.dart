/// カメラエラーのタイプを表現する列挙型
enum CameraErrorType {
  /// 権限拒否
  permissionDenied,
  
  /// カメラ利用不可
  notAvailable,
  
  /// ストリームエラー
  streamError,
  
  /// ブラウザ非対応
  browserNotSupported,
  
  /// 不明なエラー
  unknown,
}

/// カメラエラー情報を保持するモデルクラス
class CameraError {
  /// エラーメッセージ
  final String message;
  
  /// エラータイプ
  final CameraErrorType type;
  
  /// コンストラクタ
  CameraError(this.message, this.type);
  
  @override
  String toString() => 'CameraError(type: $type, message: $message)';
}
