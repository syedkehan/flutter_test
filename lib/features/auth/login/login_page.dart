import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_button.dart';
import 'package:flutter_test_app/core/widgets/app_text_form_field.dart';
import 'package:flutter_test_app/data/datasources/auth/dummy_auth_data_source.dart';
import 'package:flutter_test_app/data/models/auth/login_model.dart';
import 'package:flutter_test_app/features/auth/login/login_state.dart';
import 'package:flutter_test_app/features/auth/signup/signup_initial_params.dart';
import 'package:flutter_test_app/features/auth/widget/auth_field_label.dart';
import 'package:flutter_test_app/features/auth/widget/auth_logo.dart';
import 'package:flutter_test_app/features/auth/widget/auth_switch_link.dart';

import 'login_cubit.dart';

class LoginPage extends StatefulWidget {
  final LoginCubit cubit;

  const LoginPage({super.key, required this.cubit});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  LoginCubit get cubit => widget.cubit;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(
    text: DummyAuthDataSource.demoEmail,
  );
  final _passwordController = TextEditingController(
    text: DummyAuthDataSource.demoPassword,
  );

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    cubit.close();
    super.dispose();
  }

  void _submit() {
    context.hideKeyboard();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    cubit.login(
      body: LoginModel(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        cubit.goBack(context);
      },
      child: Scaffold(
        body: Container(
          color: context.colorScheme.surface,
          child: CustomScrollView(
            slivers: [
              AppConstants.silverAppBar(
                context: context,
                showBackButton: true,
                onBackPressed: () => cubit.goBack(context),
                title: 'Sign In',
                subtitle: 'Welcome back to your account',
              ),
              AppConstants.sliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AuthLogo(),
                      24.verticalSpace,
                      const AuthFieldLabel(label: 'Email'),
                      12.verticalSpace,
                      AppTextFormField(
                        controller: _emailController,
                        hintText: 'you@example.com',
                        type: AppTextFieldType.email,
                        required: true,
                        textInputAction: TextInputAction.next,
                      ),
                      20.verticalSpace,
                      const AuthFieldLabel(label: 'Password'),
                      12.verticalSpace,
                      AppTextFormField(
                        controller: _passwordController,
                        hintText: 'Minimum 6 characters',
                        type: AppTextFieldType.password,
                        required: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      16.verticalSpace,
                      _DummyApiHint(
                        text:
                            'Demo: ${DummyAuthDataSource.demoEmail} / '
                            '${DummyAuthDataSource.demoPassword}',
                      ),
                      24.verticalSpace,
                      BlocBuilder<LoginCubit, LoginState>(
                        bloc: cubit,
                        builder: (context, state) {
                          return AppButton.getButton(
                            context: context,
                            loading: state.isLoading,
                            onPressed: state.isLoading ? null : _submit,
                            text: 'Sign In',
                          );
                        },
                      ),
                      20.verticalSpace,
                      AuthSwitchLink(
                        prompt: "Don't have an account? ",
                        actionLabel: 'Sign Up',
                        onTap: () => cubit.navigator.openSignUp(
                          const SignUpInitialParams(),
                        ),
                      ),
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DummyApiHint extends StatelessWidget {
  const _DummyApiHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        'Dummy API: $text',
        style: context.textTheme.bodySmall?.copyWith(
          color: const Color(0xFF64748B),
          height: 1.4,
        ),
      ),
    );
  }
}
