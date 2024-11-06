// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'globals.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  Future _submit() async{
    if (_formKey.currentState!.validate()){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.pop(context);
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        backgroundColor: back,
        iconTheme: IconThemeData(color: butt),
        actions: [
          IconButton(
            onPressed: (){setState(() {
              invertColors();
            });},
            tooltip: 'Invert Colors',
            icon: const Icon(Icons.invert_colors),
            color: butt,
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
              Center(child: Text('Sign Up',style: TextStyle(color: txt,fontSize: 30,)),),
              const SizedBox(height: 50,),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name',),
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Please enter a username';
                  }
                  for (int i = 0; i < value.length; i++){
                    if (value[i] == ' '){
                      return 'Username cannot contain spaces';
                    }
                  }
                  return null;
                },
                // onSaved: (value) => _nameController.text = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                style: const TextStyle(color: Colors.white),
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                // onSaved: (value) => _emailController.text = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password',),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  if (value.length > 16) {
                    return 'Password cannot be longer than 16 characters';
                  }
                  return null;
                },
                // onSaved: (value) => _passwordController.text = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirm Password',),
                style: const TextStyle(color: Colors.white),
                controller: _confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return "password doesn't match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 150,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: butt,
                ),
                child: const Text('Submit',style: TextStyle(color: Colors.white),),
              )),
            ],
          ),
        ),
      ),
    );
  }
}