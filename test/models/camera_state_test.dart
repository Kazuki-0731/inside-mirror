import 'package:flutter_test/flutter_test.dart';
import 'package:inside_mirror/models/camera_state.dart';

void main() {
  group('CameraState', () {
    test('should have all required states', () {
      // Verify all states are defined
      expect(CameraState.values.length, 5);
      expect(CameraState.values, contains(CameraState.initial));
      expect(CameraState.values, contains(CameraState.requesting));
      expect(CameraState.values, contains(CameraState.active));
      expect(CameraState.values, contains(CameraState.error));
      expect(CameraState.values, contains(CameraState.denied));
    });
  });
}
