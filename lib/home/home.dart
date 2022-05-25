import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/home/bloc/home_bloc.dart';
import 'package:todo_app/services/authentication.dart';
import 'package:todo_app/services/todo.dart';
import 'package:todo_app/todos/todos.dart';

class HomePage extends StatelessWidget {
  final TextEditingController usernameField = TextEditingController();
  final TextEditingController passwordField = TextEditingController();
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login to Todo App')),
      body: BlocProvider(
        create: (context) => HomeBloc(
          RepositoryProvider.of<AuthenticationService>(context),
          RepositoryProvider.of<TodoService>(context),
        )..add(RegisterServicesEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SuccessfulLoginState) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TodosPage(username: state.username)));
            }

            if (state is HomeInitial) {
              if (state.error != null) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Error"),
                          content: Text(state.error!),
                        ));
              }
            }
          },
          builder: (context, state) {
            if (state is HomeInitial) {
              return Column(
                children: [
                  TextField(
                    controller: usernameField,
                    decoration: const InputDecoration(
                      labelText: "Username",
                    ),
                  ),
                  TextField(
                    controller: passwordField,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () => BlocProvider.of<HomeBloc>(context)
                                .add(LoginEvent(
                                    usernameField.text, passwordField.text)),
                            child: Text("Login")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<HomeBloc>(context).add(
                                  RegisterAccountEvent(
                                      usernameField.text, passwordField.text));
                            },
                            child: Text("Register")),
                      ),
                    ],
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
