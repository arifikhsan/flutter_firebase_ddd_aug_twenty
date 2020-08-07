import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_aug/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:flutter_firebase_ddd_aug/injection.dart';
import 'package:flutter_firebase_ddd_aug/presentation/sign_in/widget/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider(
        create: (context) => getIt<SignInFormBloc>(),
        child: SignInForm(),
      ),
    );
  }
}
