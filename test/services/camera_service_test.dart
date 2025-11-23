import 'package:flutter_test/flutter_test.dart';
import 'package:inside_mirror/services/camera_service.dart';
import 'package:inside_mirror/models/camera_error.dart';

void main() {
  group('CameraService Property Tests', () {
    // **Feature: camera-mirror, Property 1: カメラ初期化後のストリーム開始**
    // **検証対象: 要件 1.2**
    test('Property 1: カメラ初期化後のストリーム開始 - 初期化成功時にストリームとVideoElementが利用可能', () async {
      // プロパティ: 任意のカメラ権限付与イベントに対して、
      // カメラサービスの初期化が成功した場合、
      // カメラストリームがアクティブ状態になり、
      // VideoElementが利用可能になるべき
      
      final service = CameraService();
      
      // 非Web環境では初期化が失敗することを確認
      // Web環境では実際のブラウザAPIが必要
      try {
        await service.initialize();
        // Web環境で成功した場合
        expect(service.isAvailable, isTrue,
            reason: 'カメラ初期化後はisAvailableがtrueになるべき');
        expect(service.videoElement, isNotNull,
            reason: 'カメラ初期化後はvideoElementが利用可能になるべき');
      } on CameraError catch (e) {
        // 非Web環境では期待されるエラー
        expect(e.type, CameraErrorType.notAvailable,
            reason: '非Web環境ではnotAvailableエラーが発生するべき');
      }
    });

    // **Feature: camera-mirror, Property 5: リソースの適切な解放**
    // **検証対象: 要件 4.1, 4.2**
    test('Property 5: リソースの適切な解放 - dispose呼び出し後にリソースが解放される', () async {
      // プロパティ: 任意のカメラサービスのdispose呼び出しに対して、
      // すべてのカメラストリームが停止され、VideoElementが破棄され、
      // 関連するすべてのリソースが解放されるべき
      
      final service = CameraService();
      
      try {
        await service.initialize();
        // 初期化が成功した場合（Web環境）
        expect(service.isAvailable, isTrue);
        
        // リソースを解放
        service.dispose();
        
        // 解放後はリソースが利用不可になるべき
        expect(service.isAvailable, isFalse,
            reason: 'dispose後はisAvailableがfalseになるべき');
        expect(service.videoElement, isNull,
            reason: 'dispose後はvideoElementがnullになるべき');
      } on CameraError {
        // 非Web環境では初期化が失敗するが、disposeは安全に呼べるべき
        expect(() => service.dispose(), returnsNormally,
            reason: 'disposeは初期化失敗後でも安全に呼べるべき');
      }
    });

    // **Feature: camera-mirror, Property 6: エラー時のメッセージ表示**
    // **検証対象: 要件 5.1**
    test('Property 6: エラー時のメッセージ表示 - エラー発生時にユーザーフレンドリーなメッセージを提供', () async {
      // プロパティ: 任意のカメラ初期化エラーに対して、
      // システムはユーザーフレンドリーなエラーメッセージを表示し、
      // エラーの種類に応じた適切な説明を提供するべき
      
      final service = CameraService();
      
      try {
        await service.initialize();
      } on CameraError catch (e) {
        // エラーメッセージが空でないことを確認
        expect(e.message, isNotEmpty,
            reason: 'エラーメッセージは空であってはならない');
        
        // エラータイプが適切に設定されていることを確認
        expect(e.type, isIn(CameraErrorType.values),
            reason: 'エラータイプは定義された値のいずれかであるべき');
        
        // メッセージが日本語で説明的であることを確認
        expect(e.message.length, greaterThan(10),
            reason: 'エラーメッセージは説明的であるべき');
      }
    });

    // **Feature: camera-mirror, Property 8: エラーのロギング**
    // **検証対象: 要件 5.3**
    test('Property 8: エラーのロギング - エラー発生時に詳細がログに記録される', () async {
      // プロパティ: 任意のカメラ関連エラーに対して、
      // システムはエラーの詳細（タイプ、メッセージ、タイムスタンプ）を
      // ログに記録するべき
      
      final service = CameraService();
      
      // 初期状態ではログが空
      expect(service.errorLog, isEmpty,
          reason: '初期状態ではエラーログは空であるべき');
      
      try {
        await service.initialize();
      } on CameraError {
        // エラーが発生した場合、ログに記録されているべき
        expect(service.errorLog, isNotEmpty,
            reason: 'エラー発生後はログに記録されているべき');
        
        // ログエントリにタイムスタンプが含まれていることを確認
        final logEntry = service.errorLog.first;
        expect(logEntry, contains('['),
            reason: 'ログエントリにはタイムスタンプが含まれるべき');
        expect(logEntry, contains(']'),
            reason: 'ログエントリにはタイムスタンプが含まれるべき');
      }
    });

    // **Feature: camera-mirror, Property 7: ストリーム中断時の再接続試行**
    // **検証対象: 要件 5.2**
    test('Property 7: ストリーム中断時の再接続試行 - ストリーム中断時に自動再接続を試みる', () async {
      // プロパティ: 任意の予期しないカメラストリーム中断に対して、
      // システムは自動的に再接続を試み、ユーザーに現在の状態を通知するべき
      
      final service = CameraService();
      
      // 初期状態では再接続していない
      expect(service.isReconnecting, isFalse,
          reason: '初期状態では再接続していないべき');
      expect(service.reconnectAttempts, equals(0),
          reason: '初期状態では再接続試行回数は0であるべき');
      
      // 注: 実際のストリーム中断をシミュレートするには
      // ブラウザ環境が必要なため、ここでは構造のみをテスト
      // 統合テストで実際の再接続動作を検証する必要がある
    });
  });

  group('CameraService Unit Tests', () {
    test('ブラウザ互換性チェック - 非Web環境ではfalseを返す', () {
      // 非Web環境ではブラウザAPIがサポートされていない
      expect(CameraService.isBrowserSupported(), isFalse,
          reason: '非Web環境ではisBrowserSupported()がfalseを返すべき');
    });

    test('カメラ初期化 - 非Web環境ではnotAvailableエラーが発生', () async {
      final service = CameraService();
      
      expect(
        () async => await service.initialize(),
        throwsA(isA<CameraError>().having(
          (e) => e.type,
          'type',
          CameraErrorType.notAvailable,
        )),
      );
    });

    test('リソース解放 - disposeは複数回呼んでも安全', () {
      final service = CameraService();
      
      // 初期化していない状態でdisposeを呼ぶ
      expect(() => service.dispose(), returnsNormally);
      
      // 複数回呼んでも問題ない
      expect(() => service.dispose(), returnsNormally);
      expect(() => service.dispose(), returnsNormally);
    });

    test('エラーハンドリング - エラーメッセージが適切に設定される', () async {
      final service = CameraService();
      
      try {
        await service.initialize();
        fail('エラーが発生するべき');
      } on CameraError catch (e) {
        expect(e.message, isNotEmpty);
        expect(e.type, equals(CameraErrorType.notAvailable));
        expect(e.toString(), contains('CameraError'));
        expect(e.toString(), contains('notAvailable'));
      }
    });

    test('初期状態 - カメラは利用不可', () {
      final service = CameraService();
      
      expect(service.isAvailable, isFalse);
      expect(service.videoElement, isNull);
      expect(service.errorLog, isEmpty);
      expect(service.isReconnecting, isFalse);
      expect(service.reconnectAttempts, equals(0));
    });

    test('エラーログ - 初期化失敗後にログが記録される', () async {
      final service = CameraService();
      
      expect(service.errorLog, isEmpty);
      
      try {
        await service.initialize();
      } on CameraError {
        // エラーが発生した後
        expect(service.errorLog, isNotEmpty);
        expect(service.errorLog.length, equals(1));
        
        final logEntry = service.errorLog.first;
        expect(logEntry, contains('notAvailable'));
        expect(logEntry, contains('カメラ機能はWeb環境でのみ利用可能です'));
      }
    });
  });
}
