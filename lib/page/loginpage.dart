import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_bell_system/components/mybutton.dart';
import 'package:school_bell_system/components/mytextfield.dart';
import 'package:school_bell_system/page/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;

  final FirebaseAuth _auth = FirebaseAuth.instance; 

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUserIn(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successful"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Header()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid user id and Password"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 100),
                  SizedBox(height: 50),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(height: 50),
                  Mytextfield(
                    controller: usernameController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  SizedBox(height: 20),

                  Mytextfield(
                    controller: passwordController,
                    obscureText: _isObscure,
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_off
                              : Icons.visibility, // 🔹 Show/hide eye icon
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure =
                                !_isObscure; // 🔹 Toggle password visibility
                          });
                        },
                      
                    ),
                  ), // 🔹 Set the suffix icon

                  SizedBox(height: 20),
                  Mybutton(onTap: () => signUserIn(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
