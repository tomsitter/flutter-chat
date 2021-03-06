import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter/utils/scaffold_snackbar.dart';
import 'package:flash_chat_flutter/widgets/rounded_wide_button.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../constants.dart';
import 'chat_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  User? user;
  bool _isLoading = false;

  initState() {
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text("Login Screen")),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
              SizedBox(height: 48.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: AppTheme.textFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
                onChanged: (value) => {email = value},
              ),
              SizedBox(height: 8.0),
              TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: AppTheme.textFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                  ),
                  onChanged: (value) => {password = value}),
              SizedBox(height: 24.0),
              RoundedWideButton(
                  color: AppTheme.lightYellow,
                  text: 'Login',
                  onPressed: () async {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      user = (await _auth.signInWithEmailAndPassword(
                              email: email, password: password))
                          .user!;
                      Navigator.pushNamed(context, ChatScreen.id);
                    } on FirebaseAuthException catch (e) {
                      ScaffoldSnackbar.of(context).show('${e.message}');
                    } catch (e) {
                      ScaffoldSnackbar.of(context).show('Error: $e');
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
