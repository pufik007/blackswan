import 'package:test/test.dart';
import '../../../../lib/ui/camera_alt/exercises_counter.dart';

void main() {
  test('Exercises counter should be incremented', () {
    final counter = ExercisesCounter();

    var self = '';
    var config = '';
    var exercise = '';

    counter.init(config, exercise);
  });

  expect(ExercisesCounter, '');
}

//flutter test test\lib\ui\camera_alt\exercises_counter_test.dart
