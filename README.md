# Inside Mirror

Flutter Webで構築されたカメラミラーアプリケーションです。

[![Netlify Status](https://api.netlify.com/api/v1/badges/a361f795-8398-4f2d-819e-3d23285d94b3/deploy-status)](https://app.netlify.com/projects/inside-mirror/deploys)
[![Deploy to Netlify](https://github.com/Kazuki-0731/inside-mirror/actions/workflows/deploy.yml/badge.svg)](https://github.com/Kazuki-0731/inside-mirror/actions/workflows/deploy.yml)

## デモ

**https://inside-mirror.netlify.app/**

## 概要

ブラウザのMediaStream APIを使用してフロントカメラにアクセスし、映像を左右反転して表示することで、実際の鏡のような体験を提供します。

## 機能

- フロントカメラの映像をリアルタイム表示
- 鏡像（左右反転）表示
- レスポンシブデザイン対応
- カメラ権限の管理
- エラーハンドリング

## アーキテクチャ

```
┌─────────────────────────────────────┐
│      Presentation Layer             │
│  - MirrorScreen                     │
│  - CameraView                       │
│  - ErrorView                        │
└─────────────────────────────────────┘
                 │
┌─────────────────────────────────────┐
│      Service Layer                  │
│  - CameraService                    │
└─────────────────────────────────────┘
                 │
┌─────────────────────────────────────┐
│      Browser API                    │
│  - MediaStream API                  │
└─────────────────────────────────────┘
```

## ディレクトリ構成

```
lib/
├── main.dart           # エントリーポイント
├── models/             # データモデル
│   ├── camera_state.dart
│   └── camera_error.dart
├── screens/            # 画面
│   └── mirror_screen.dart
├── services/           # サービス
│   └── camera_service.dart
└── widgets/            # ウィジェット
    ├── camera_view.dart
    └── error_view.dart
```

## 動作要件

### ブラウザ

- Chrome 53+
- Firefox 36+
- Safari 11+
- Edge 79+

### その他

- HTTPS接続（開発環境ではlocalhostも可）

## セットアップ

```bash
# 依存関係のインストール
flutter pub get

# 開発サーバー起動
flutter run -d chrome

# ビルド
flutter build web --release
```

## テスト

```bash
flutter test
```

## ホスティング

- **サービス**: Netlify（GitHub連携による自動デプロイ）
- **URL**: https://inside-mirror.netlify.app/

## ライセンス

MIT
