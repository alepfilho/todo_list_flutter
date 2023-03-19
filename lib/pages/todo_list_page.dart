import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: TextField(
                              controller: todoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nova tarefa',
                                  hintText: 'Ex: estudar flutter'),
                            )),
                            const SizedBox(
                              width: 15,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                String text = todoController.text;
                                setState(() {
                                  Todo newTodo = Todo(
                                      title: text, dateTime: DateTime.now());
                                  todos.add(newTodo);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: const EdgeInsets.all(22)),
                              child: const Icon(Icons.add),
                            )
                          ],
                        ),
                        const SizedBox(height: 50),
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (Todo todo in todos)
                                TodoListItem(
                                  todo: todo,
                                  onDelete: onDelete,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                                    'Você possui ${todos.length} tarefas pendentes')),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              const Text(
                                                  'Tem certeza que deseja apagar todos os itens?'),
                                              const SizedBox(height: 20),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.amber,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(22)),
                                                    child:
                                                        const Text('Cancelar'),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  const SizedBox(
                                                    width: 50,
                                                  ),
                                                  OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .amber),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(22)),
                                                    onPressed: () {
                                                      setState(() {
                                                        todos.clear();
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Confirmar',
                                                      style: TextStyle(
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: const EdgeInsets.all(13)),
                              child: const Text(
                                'Limpar tudo',
                                style: TextStyle(fontSize: 10),
                              ),
                            )
                          ],
                        )
                      ],
                    )))));
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tarefa ${todo.title} apagada.',
      ),
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: Colors.amber,
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
        },
      ),
      duration: const Duration(seconds: 5),
    ));
  }
}
