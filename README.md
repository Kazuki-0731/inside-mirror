# ポケット手鏡

スマホのカメラを使った手鏡アプリ。いつでもどこでもサッと身だしなみチェック。

[![Deploy to Netlify](https://github.com/Kazuki-0731/inside-mirror/actions/workflows/deploy.yml/badge.svg)](https://github.com/Kazuki-0731/inside-mirror/actions/workflows/deploy.yml)
[![Netlify Status](https://api.netlify.com/api/v1/badges/a361f795-8398-4f2d-819e-3d23285d94b3/deploy-status)](https://app.netlify.com/projects/inside-mirror/deploys)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Web%20%7C%20PWA-lightgrey.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.32%2B-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.8%2B-0175C2?logo=dart)

## デモ

**https://inside-mirror.netlify.app/**

## 機能

- フロントカメラの映像をリアルタイム表示
- 鏡像（左右反転）表示 / 通常表示の切り替え
- 全画面表示対応
- PWA対応（ホーム画面に追加可能）
- レスポンシブデザイン

## PWA

このアプリはPWA（Progressive Web App）に対応しています。

- ホーム画面に追加してネイティブアプリのように使用可能
- スタンドアロンモードで起動
- オフラインキャッシュ対応

### インストール方法

**iOS Safari:**
1. デモURLにアクセス
2. 共有ボタン → 「ホーム画面に追加」

**Android Chrome:**
1. デモURLにアクセス
2. メニュー → 「ホーム画面に追加」または表示されるインストールバナーをタップ

## 技術スタック

- Flutter Web
- Dart
- MediaStream API

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

- **サービス**: Netlify（GitHub Actions経由で自動デプロイ）
- **URL**: https://inside-mirror.netlify.app/

## コントリビューション

コントリビューションを歓迎します。詳細は[CONTRIBUTING.md](CONTRIBUTING.md)をご覧ください。

## ライセンス

[MIT License](LICENSE)

Copyright (c) 2025 Kazuki-0731
