import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inside_mirror/models/camera_error.dart';
import 'package:inside_mirror/widgets/error_view.dart';

void main() {
  group('ErrorView Widget Tests', () {
    testWidgets('権限拒否エラーで適切なメッセージが表示される', (WidgetTester tester) async {
      // 権限拒否エラーを作成
      final error = CameraError(
        'Permission denied by user',
        CameraErrorType.permissionDenied,
      );
      
      // ErrorViewをビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(error: error),
          ),
        ),
      );
      
      // タイトルが表示されることを確認
      expect(find.text('カメラへのアクセスが拒否されました'), findsOneWidget);
      
      // 説明メッセージが表示されることを確認
      expect(find.textContaining('カメラへのアクセス許可が必要です'), findsOneWidget);
      
      // 適切なアイコンが表示されることを確認
      expect(find.byIcon(Icons.block), findsOneWidget);
      
      // 権限拒否の場合は再試行ボタンが表示されないことを確認
      expect(find.text('再試行'), findsNothing);
    });

    testWidgets('カメラ利用不可エラーで適切なメッセージが表示される', (WidgetTester tester) async {
      // カメラ利用不可エラーを作成
      final error = CameraError(
        'Camera device not found',
        CameraErrorType.notAvailable,
      );
      
      // ErrorViewをビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(error: error),
          ),
        ),
      );
      
      // タイトルが表示されることを確認
      expect(find.text('カメラが利用できません'), findsOneWidget);
      
      // 説明メッセージが表示されることを確認
      expect(find.textContaining('カメラが接続されていないか'), findsOneWidget);
      
      // 適切なアイコンが表示されることを確認
      expect(find.byIcon(Icons.videocam_off), findsOneWidget);
    });

    testWidgets('ストリームエラーで適切なメッセージが表示される', (WidgetTester tester) async {
      // ストリームエラーを作成
      final error = CameraError(
        'Stream initialization failed',
        CameraErrorType.streamError,
      );
      
      // ErrorViewをビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(error: error),
          ),
        ),
      );
      
      // タイトルが表示されることを確認
      expect(find.text('カメラストリームエラー'), findsOneWidget);
      
      // 説明メッセージが表示されることを確認
      expect(find.textContaining('カメラストリームの取得中にエラーが発生しました'), findsOneWidget);
      
      // 適切なアイコンが表示されることを確認
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('不明なエラーで適切なメッセージが表示される', (WidgetTester tester) async {
      // 不明なエラーを作成
      final error = CameraError(
        'Unknown error occurred',
        CameraErrorType.unknown,
      );
      
      // ErrorViewをビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(error: error),
          ),
        ),
      );
      
      // タイトルが表示されることを確認
      expect(find.text('エラーが発生しました'), findsOneWidget);
      
      // 説明メッセージが表示されることを確認
      expect(find.textContaining('予期しないエラーが発生しました'), findsOneWidget);
      
      // 適切なアイコンが表示されることを確認
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('再試行ボタンが表示され、タップできる（ストリームエラー）', (WidgetTester tester) async {
      bool retryPressed = false;
      
      // ストリームエラーを作成
      final error = CameraError(
        'Stream error',
        CameraErrorType.streamError,
      );
      
      // ErrorViewをビルド（再試行コールバック付き）
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: error,
              onRetry: () {
                retryPressed = true;
              },
            ),
          ),
        ),
      );
      
      // 再試行ボタンが表示されることを確認
      expect(find.text('再試行'), findsOneWidget);
      
      // 再試行ボタンをタップ
      await tester.tap(find.text('再試行'));
      await tester.pump();
      
      // コールバックが呼ばれたことを確認
      expect(retryPressed, isTrue);
    });

    testWidgets('再試行ボタンが表示され、タップできる（カメラ利用不可）', (WidgetTester tester) async {
      bool retryPressed = false;
      
      // カメラ利用不可エラーを作成
      final error = CameraError(
        'Camera not available',
        CameraErrorType.notAvailable,
      );
      
      // ErrorViewをビルド（再試行コールバック付き）
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: error,
              onRetry: () {
                retryPressed = true;
              },
            ),
          ),
        ),
      );
      
      // 再試行ボタンが表示されることを確認
      expect(find.text('再試行'), findsOneWidget);
      
      // 再試行ボタンをタップ
      await tester.tap(find.text('再試行'));
      await tester.pump();
      
      // コールバックが呼ばれたことを確認
      expect(retryPressed, isTrue);
    });

    testWidgets('権限拒否エラーでは再試行ボタンが表示されない', (WidgetTester tester) async {
      // 権限拒否エラーを作成
      final error = CameraError(
        'Permission denied',
        CameraErrorType.permissionDenied,
      );
      
      // ErrorViewをビルド（再試行コールバック付き）
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: error,
              onRetry: () {},
            ),
          ),
        ),
      );
      
      // 再試行ボタンが表示されないことを確認
      expect(find.text('再試行'), findsNothing);
    });

    testWidgets('onRetryがnullの場合は再試行ボタンが表示されない', (WidgetTester tester) async {
      // ストリームエラーを作成
      final error = CameraError(
        'Stream error',
        CameraErrorType.streamError,
      );
      
      // ErrorViewをビルド（再試行コールバックなし）
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(error: error),
          ),
        ),
      );
      
      // 再試行ボタンが表示されないことを確認
      expect(find.text('再試行'), findsNothing);
    });

    testWidgets('技術的なエラーメッセージが表示される', (WidgetTester tester) async {
      // エラーを作成
      final error = CameraError(
        'Technical error message: getUserMedia failed',
        CameraErrorType.streamError,
      );
      
      // ErrorViewをビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(error: error),
          ),
        ),
      );
      
      // 技術的なエラーメッセージが表示されることを確認
      expect(find.textContaining('詳細: Technical error message'), findsOneWidget);
    });

    testWidgets('ブラウザ非対応エラーで適切なメッセージが表示される', (WidgetTester tester) async {
      // ブラウザ非対応エラーを作成
      final error = CameraError(
        'Browser does not support camera API',
        CameraErrorType.browserNotSupported,
      );
      
      // ErrorViewをビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(error: error),
          ),
        ),
      );
      
      // タイトルが表示されることを確認
      expect(find.text('ブラウザが対応していません'), findsOneWidget);
      
      // 説明メッセージが表示されることを確認
      expect(find.textContaining('お使いのブラウザはカメラAPIをサポートしていません'), findsOneWidget);
      
      // 適切なアイコンが表示されることを確認
      expect(find.byIcon(Icons.web_asset_off), findsOneWidget);
      
      // ブラウザ非対応の場合は再試行ボタンが表示されないことを確認
      expect(find.text('再試行'), findsNothing);
    });

    testWidgets('ブラウザ非対応エラーでは再試行ボタンが表示されない', (WidgetTester tester) async {
      // ブラウザ非対応エラーを作成
      final error = CameraError(
        'Browser not supported',
        CameraErrorType.browserNotSupported,
      );
      
      // ErrorViewをビルド（再試行コールバック付き）
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              error: error,
              onRetry: () {},
            ),
          ),
        ),
      );
      
      // 再試行ボタンが表示されないことを確認
      expect(find.text('再試行'), findsNothing);
    });

    testWidgets('すべてのエラータイプで適切なメッセージが表示される', (WidgetTester tester) async {
      // すべてのエラータイプをテスト
      final errorTypes = [
        CameraErrorType.permissionDenied,
        CameraErrorType.notAvailable,
        CameraErrorType.streamError,
        CameraErrorType.browserNotSupported,
        CameraErrorType.unknown,
      ];
      
      for (final errorType in errorTypes) {
        final error = CameraError(
          'Test error message',
          errorType,
        );
        
        // ErrorViewをビルド
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ErrorView(error: error),
            ),
          ),
        );
        
        // エラーメッセージが表示されることを確認
        expect(find.byType(ErrorView), findsOneWidget);
        
        // アイコンが表示されることを確認
        expect(find.byType(Icon), findsWidgets);
        
        // テキストが表示されることを確認
        expect(find.byType(Text), findsWidgets);
      }
    });
  });
}
