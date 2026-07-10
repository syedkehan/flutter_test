import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_app/core/constants/app_constants.dart';
import 'package:flutter_test_app/core/utils/extensions.dart';
import 'package:flutter_test_app/core/widgets/app_button.dart';
import 'package:flutter_test_app/core/widgets/app_text_form_field.dart';
import 'package:flutter_test_app/core/widgets/date_picker_dialog.dart';
import 'package:flutter_test_app/data/models/auth/signup_model.dart';
import 'package:flutter_test_app/features/auth/login/login_initial_params.dart';
import 'package:flutter_test_app/features/auth/signup/signup_state.dart';
import 'package:flutter_test_app/features/auth/widget/auth_field_label.dart';
import 'package:flutter_test_app/features/auth/widget/auth_logo.dart';
import 'package:flutter_test_app/features/auth/widget/auth_switch_link.dart';
import 'package:flutter_test_app/features/auth/widget/country_picker_field.dart';
import 'package:intl/intl.dart';

import 'signup_cubit.dart';

class SignUpPage extends StatefulWidget {
  final SignUpCubit cubit;

  const SignUpPage({super.key, required this.cubit});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  SignUpCubit get cubit => widget.cubit;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    cubit.close();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final selectedDate = await datePickerDialog(
      context: context,
      initialDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null || !mounted) return;

    _dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    setState(() {});
  }

  void _submit(SignUpState state) {
    context.hideKeyboard();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    cubit.signUp(
      body: SignUpModel(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: '${state.selectedDialCode}${_phoneController.text.trim()}',
        password: _passwordController.text,
        dateOfBirth: _dobController.text.trim().isEmpty
            ? null
            : _dobController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.colorScheme.surface,
        child: CustomScrollView(
          slivers: [
            AppConstants.silverAppBar(
              context: context,
              showBackButton: true,
              title: 'Sign Up',
              subtitle: 'Create your account to get started',
            ),
            AppConstants.sliverToBoxAdapter(
              child: BlocBuilder<SignUpCubit, SignUpState>(
                bloc: cubit,
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AuthLogo(),
                        24.verticalSpace,
                        const AuthFieldLabel(label: 'Full Name'),
                        12.verticalSpace,
                        AppTextFormField(
                          controller: _fullNameController,
                          hintText: 'John Doe',
                          type: AppTextFieldType.standard,
                          required: true,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                        ),
                        20.verticalSpace,
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
                        const AuthFieldLabel(label: 'Country'),
                        12.verticalSpace,
                        CountryPickerField(
                          countryName: state.selectedCountryName,
                          onChanged: cubit.updateDialCode,
                        ),
                        20.verticalSpace,
                        const AuthFieldLabel(label: 'Phone Number'),
                        12.verticalSpace,
                        AppTextFormField(
                          controller: _phoneController,
                          hintText: '0000000000',
                          prefixText: '${state.selectedDialCode} ',
                          type: AppTextFieldType.phone,
                          required: true,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(12),
                          ],
                        ),
                        20.verticalSpace,
                        const AuthFieldLabel(label: 'Date of Birth'),
                        12.verticalSpace,
                        AppTextFormField(
                          controller: _dobController,
                          hintText: 'Select date',
                          readOnly: true,
                          onTap: _pickDateOfBirth,
                          suffixIcon: const Icon(Icons.calendar_today),
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
                          textInputAction: TextInputAction.next,
                        ),
                        20.verticalSpace,
                        const AuthFieldLabel(label: 'Confirm Password'),
                        12.verticalSpace,
                        AppTextFormField(
                          controller: _confirmPasswordController,
                          hintText: 'Re-enter password',
                          type: AppTextFieldType.password,
                          required: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        24.verticalSpace,
                        AppButton.getButton(
                          context: context,
                          loading: state.isLoading,
                          onPressed: state.isLoading ? null : () => _submit(state),
                          text: 'Create Account',
                        ),
                        20.verticalSpace,
                        AuthSwitchLink(
                          prompt: 'Already have an account? ',
                          actionLabel: 'Sign In',
                          onTap: () => cubit.navigator.openLogin(
                            const LoginInitialParams(),
                          ),
                        ),
                        32.verticalSpace,
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
