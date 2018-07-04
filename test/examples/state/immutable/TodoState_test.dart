import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_app/examples/state/immutable/TodoState.dart';

void main() {
  test('Todos are equal but not identical', () async {
    var undertest = new TodoData(1, 'title', true);
    var undertest2 = new TodoData(1, 'title', true);
    print(undertest.hashCode);
    print(undertest2.hashCode);
    expect(undertest == undertest2, isTrue);
    expect(identical(undertest, undertest2), isFalse);
  });

  test('State is immutable', () async {
    var undertest = state;

//    expect(state. == undertest2, isTrue);
//    expect(identical(undertest, undertest2), isFalse);
  });
}
