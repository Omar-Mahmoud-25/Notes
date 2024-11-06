import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'SignUp.dart';
// import 'HomePage.dart';
import 'globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  Future _login() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim()
      );
    }
    // !((FirebaseAuth.instance.authStateChanges() as AsyncSnapshot).hasData)){
    catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email or Password is incorrect'),
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        backgroundColor: back,
        actions: [
          IconButton(
            onPressed: (){setState(() {
              invertColors();
            });},
            icon: const Icon(Icons.invert_colors),
            color: butt,
            tooltip: 'LogOut',
            highlightColor: back,
          ),
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.settings_outlined),
            color: butt,
            tooltip: 'Settings',
            highlightColor: txt,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(child: Text('Login',style: TextStyle(color: txt,fontSize: 30,)),),
              const SizedBox(height: 50,),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email',),
                style: const TextStyle(color: Colors.white),
                controller: _emailController,
                // onSaved: (value) => _username = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password',),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 150,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: butt,
                ),
                child: const Text('Login',style: TextStyle(color: Colors.white),),
              )),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                onPressed: () {
                  // Navigator.push(context);
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: ((context) => const SignUpPage(title: 'SignUp')))
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: butt,
                ),
                child: const Text("Don't have an account?",style: TextStyle(color: Colors.white),),
              )),
            ],
          ),
        ),
      ),
    );
  }
}