import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:math';
//
import '../exceptions/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 118, 117, 1).withOpacity(0.9)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 0.9])),
      ),
      SingleChildScrollView(
        child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 94.0),
                          transform: Matrix4.rotationZ(-8 * pi / 180)
                            ..translate(-10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.purple.shade300,
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.black26,
                                    offset: Offset(0, 2)),
                              ]),
                          child: Text('Blamazon!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(fontFamily: 'PermanentMarker')))),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: const AuthCard())
                ])),
      )
    ]));
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {'email': '', 'password': ''};
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Size> _heightAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _heightAnimation = Tween<Size>(
            begin: const Size(double.infinity, 260),
            end: const Size(double.infinity, 320))
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInToLinear));
    // _heightAnimation.addListener(() => setState(() {}));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInToLinear));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: const Offset(0, 0))
            .animate(CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOutExpo));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: Text('There was an error...'),
                content: Text(message),
                actions: [
                  TextButton(
                    child: Text('Okay'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ]));
  }

  Future<void> _submit() async {
    // return if form is not validly completed:
    if (!(_formKey.currentState as FormState).validate()) return;

    (_formKey.currentState as FormState).save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        // log the user in:
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        // sign the user up:
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'] as String, _authData['password'] as String);
      }
    } on HttpException catch (error) {
      // define a default error message:
      var errorMessage = 'Authentication failed.';
      // replace with specific error message in certain cases:
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage =
            'A Blamazon user with that email already exists. Please log in or sign up with a different email address.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage =
            'This password is too weak. Please use a stronger password.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage =
            'Could not find a user with that email. Please check the email and try again (or sign up if you do not yet have an account.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Login credentials were invalid.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage =
          'Was not able to ${_authMode == AuthMode.Signup ? 'sign user up' : 'log user in'} for some reason. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() => _authMode = AuthMode.Signup);
      _animationController.forward();
    } else {
      setState(() => _authMode = AuthMode.Login);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 8.0,
        child: AnimatedBuilder(
            animation: _heightAnimation,
            builder: (ctx, child) => Container(
                // height: _authMode == AuthMode.Signup ? 330 : 260,
                height: _heightAnimation.value.height,
                constraints: BoxConstraints(
                    // minHeight: _authMode == AuthMode.Signup ? 320 : 260,
                    minHeight: _heightAnimation.value.height),
                width: deviceSize.width * 0.75,
                padding: const EdgeInsets.all(12.0),
                child: child),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                        decoration: const InputDecoration(labelText: 'email'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val == null ||
                              val.isEmpty ||
                              !val.contains('@') ||
                              !val.contains('.')) {
                            return 'Invalid email address';
                          }
                        },
                        onSaved: (val) {
                          _authData['email'] = val ?? '';
                        }),
                    TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'password'),
                        obscureText: true,
                        controller: _passwordController,
                        textInputAction: _authMode == AuthMode.Signup
                            ? TextInputAction.next
                            : TextInputAction.done,
                        validator: (val) {
                          if (val == null || val.isEmpty || val.length < 6) {
                            return 'Invalid password (must be at least 6 characters';
                          }
                        },
                        onSaved: (val) {
                          _authData['password'] = val ?? '';
                        }),
                    if (_authMode == AuthMode.Signup)
                      FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                              enabled: _authMode == AuthMode.Signup,
                              decoration: const InputDecoration(
                                  labelText: 'confirm password'),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: _authMode == AuthMode.Signup
                                  ? (val) {
                                      if (val == null ||
                                          val != _passwordController.text) {
                                        return "Passwords do not match.";
                                      }
                                    }
                                  : null,
                              onSaved: (val) {
                                _authData['password'] = val ?? '';
                              }),
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        child: Text(
                            _authMode == AuthMode.Login ? 'LogIn' : 'SignUp'),
                        onPressed: _submit,
                      ),
                    TextButton(
                        child: Text(
                            _authMode == AuthMode.Signup
                                ? "I already have an account, let me log in."
                                : "I don't have an account, let me sign up.",
                            style: const TextStyle(
                                fontSize: 11,
                                decoration: TextDecoration.underline)),
                        onPressed: _switchAuthMode,
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.all(10.0))))
                  ]),
                ))));
  }
}
