# コントリビューションガイド

このプロジェクトへのコントリビューションを歓迎します！

## 始める前に

1. このリポジトリをフォーク
2. ローカルにクローン
   ```bash
   git clone https://github.com/YOUR_USERNAME/inside-mirror.git
   cd inside-mirror
   ```
3. 依存関係をインストール
   ```bash
   flutter pub get
   ```

## 開発フロー

1. 最新のmainブランチから新しいブランチを作成
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/your-feature
   ```

2. 変更を加える

3. テストを実行
   ```bash
   flutter test
   ```

4. 変更をコミット
   ```bash
   git add .
   git commit -m "✨ 機能の説明"
   ```

5. フォークしたリポジトリにプッシュ
   ```bash
   git push origin feature/your-feature
   ```

6. GitHubでプルリクエストを作成

## ブランチ命名規則

```
feature/機能名     # 新機能
fix/バグ名         # バグ修正
docs/内容          # ドキュメント
refactor/内容      # リファクタリング
```

## コミットメッセージ

絵文字プレフィックスを使用してください：

| 絵文字 | 用途 |
|--------|------|
| ✨ | 新機能 |
| 🐛 | バグ修正 |
| 📝 | ドキュメント |
| ♻️ | リファクタリング |
| 🚀 | デプロイ・CI/CD |
| 🔧 | 設定変更 |
| 🧪 | テスト |

## プルリクエスト

- 明確なタイトルと説明を記載してください
- 関連するIssueがあればリンクしてください
- テストが通ることを確認してください

## Issue

バグ報告や機能リクエストは[Issues](https://github.com/Kazuki-0731/inside-mirror/issues)からお願いします。

## 行動規範

- 他のコントリビューターに敬意を払ってください
- 建設的なフィードバックを心がけてください

## ライセンス

コントリビューションはMITライセンスの下で提供されます。
