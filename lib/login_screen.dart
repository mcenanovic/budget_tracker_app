import 'package:budget_tracker_app/providers/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLogin = true;
  var _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  Future<void> _submitForm() async {
    _formKey.currentState?.save();
    var isValid = _formKey.currentState?.validate();

    FocusScope.of(context).unfocus();

    if (isValid == null || !isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    var auth = Provider.of<AuthenticationState>(context, listen: false);

    _isLogin
        ? await auth.signInWithEmailAndPassword(_email, _password,
            (e) => _showErrorSnackbar((e as dynamic).message))
        : await auth.registerAccount(_email, _password,
            (e) => _showErrorSnackbar((e as dynamic).message));

    setState(() {
      _isLoading = false;
    });
  }

  void _changeLoginState() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLoginScreen() => Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: Styles.kLoginFormTextStyle,
              decoration: Styles.kLoginFormInputDecoration.copyWith(
                hintText: 'Enter your email',
                prefixIcon: const Icon(
                  Icons.email,
                  color: Styles.kLightColor,
                ),
              ),
              onSaved: (email) => email != null ? _email = email : null,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your email address to continue';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              style: Styles.kLoginFormTextStyle,
              decoration: Styles.kLoginFormInputDecoration.copyWith(
                hintText: 'Enter your password',
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Styles.kLightColor,
                ),
              ),
              obscureText: true,
              onSaved: (password) =>
                  password != null ? _password = password : null,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your password to continue';
                }
                return null;
              },
            ),
            SizedBox(height: _isLogin ? 0.0 : 15.0),
            AnimatedContainer(
              constraints: BoxConstraints(maxHeight: _isLogin ? 0.0 : 100.0),
              duration: const Duration(milliseconds: 300),
              child: AnimatedOpacity(
                opacity: _isLogin ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: TextFormField(
                  readOnly: _isLogin,
                  style: Styles.kLoginFormTextStyle,
                  decoration: Styles.kLoginFormInputDecoration.copyWith(
                    hintText: 'Retype your password',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Styles.kLightColor,
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (!_isLogin && value != null && value != _password) {
                      return 'Your passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Styles.kSecondaryColor,
                ),
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Styles.kLightGreyColor),
                        )
                      : Text(
                          _isLogin ? 'LOGIN' : 'REGISTER',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: _isLogin ? 15.0 : 0.0),
            _buildSocialLoginButton(true),
            if (_isLogin) const SizedBox(height: 15.0),
            _buildSocialLoginButton(false),
            const SizedBox(height: 15.0),
            TextButton(
              onPressed: _changeLoginState,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _isLogin
                          ? 'Don\'t have an account? '
                          : 'Already have an account? ',
                      style: const TextStyle(
                        color: Styles.kLightColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: _isLogin ? 'Sign Up' : 'Sign In',
                      style: const TextStyle(
                        color: Styles.kLightColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildSocialLoginButton(bool isGoogle) {
    final auth = Provider.of<AuthenticationState>(context);
    return AnimatedOpacity(
      opacity: _isLogin ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        height: _isLogin ? 56 : 0,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary:
                  isGoogle ? Styles.kLightGreyColor : const Color(0xFF3c5a99),
            ),
            onPressed:
                isGoogle ? auth.signInWithGoogle : auth.signInWithFacebook,
            child: ListTile(
              leading: Image.asset(
                'assets/images/${isGoogle ? 'google' : 'facebook'}_logo.png',
                width: 30,
                height: 30,
              ),
              title: Text(
                'Sign in with ${isGoogle ? 'Google' : 'Facebook'}',
                style: TextStyle(
                  color: isGoogle ? Colors.black : Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF754D7F),
                  Color(0xFF8B5D97),
                  Color(0xFF8F659A),
                  Color(0xFF92649E),
                ],
                stops: [0.1, 0.4, 0.8, 0.9],
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 80,
              ),
              child: _buildLoginScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
