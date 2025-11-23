import 'package:flutter/material.dart';
import '../models/camera_error.dart';

/// エラー表示ウィジェット
class ErrorView extends StatelessWidget {
  /// カメラエラー
  final CameraError error;
  
  /// 再試行コールバック（オプション）
  final VoidCallback? onRetry;
  
  /// コンストラクタ
  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
  });
  
  /// エラータイプに応じたタイトルを取得
  String _getErrorTitle() {
    switch (error.type) {
      case CameraErrorType.permissionDenied:
        return 'カメラへのアクセスが拒否されました';
      case CameraErrorType.notAvailable:
        return 'カメラが利用できません';
      case CameraErrorType.streamError:
        return 'カメラストリームエラー';
      case CameraErrorType.browserNotSupported:
        return 'ブラウザが対応していません';
      case CameraErrorType.unknown:
        return 'エラーが発生しました';
    }
  }
  
  /// エラータイプに応じた詳細メッセージを取得
  String _getErrorDescription() {
    switch (error.type) {
      case CameraErrorType.permissionDenied:
        return 'このアプリケーションを使用するにはカメラへのアクセス許可が必要です。\nブラウザの設定でカメラ権限を有効にしてください。';
      case CameraErrorType.notAvailable:
        return 'カメラが接続されていないか、他のアプリケーションで使用中です。\nカメラデバイスを確認してください。';
      case CameraErrorType.streamError:
        return 'カメラストリームの取得中にエラーが発生しました。\n再試行してください。';
      case CameraErrorType.browserNotSupported:
        return 'お使いのブラウザはカメラAPIをサポートしていません。\nChrome、Firefox、Safari、またはEdgeの最新版をご利用ください。';
      case CameraErrorType.unknown:
        return '予期しないエラーが発生しました。\n再試行してください。';
    }
  }
  
  /// エラータイプに応じたアイコンを取得
  IconData _getErrorIcon() {
    switch (error.type) {
      case CameraErrorType.permissionDenied:
        return Icons.block;
      case CameraErrorType.notAvailable:
        return Icons.videocam_off;
      case CameraErrorType.streamError:
        return Icons.error_outline;
      case CameraErrorType.browserNotSupported:
        return Icons.web_asset_off;
      case CameraErrorType.unknown:
        return Icons.warning_amber;
    }
  }
  
  /// 再試行ボタンを表示すべきかどうか
  bool _shouldShowRetryButton() {
    // 権限拒否またはブラウザ非対応の場合は再試行ボタンを表示しない
    // （ユーザーがブラウザ設定で権限を変更するか、ブラウザを変更する必要があるため）
    return error.type != CameraErrorType.permissionDenied && 
           error.type != CameraErrorType.browserNotSupported && 
           onRetry != null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // エラーアイコン
            Icon(
              _getErrorIcon(),
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            
            // エラータイトル
            Text(
              _getErrorTitle(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // エラー詳細メッセージ
            Text(
              _getErrorDescription(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // 技術的なエラーメッセージ（デバッグ用）
            if (error.message.isNotEmpty)
              Text(
                '詳細: ${error.message}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            
            // 再試行ボタン
            if (_shouldShowRetryButton()) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('再試行'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
