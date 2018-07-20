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
  test('State is immutable', () {
    var origState = appState.current;

    todosState.change((old) => Todos(idCounter: old.idCounter, items: old.items));
    todosState.change((old) {
      // add a new item
      List<TodoData> items = List.from(old.items);
      items.add(TodoData(2, 't2', false));
      return Todos(
        idCounter: old.idCounter,
        items: items,
      );
    });

    var expectedState = origState.withTodos(origState.todos.withNewItem('t2'));

    expect(appState.onChange, emitsAnyOf([origState, expectedState]));
  });

  test('Todo(s) with same content are equal', () async {
    var todo1 = TodoData(1, 'title', true);
    var todo2 = TodoData(1, 'title', true);

    expect(todo1 == todo2, isTrue);
  });

  test('Todo(s) with different content are not equal', () async {
    var todo1 = TodoData(1, 'title', true);
    var todo2 = TodoData(1, 'title', true);

    expect(TodoData(2, 'title', true) == TodoData(1, 'title', true), isFalse);
    expect(TodoData(1, 'title1', true) == TodoData(1, 'title', true), isFalse);
    expect(TodoData(1, 'title', false) == TodoData(1, 'title', true), isFalse);
  });

  test('Todos items equality is OK', () async {
    var todo1 = TodoData(1, 'title', true);
    var todo2 = TodoData(2, 'title2', false);

    var list0 = Todos(idCounter: 0, items: [todo1, todo2]);
    var list1 = Todos(idCounter: 0, items: [todo1, todo2]);
    var list3 = Todos(idCounter: 0, items: [null, todo2]);
    var list4 = Todos(idCounter: 0, items: null);

    expect(list1 == list0, isTrue);
    expect(list1 == list1, isTrue);
    expect(list1 == list3, isFalse);
    expect(list1 == list4, isFalse);
  });

  test('Todos withNewItem adds a new element', () async {
    var todo1 = TodoData(1, 'title', true);
    var todo2 = TodoData(2, 'title2', false);

    var underTest = Todos(idCounter: 1, items: [todo1]).withNewItem(todo2.title);
    var expectedList = Todos(idCounter: 2, items: [todo1, todo2]);

    expect(underTest == expectedList, isTrue);
  });
}
