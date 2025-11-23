# 設計書

## 概要

カメラミラーWebアプリケーションは、Flutter Webを使用して構築され、ブラウザのMediaStream APIを通じてユーザーのフロントカメラにアクセスします。映像は左右反転されて表示され、実際の鏡のような体験を提供します。

このアプリケーションは、シンプルで直感的なUIを持ち、カメラ権限の管理、エラーハンドリング、レスポンシブデザインを実装します。

## アーキテクチャ

### 技術スタック

- **フレームワーク**: Flutter Web (Dart 3.10+)
- **カメラアクセス**: `dart:html` の MediaStream API
- **状態管理**: StatefulWidget（シンプルなアプリケーションのため）
- **UI**: Material Design

### アーキテクチャパターン

アプリケーションは以下のレイヤーに分割されます：

1. **Presentation Layer** (UI)
   - `MirrorScreen`: メイン画面ウィジェット
   - `CameraView`: カメラ映像表示ウィジェット
   - `ErrorView`: エラー表示ウィジェット

2. **Service Layer**
   - `CameraService`: カメラアクセスとストリーム管理を担当

3. **Model Layer**
   - `CameraState`: カメラの状態を表現するモデル

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  ┌──────────┐  ┌──────────────┐   │
│  │  Mirror  │  │  CameraView  │   │
│  │  Screen  │  │  ErrorView   │   │
│  └────┬─────┘  └──────────────┘   │
└───────┼──────────────────────────────┘
        │
┌───────┼──────────────────────────────┐
│       │   Service Layer              │
│  ┌────▼──────────┐                  │
│  │ CameraService │                  │
│  └────┬──────────┘                  │
└───────┼──────────────────────────────┘
        │
┌───────┼──────────────────────────────┐
│       │   Browser API                │
│  ┌────▼──────────────┐              │
│  │ MediaStream API   │              │
│  │ (getUserMedia)    │              │
│  └───────────────────┘              │
└─────────────────────────────────────┘
```

## コンポーネントとインターフェース

### CameraService

カメラへのアクセスとストリーム管理を担当するサービスクラス。

```dart
class CameraService {
  MediaStream? _stream;
  VideoElement? _videoElement;
  
  // カメラストリームを初期化
  Future<void> initialize();
  
  // カメラストリームを停止
  void dispose();
  
  // ビデオエレメントを取得
  VideoElement? get videoElement;
  
  // カメラが利用可能かチェック
  bool get isAvailable;
}
```

### CameraState

カメラの現在の状態を表現する列挙型。

```dart
enum CameraState {
  initial,      // 初期状態
  requesting,   // 権限要求中
  active,       // カメラアクティブ
  error,        // エラー状態
  denied,       // 権限拒否
}
```

### MirrorScreen

メイン画面ウィジェット。カメラの状態に応じて適切なUIを表示します。

```dart
class MirrorScreen extends StatefulWidget {
  // カメラサービスのインスタンス
  final CameraService _cameraService;
  
  // 現在のカメラ状態
  CameraState _state;
  
  // エラーメッセージ
  String? _errorMessage;
  
  @override
  void initState();
  
  @override
  void dispose();
  
  Future<void> _initializeCamera();
}
```

### CameraView

カメラ映像を表示するウィジェット。HtmlElementViewを使用してVideoElementを埋め込みます。

```dart
class CameraView extends StatelessWidget {
  final VideoElement videoElement;
  
  @override
  Widget build(BuildContext context);
}
```

## データモデル

### CameraState

```dart
enum CameraState {
  initial,
  requesting,
  active,
  error,
  denied,
}
```

### CameraError

```dart
class CameraError {
  final String message;
  final CameraErrorType type;
  
  CameraError(this.message, this.type);
}

