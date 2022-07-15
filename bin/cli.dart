// ignore_for_file: unused_element, unnecessary_null_comparison

import 'dart:io';

class TodoManeger {
  late File storege;
  late Map todos;

  TodoManeger(this.storege) {
    storege = storege;
    todos = getTodosFromStorege();
    checkExitsStorege();
  }
  Map getTodosFromStorege() {
    return {...storege.readAsLinesSync().asMap()};
  }

  void checkExitsStorege() {
    if (!storege.existsSync()) {
      storege.createSync();
    }
  }

  void addTodo(String text) {
    storege.writeAsStringSync(text + '\n', mode: FileMode.append);
  }

  void deleteTodo(int id) {
    todos.remove(id);
    storege.writeAsStringSync('');
    todos.forEach((key, value) {
      storege.writeAsStringSync(value + '\n', mode: FileMode.append);
    });
  }

  updateTodo(int id, String title) {
    var newTodos = todos.map((key, value) {
      if (key == id) {
        return MapEntry(key, title);
      } else {
        return MapEntry(key, value);
      }
    });
    storege.writeAsStringSync('');
    newTodos.forEach((key, value) {
      storege.writeAsStringSync(value + '\n', mode: FileMode.append);
    });
  }
}

class CommandHandler {
  Map<int, String> commands;
  CommandHandler({required this.commands});
  void getHelp() {
    print("""
TodoApp commands:
  --add, -a [title] :String             :"Add todo"
  --find, -f [id] :int                  :"Find a todo and return the text"
  --update -u [id] :int [title] :Srting :"Update a todo"
  --list, -l                            :"Show todoes list"
  --help, -h                            :"Show commands list"
""");
  }

  String getCommand(int key) {
    return commands[key] ?? '';
  }

  bool checkCommandExists(int key, {required String Function() message}) {
    if (commands[key] != null) {
      return true;
    }
    print(message());
    getHelp();
    return false;
  }
}

void main(List<String> args) {
  TodoManeger todoManeger = TodoManeger(File('./todoes.txt'));
  CommandHandler commandHandler = CommandHandler(commands: args.asMap());
  switch (commandHandler.getCommand(0)) {
    case '-a':
    case '-add':
      if (!commandHandler.checkCommandExists(1,
          message: () => "please enter your todo's title")) {
        break;
      }
      todoManeger.addTodo(commandHandler.getCommand(1));
      print('your todo added to your todo list');
      break;
    case '--list':
    case '-l':
      todoManeger.getTodosFromStorege().forEach((key, value) {
        print('id: $key   title: $value');
      });
      break;
    case '-d':
    case '--delete':
      if (!commandHandler.checkCommandExists(1,
          message: () => "please enter your todo's id")) {
        break;
      }
      int id = int.parse(commandHandler.getCommand(1));
      todoManeger.deleteTodo(id);
      print(todoManeger.todos);
      print('your todo deleted');

      break;
    case '-u':
    case '--update':
      if (!commandHandler.checkCommandExists(2,
          message: () => "please enter your todo's id and your new todo")) {
        break;
      }
      int id = int.parse(commandHandler.getCommand(1));
      String title = commandHandler.getCommand(2);
      todoManeger.updateTodo(id, title);
      print('your todo updated');
      break;
    case '--find':
    case '-f':
      var id = int.parse(commandHandler.getCommand(1));
      if (!commandHandler.checkCommandExists(1,
          message: () => "please enter your todo's id")) {
        break;
      }
      print('your todo is');
      var todo = todoManeger.todos[id];
      print(todo);

      break;
    case '--help':
    case '-h':
    case '':
      commandHandler.getHelp();
      break;
    default:
      commandHandler.getHelp();
      break;
  }
}
