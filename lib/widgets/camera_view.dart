import 'dart:html' as html;
import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

/// カメラ映像を表示するウィジェット
class CameraView extends StatefulWidget {
  /// VideoElement
  final html.VideoElement videoElement;

  /// アスペクト比（オプション、指定しない場合はVideoElementから取得）
  final double? aspectRatio;

  /// 鏡像表示かどうか
  final bool isMirrored;

  /// コンストラクタ
  const CameraView({
    Key? key,
    required this.videoElement,
    this.aspectRatio,
    this.isMirrored = true,
  }) : super(key: key);
  
  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  /// ビューのユニークID
  late String _viewId;

  @override
  void initState() {
    super.initState();
    // ユニークなビューIDを生成
    _viewId = 'video-element-${widget.videoElement.hashCode}';

    // platformViewRegistryにVideoElementを登録
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => widget.videoElement,
    );

    // 初期のミラー状態を適用
    _updateMirrorTransform();
  }

  @override
  void didUpdateWidget(CameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMirrored != widget.isMirrored) {
      _updateMirrorTransform();
    }
  }

  /// ミラー変換を更新
  void _updateMirrorTransform() {
    widget.videoElement.style.transform = widget.isMirrored ? 'scaleX(-1)' : 'scaleX(1)';
  }
  
  /// VideoElementからアスペクト比を計算
  double _getAspectRatio() {
    // 明示的に指定されたアスペクト比があればそれを使用
    if (widget.aspectRatio != null) {
      return widget.aspectRatio!;
    }
    
    // VideoElementの幅と高さから計算
    final width = widget.videoElement.videoWidth;
    final height = widget.videoElement.videoHeight;
    
    // 幅と高さが有効な場合はアスペクト比を計算
    if (width > 0 && height > 0) {
      return width / height;
    }
    
    // デフォルトは16:9
    return 16 / 9;
  }
  
  @override
  Widget build(BuildContext context) {
    // AspectRatioウィジェットを使用して元のアスペクト比を維持
    return AspectRatio(
      aspectRatio: _getAspectRatio(),
      child: HtmlElementView(
        viewType: _viewId,
      ),
    );
  }
}
