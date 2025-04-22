import 'package:fcmchatapp/services/auth_service.dart';
import 'package:fcmchatapp/services/navigation_service.dart';
import 'package:fcmchatapp/utils/app_logger.dart';
import 'package:fcmchatapp/utils/app_routes.dart';
import 'package:fcmchatapp/utils/toast_config.dart';
import 'package:fcmchatapp/utils/validators.dart';
import 'package:fcmchatapp/views/widgets/custom_form_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isloading = false;
  final NavigationService _navigationService =
      GetIt.instance<NavigationService>();

  final AppToasts _toasts = GetIt.instance<AppToasts>();
  final AppLogger _logger = GetIt.instance<AppLogger>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  Future<void> _signup() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isloading = true);

  try {
    final result = await GetIt.instance<AuthService<User>>().signUpWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
    );

    if (!mounted) return;

    if (result is AuthSuccess<User>) {
      _logger.info('User registered: ${_emailController.text}');
      
      _toasts.showSuccess(
        context: context,
        message: 'Registration successful!',
      );

      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        await _navigationService.clearStackAndNavigate(Routes.home);
      }
    } else if (result is AuthFailure<User>) {
      _logger.warning('Signup failed: ${result.error}');
      _toasts.showError(
        context: context,
        message: result.error ?? 'Registration failed',
      );
    }
  } catch (e, stackTrace) {
    _logger.error('Signup error', e, stackTrace);
    if (mounted) {
      _toasts.showError(
        context: context,
        message: 'An unexpected error occurred',
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isloading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildUi(),resizeToAvoidBottomInset: false,);
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildHeader(),
             Spacer(flex: 1,),
            _biuldSignupForm(),
            Spacer(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Create an account',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          'Join us to start chatting',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _biuldSignupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            hintText: "Full Name",
            isName: true,
            controller: _nameController,
            validator: (value) => Validators.validateName(value),
          ),
          SizedBox(height: 20),
          CustomFormField(
            hintText: "Email",
            isEmail: true,
            controller: _emailController,
            validator: (value) => Validators.validateEmail(value),
          ),
          SizedBox(height: 20),
          CustomFormField(
            hintText: "Password",
            isPassword: true,
            controller: _passwordController,
            validator: (value) => Validators.validatePassword(value),
          ),
          SizedBox(height: 20),
          CustomFormField(
            hintText: "Confirm Password",
            isPassword: true,
            controller: _confirmPasswordController,
            validator:
                (value) => Validators.validateConfirmPassword(
                  value,
                  _passwordController.text,
                ),
          ),
          SizedBox(height: 60),
          _biuldSignupButton(),
        ],
      ),
    );
  }

  Widget _biuldSignupButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isloading ? null : _signup,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          elevation: 0,
        ),
        child:
            _isloading
                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?", style: TextStyle()),
        SizedBox(width: 4,),
        GestureDetector(
          onTap: () => _navigationService.clearStackAndNavigate(Routes.login),
          child: Text(
            'Log In',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
