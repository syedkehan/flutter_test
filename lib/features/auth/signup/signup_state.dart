import 'signup_initial_params.dart';

class SignUpState {
  final bool isLoading;
  final String selectedDialCode;
  final String selectedCountryName;

  SignUpState({
    required this.isLoading,
    this.selectedDialCode = '+44',
    this.selectedCountryName = 'United Kingdom',
  });

  factory SignUpState.initial({required SignUpInitialParams initialParams}) =>
      SignUpState(isLoading: false);

  SignUpState copyWith({
    bool? isLoading,
    String? selectedDialCode,
    String? selectedCountryName,
  }) =>
      SignUpState(
        isLoading: isLoading ?? this.isLoading,
        selectedDialCode: selectedDialCode ?? this.selectedDialCode,
        selectedCountryName: selectedCountryName ?? this.selectedCountryName,
      );
}
