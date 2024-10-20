import 'package:product_management_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
 bool _isPasswordVisible = false; 
  // Function to call login API
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://reqres.in/api/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Save token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center, 
    children: [
      
      Container(
        height: 300,
        width: 200,
        child: Image.asset(
          'assets/images/logistic.png', 
          
          
          fit: BoxFit.fill, 
        ),
      ),
      SizedBox(height: 40),
      
      Row(
        
        children: [
          SizedBox(width: 8), 
          Text(
            'Login',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
      
      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email ID',
          prefixIcon: Icon(Icons.email,color: Colors.grey,), 
          border: OutlineInputBorder(), 
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      SizedBox(height: 20),
      
      TextField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: 'Password',
          prefixIcon: Icon(Icons.lock,color: Colors.grey,),
          border: UnderlineInputBorder(), 
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      
      Align(
        alignment: Alignment.centerRight, 
        child: TextButton(
          onPressed: () {
            
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ), 
          ),
        ),
      ),
      SizedBox(height: 20),
      
      SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10),
                right: Radius.circular(10),
              ), 
            ),
          ),
          onPressed: _isLoading ? null : _login,
          child: _isLoading
              ? CircularProgressIndicator()
              : Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
      Spacer(), 
      
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'New to Logistics? ',
              style: TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the registration page
              },
              child: Text('Register',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    ],
  ),
),
    );
  }
}
