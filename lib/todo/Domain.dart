class TodoData {
  final int id;
  final String title;
  final bool done;

  const TodoData(this.id, this.title, this.done);

  TodoData withTitle(String title) {
    return new TodoData(this.id, title, this.done);
  }

  TodoData withDone(bool done) {
    return new TodoData(this.id, this.title, done);
  }
}

enum ConfigMenuItems { About, Config, DisplayFinished }
