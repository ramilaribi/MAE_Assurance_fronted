import 'package:flutter/material.dart';
import 'package:perper/constants.dart';
import 'package:perper/Screens/home.dart';
import 'package:perper/Components/custom_button.dart';
import 'forgotPassword.dart'; // Ensure this import is correct

import '../Services/auth_service.dart';

late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showForgetPasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ForgotPasswordScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 108, 173, 9),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.50,
                  ),
                  const SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Text('Welcome', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Color.fromARGB(255, 0, 0, 0))),
                  SizedBox(height: kDefaultPadding),
                  Text('Sign in to continue', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color.fromARGB(179, 31, 31, 31))),
                  SizedBox(height: kDefaultPadding),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  color: kOtherColor,
                  borderRadius: kTopBorderRadius,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: kDefaultPadding),
                        buildIdentifierField(),
                        SizedBox(height: kDefaultPadding),
                        buildPasswordField(),
                        SizedBox(height: kDefaultPadding),
                        DefaultButton(
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final response = await _authService.login(
                                  _idController.text,
                                  _passwordController.text,
                                );
                                if (response['status']) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeScreen()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response['error'])),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          title: 'SIGN IN',
                          iconData: Icons.arrow_forward_outlined,
                        ),
                        SizedBox(height: kDefaultPadding),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              showForgetPasswordSheet(context);
                            },
                            child: Text(
                              'Forgot Password',
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Color.fromARGB(255, 108, 173, 9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildIdentifierField() {
    return TextFormField(
      controller: _idController,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Identifier',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(color: Color.fromARGB(255, 108, 173, 9), fontSize: 20), // Change this to your desired label color
        errorStyle: TextStyle(color: Colors.red, fontSize: 12), // Customize error message style
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black87), // Change this to your desired focused border color
        ),
      ),
      validator: (value) {
        // Validation for 8-character unique identifier
        if (value == null || value.isEmpty) {
          return 'Please enter an identifier';
        } else if (value.length != 8) {
          return 'Identifier must be exactly 8 characters';
        }
        return null;
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(color: Color.fromARGB(255, 108, 173, 9), fontSize: 20), // Change this to your desired label color
        errorStyle: TextStyle(color: Colors.red, fontSize: 12), // Customize error message style
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black87), // Change this to your desired focused border color
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          iconSize: kDefaultPadding,
        ),
      ),
      validator: (value) {
        if (value!.length < 5) {
          return 'Must be more than 5 characters';
        }
        return null;
      },
    );
  }
}