enum CameraErrorType {
  permissionDenied,
  notAvailable,
  streamError,
  unknown,
}
```

## 正確性プロパティ


*プロパティとは、システムのすべての有効な実行において真であるべき特性または動作のことです。本質的には、システムが何をすべきかについての形式的な記述です。プロパティは、人間が読める仕様と機械で検証可能な正確性保証との橋渡しとなります。*

### プロパティ 1: カメラ初期化後のストリーム開始

*任意の*カメラ権限付与イベントに対して、カメラサービスの初期化が成功した場合、カメラストリームがアクティブ状態になり、VideoElementが利用可能になるべきです。

**検証対象: 要件 1.2**

### プロパティ 2: 鏡像変換の適用

*任意の*アクティブなカメラストリームに対して、表示されるビデオエレメントには水平反転変換（scaleX(-1)）が適用されているべきです。

**検証対象: 要件 2.1**

### プロパティ 3: アスペクト比の保持

*任意の*カメラストリームに対して、Mirror Viewに表示される映像のアスペクト比は、元のカメラストリームのアスペクト比と一致するべきです。

**検証対象: 要件 2.2**

### プロパティ 4: レスポンシブレイアウトの維持

*任意の*ビューポートサイズまたはデバイス向きに対して、Mirror Viewは利用可能なスペースに適切にスケーリングされ、画面の中央に配置されるべきです。

**検証対象: 要件 3.1, 3.2, 3.3**

### プロパティ 5: リソースの適切な解放

*任意の*カメラサービスのdispose呼び出しに対して、すべてのカメラストリームが停止され、VideoElementが破棄され、関連するすべてのリソースが解放されるべきです。

**検証対象: 要件 4.1, 4.2**

### プロパティ 6: エラー時のメッセージ表示

*任意の*カメラ初期化エラーに対して、システムはユーザーフレンドリーなエラーメッセージを表示し、エラーの種類に応じた適切な説明を提供するべきです。

**検証対象: 要件 5.1**

### プロパティ 7: ストリーム中断時の再接続試行

*任意の*予期しないカメラストリーム中断に対して、システムは自動的に再接続を試み、ユーザーに現在の状態を通知するべきです。

**検証対象: 要件 5.2**

### プロパティ 8: エラーのロギング

*任意の*カメラ関連エラーに対して、システムはエラーの詳細（タイプ、メッセージ、タイムスタンプ）をログに記録するべきです。

**検証対象: 要件 5.3**

## エラーハンドリング

### エラータイプ

1. **Permission Denied**: ユーザーがカメラ権限を拒否した場合
   - ユーザーに権限が必要であることを説明するメッセージを表示
   - ブラウザ設定でカメラ権限を有効にする方法を案内

2. **Camera Not Available**: カメラデバイスが利用できない場合
   - カメラが接続されていないか、他のアプリケーションで使用中であることを通知
   - 利用可能なカメラデバイスの確認を促す

3. **Stream Error**: カメラストリームの取得または処理中にエラーが発生した場合
   - 一般的なエラーメッセージを表示
   - 再試行オプションを提供

4. **Browser Not Supported**: ブラウザがMediaStream APIをサポートしていない場合
   - サポートされているブラウザのリストを表示
   - 最新のブラウザへのアップデートを推奨

### エラー回復戦略

- **自動再接続**: ストリームが予期せず中断された場合、最大3回まで自動的に再接続を試みる
- **ユーザー通知**: エラー状態をユーザーに明確に伝え、必要に応じて手動での再試行オプションを提供
- **グレースフルデグラデーション**: カメラが利用できない場合でも、アプリケーションがクラッシュせず、適切なフィードバックを提供

## テスト戦略

### 単体テスト

単体テストは以下をカバーします：

- **CameraService**: 
  - カメラ初期化ロジック
  - リソース解放ロジック
  - エラーハンドリング

- **状態管理**:
  - CameraStateの遷移
  - エラー状態の処理

- **エッジケース**:
  - カメラが利用できない場合
  - 権限が拒否された場合
  - ブラウザがAPIをサポートしていない場合

### プロパティベーステスト

プロパティベーステストには、Dartの`test`パッケージと`fake_async`を使用します。各プロパティベーステストは最低100回の反復を実行するように設定します。

各プロパティベーステストには、設計書の正確性プロパティを明示的に参照するコメントタグを付けます。タグの形式は以下の通りです：
`**Feature: camera-mirror, Property {番号}: {プロパティテキスト}**`

プロパティベーステストは以下をカバーします：

- **プロパティ 1**: カメラ初期化後のストリーム開始
- **プロパティ 2**: 鏡像変換の適用
- **プロパティ 3**: アスペクト比の保持
- **プロパティ 4**: レスポンシブレイアウトの維持
- **プロパティ 5**: リソースの適切な解放
- **プロパティ 6**: エラー時のメッセージ表示
- **プロパティ 7**: ストリーム中断時の再接続試行
- **プロパティ 8**: エラーのロギング

### 統合テスト

統合テストは以下をカバーします：

- エンドツーエンドのカメラアクセスフロー
- 実際のブラウザ環境でのカメラ権限処理
- 複数のブラウザでの互換性確認

### テストツール

- **単体テスト**: `test` パッケージ
- **ウィジェットテスト**: `flutter_test` パッケージ
- **モック**: `mockito` パッケージ（必要に応じて）
- **統合テスト**: `integration_test` パッケージ

## 実装の詳細

### カメラアクセスの実装

Flutter Webでは、`dart:html`を使用してブラウザのMediaStream APIに直接アクセスします：

```dart
import 'dart:html' as html;

Future<html.MediaStream> getCameraStream() async {
  final constraints = {
    'video': {
      'facingMode': 'user', // フロントカメラを指定
    }
  };
  
  return await html.window.navigator.mediaDevices!.getUserMedia(constraints);
}
```

### 鏡像表示の実装

CSSのtransformプロパティを使用して水平反転を実現します：

```dart
videoElement.style.transform = 'scaleX(-1)';
```

### HtmlElementViewの使用

Flutter WebでHTMLエレメントを埋め込むには、`HtmlElementView`を使用します：

```dart
// VideoElementを登録
ui.platformViewRegistry.registerViewFactory(
  'video-element',
  (int viewId) => videoElement,
);

// ウィジェットツリーに埋め込む
HtmlElementView(
  viewType: 'video-element',
)
```

## パフォーマンス考慮事項

1. **メモリ管理**: VideoElementとMediaStreamは適切に破棄し、メモリリークを防ぐ
2. **レンダリング最適化**: 不要な再描画を避けるため、StatefulWidgetの状態管理を適切に行う
3. **ストリーム処理**: カメラストリームは直接VideoElementに接続し、Dartでの追加処理を最小限に抑える

## セキュリティ考慮事項

1. **HTTPS必須**: カメラアクセスにはHTTPS接続が必要（開発環境ではlocalhostも可）
2. **権限管理**: ユーザーの明示的な許可なしにカメラにアクセスしない
3. **データプライバシー**: カメラ映像はローカルでのみ処理し、外部に送信しない

## 依存関係

### 追加パッケージ

現時点では、標準のFlutter SDKとDart SDKのみを使用します。追加のサードパーティパッケージは不要です。

### ブラウザAPI依存

- `navigator.mediaDevices.getUserMedia()`: カメラストリームの取得
- `VideoElement`: 映像の表示
- `MediaStream`: ストリームの管理

## デプロイメント

### ビルド設定

```bash
flutter build web --release
```

### ホスティング要件

- HTTPS対応のWebサーバー
- 静的ファイルホスティング（Firebase Hosting, Netlify, Vercelなど）

### ブラウザ要件

- Chrome 53+
- Firefox 36+
- Safari 11+
- Edge 79+
