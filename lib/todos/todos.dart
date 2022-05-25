import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/services/todo.dart';
import 'package:todo_app/todos/bloc/todos_bloc.dart';

class TodosPage extends StatelessWidget {
  final String username;

  const TodosPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: BlocProvider(
        create: (context) =>
            TodosBloc(RepositoryProvider.of<TodoService>(context))
              ..add(LoadTodosEvent(username)),
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoadedState) {
              return ListView(children: [
                ...state.tasks.map(
                  (e) => ListTile(
                    title: Text(e.task),
                    trailing: Checkbox(
                      value: e.completed,
                      onChanged: (_) {
                        BlocProvider.of<TodosBloc>(context)
                            .add(ToggleTodoEvent(e.task));
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Create New Task'),
                  trailing: const Icon(Icons.create),
                  onTap: () async {
                    final result = await showDialog<String>(
                        context: context,
                        builder: (context) => const Dialog(
                              child: CreateNewTask(),
                            ));

                    if (result != null) {
                      BlocProvider.of<TodosBloc>(context)
                          .add(AddTodoEvent(result));
                    }
                  },
                )
              ]);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({Key? key}) : super(key: key);

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final _inputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("What task do you want to create?"),
        TextField(
          controller: _inputController,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_inputController.text);
            },
            child: Text("Save"))
      ],
    );
  }
}
