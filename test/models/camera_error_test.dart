import 'package:flutter_test/flutter_test.dart';
import 'package:inside_mirror/models/camera_error.dart';

void main() {
  group('CameraErrorType', () {
    test('should have all required error types', () {
      // Verify all error types are defined
      expect(CameraErrorType.values.length, 5);
      expect(CameraErrorType.values, contains(CameraErrorType.permissionDenied));
      expect(CameraErrorType.values, contains(CameraErrorType.notAvailable));
      expect(CameraErrorType.values, contains(CameraErrorType.streamError));
      expect(CameraErrorType.values, contains(CameraErrorType.browserNotSupported));
      expect(CameraErrorType.values, contains(CameraErrorType.unknown));
    });
  });

  group('CameraError', () {
    test('should create error with message and type', () {
      final error = CameraError('Test error', CameraErrorType.unknown);
      
      expect(error.message, 'Test error');
      expect(error.type, CameraErrorType.unknown);
    });

    test('should have meaningful toString', () {
      final error = CameraError('Permission denied', CameraErrorType.permissionDenied);
      
      expect(error.toString(), contains('CameraError'));
      expect(error.toString(), contains('permissionDenied'));
      expect(error.toString(), contains('Permission denied'));
    });
  });
}
