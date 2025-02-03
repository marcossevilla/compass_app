import 'package:authentication_repository/authentication_repository.dart';
import 'package:compass_app/l10n/l10n.dart';
import 'package:compass_app/login/login.dart';
import 'package:compass_app/routing/routing.dart';
import 'package:compass_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _email = TextEditingController(text: 'email@example.com');
  final _password = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dimensions = context.dimensions;
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) => switch (state.status) {
        LoginStatus.initial => () {},
        LoginStatus.loading => () {},
        LoginStatus.success => context.go(Routes.home),
        LoginStatus.failure => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorWhileLogin),
              action: SnackBarAction(
                label: l10n.tryAgain,
                onPressed: () async {
                  await context
                      .read<LoginCubit>()
                      .login((_email.value.text, _password.value.text));
                },
              ),
            ),
          ),
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const TiltedCards(),
            Padding(
              padding: dimensions.edgeInsetsScreenSymmetric,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _email,
                  ),
                  SizedBox(height: dimensions.paddingVertical),
                  TextField(
                    controller: _password,
                    obscureText: true,
                  ),
                  SizedBox(height: dimensions.paddingVertical),
                  FilledButton(
                    onPressed: () => context
                        .read<LoginCubit>()
                        .login((_email.value.text, _password.value.text)),
                    child: Text(l10n.login),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
