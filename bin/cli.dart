// ignore_for_file: unused_element, unnecessary_null_comparison

import 'dart:io';

class TodoManeger {
  late File storege;
  late Map todos;

  TodoManeger(this.storege) {
    storege = storege;
    todos = getTodosFromStorege();
  }
  Map getTodosFromStorege() {
    return {...storege.readAsLinesSync().asMap()};
  }

  void checkExitStorege() {
    if (!storege.existsSync()) {
      storege.createSync();
    }
    // ignore: non_constant_identifier_names
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
}

void main(List<String> args) {
  TodoManeger todoManeger = TodoManeger(File('./todoes.txt'));
  CommandHandler commandHandler = CommandHandler(commands: args.asMap());

  final command = args[0];
  switch (command) {
    case '-a':
    case '-add':
      if (args.length == 2) {
        todoManeger.addTodo(args[1]);
        print('your todo added to your todo list');
      } else {
        print('pelese enter your todo\'s title');
        commandHandler.getHelp();
      }
      break;
    case '--list':
    case '-l':
      todoManeger.getTodosFromStorege().forEach((key, value) {
        print('id: $key   title: $value');
      });
      break;
    case '-d':
    case '--delete':
      if (args.length == 2) {
        int id = int.parse(args[1]);
        todoManeger.deleteTodo(id);
        print('your todo deleted');
      } else {
        print('pelese enter your todo\'s id');
        commandHandler.getHelp();
      }
      print(todoManeger.todos);
      break;
    case '-u':
    case '--update':
      if (args.length != 3) {
        print('pelese enter your todo\'s id and  the new title');
        commandHandler.getHelp();
        return;
      }
      int id = int.parse(args[1]);
      String title = args[2];
      todoManeger.updateTodo(id, title);
      print('your todo updated');
      break;
    case '--find':
    case '-f':
      var id = int.parse(args[1]);
      if (args.length == 2) {
        print('your todo is');
        var todo = todoManeger.todos[id];
        print(todo);
      }
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
