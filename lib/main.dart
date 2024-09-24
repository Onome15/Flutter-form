import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Forms',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userName = TextEditingController();

  bool isValid = false;

  String? passwordErrorMessage;
  bool isPasswordValid = false;

  void _checkPassword(String value) {
    setState(() {
      if (value.isNotEmpty) {
        passwordErrorMessage =
            null; // Clear error as soon as user starts typing
      }
      if (value.length >= 6) {
        passwordErrorMessage = '';
        isPasswordValid = true;
      } else {
        passwordErrorMessage = 'Password must be at least 6 characters';
        isPasswordValid = false;
      }
    });
  }

  void _validateForm() {
    String passwordValue = _passwordController.text;
    if (!_formKey.currentState!.validate()) {
      setState(() {
        // If validation fails, trigger the error message
        passwordErrorMessage = passwordValue.isEmpty
            ? 'Password cannot be empty'
            : 'Password must be at least 6 characters';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() {
    setState(() {
      isValid = _controller.text.length == 10;
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Cleans up the controller when the widget is removed
    super
        .dispose(); // Calls the superclass dispose to ensure proper disposal of other inherited resources
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(10),
      width: 500,
      // height: max,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 198, 202, 205),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(255, 200, 190, 189),
          width: 5, // Border thickness
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'DEMO FORM',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 241, 237, 237),
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _userName,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                  hintText: 'Enter your User Name',
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your User Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enter your age',
                ),
                keyboardType: TextInputType.number,
                maxLength: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Age';
                  }
                  final int? age = int.tryParse(value);
                  if (age! <= 17) {
                    return 'Age must be above 17';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                // controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  suffixIcon: Icon(
                    Icons.check_circle,
                    color: isValid ? Colors.blue : Colors.red,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                onChanged: _checkPassword,
              ),
              if (passwordErrorMessage != null) // Conditionally show error text
                Text(
                  passwordErrorMessage!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 169, 16, 5),
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (isPasswordValid == true) {
                      if (_formKey.currentState!.validate()) {
                        String userName = _userName.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Dear $userName, Your form has been succesfully created'),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                      // Perform submission logic
                    } else {
                      _validateForm();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
