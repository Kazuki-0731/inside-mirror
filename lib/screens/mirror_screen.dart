import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../models/camera_state.dart';
import '../models/camera_error.dart';
import '../services/camera_service.dart';
import '../widgets/camera_view.dart';
import '../widgets/error_view.dart';

/// メイン画面ウィジェット
class MirrorScreen extends StatefulWidget {
  const MirrorScreen({super.key});
  
  @override
  State<MirrorScreen> createState() => _MirrorScreenState();
}

class _MirrorScreenState extends State<MirrorScreen> {
  /// カメラサービスのインスタンス
  late final CameraService _cameraService;

  /// 現在のカメラ状態
  CameraState _state = CameraState.initial;

  /// エラー情報
  CameraError? _error;

  /// 鏡像表示かどうか
  bool _isMirrored = true;
  
  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _initializeCamera();
  }
  
  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
  
  /// カメラを初期化
  Future<void> _initializeCamera() async {
    setState(() {
      _state = CameraState.requesting;
      _error = null;
    });
    
    try {
      await _cameraService.initialize();
      setState(() {
        _state = CameraState.active;
      });
    } on CameraError catch (e) {
      setState(() {
        _error = e;
        if (e.type == CameraErrorType.permissionDenied) {
          _state = CameraState.denied;
        } else {
          _state = CameraState.error;
        }
      });
    } catch (e) {
      setState(() {
        _error = CameraError(
          'カメラの初期化中に予期しないエラーが発生しました: $e',
          CameraErrorType.unknown,
        );
        _state = CameraState.error;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildBody(),
    );
  }
  
  /// 状態に応じたボディを構築
  Widget _buildBody() {
    switch (_state) {
      case CameraState.initial:
      case CameraState.requesting:
        return _buildLoadingView();
      
      case CameraState.active:
        return _buildCameraView();
      
      case CameraState.error:
      case CameraState.denied:
        return _buildErrorView();
    }
  }
  
  /// ローディングビューを構築
  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 24),
          Text(
            'カメラを起動しています...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  /// カメラビューを構築
  Widget _buildCameraView() {
    final videoElement = _cameraService.videoElement as html.VideoElement?;

    if (videoElement == null) {
      return _buildErrorView();
    }

    return Stack(
      children: [
        // カメラ映像
        Center(
          child: CameraView(
            videoElement: videoElement,
            isMirrored: _isMirrored,
          ),
        ),
        // 反転ボタン
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: _toggleMirror,
              backgroundColor: Colors.white.withOpacity(0.8),
              child: Icon(
                Icons.flip,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 鏡像表示を切り替え
  void _toggleMirror() {
    setState(() {
      _isMirrored = !_isMirrored;
    });
  }
  
  /// エラービューを構築
  Widget _buildErrorView() {
    if (_error == null) {
      _error = CameraError(
        'カメラの初期化に失敗しました',
        CameraErrorType.unknown,
      );
    }
    
    return ErrorView(
      error: _error!,
      onRetry: _initializeCamera,
    );
  }
}
