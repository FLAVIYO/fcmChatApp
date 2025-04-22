import 'package:fcmchatapp/services/navigation_service.dart';
import 'package:fcmchatapp/utils/app_logger.dart';
import 'package:fcmchatapp/utils/app_routes.dart';
import 'package:fcmchatapp/utils/service_locator.dart';
import 'package:fcmchatapp/utils/toast_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fcmchatapp/services/auth_service.dart';
import 'package:fcmchatapp/utils/validators.dart';
import 'package:fcmchatapp/views/widgets/custom_form_fields.dart';

class LoginPage extends StatefulWidget {
  final AuthService? authService;
  final NavigationService? navigationService;

  const LoginPage({super.key, this.authService, this.navigationService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final NavigationService _navigationService = getIt<NavigationService>();
  bool _isLoading = false;
  final AppToasts _toasts = GetIt.instance<AppToasts>();
  final AppLogger _logger = GetIt.instance<AppLogger>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await GetIt.instance<AuthService<User>>()
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (result is AuthSuccess<User>) {
        _logger.info('User logged in: ${result.user?.email}');
        _toasts.showSuccess(context: context, message: 'Login successful!');
        if (mounted) _navigationService.clearStackAndNavigate(Routes.home);
      } else if (result is AuthFailure<User>) {
        _logger.warning('Login failed: ${result.error}');
        _toasts.showError(
          context: context,
          message: result.error ?? 'Login failed. Please try again.',
        );
      }
    } catch (e, stackTrace) {
      _logger.error('Login error', e, stackTrace);
      _toasts.showError(
        context: context,
        message: 'An unexpected error occurred. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildui(), resizeToAvoidBottomInset: false);
  }

  Widget _buildui() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          children: [
            SizedBox(height: 30),
            _buildHeader(),
            Spacer(),
            _buildLoginForm(),
            Spacer(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome Back',
          style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue to your account',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            hintText: 'Email Address',
            isEmail: true,
            controller: _emailController,
            validator: (value) => Validators.validateEmail(value),
          ),
          const SizedBox(height: 16),
          CustomFormField(
            hintText: 'Password',
            isPassword: true,
            controller: _passwordController,
            validator: (value) => Validators.validatePassword(value),
          ),
          const SizedBox(height: 36),
          _buildLoginButton(),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Add forgot password navigation
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child:
            _isLoading
                ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Don't have an account?", style: GoogleFonts.poppins()),
        SizedBox(width: 4,),
        GestureDetector(
          onTap: () => _navigationService.clearStackAndNavigate(Routes.signup),
          child: Text(
            'Sign Up',
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
