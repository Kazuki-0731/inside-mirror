/// カメラの現在の状態を表現する列挙型
enum CameraState {
  /// 初期状態
  initial,
  
  /// 権限要求中
  requesting,
  
  /// カメラアクティブ
  active,
  
  /// エラー状態
  error,
  
  /// 権限拒否
  denied,
}
