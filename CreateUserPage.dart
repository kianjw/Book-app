import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _booksPerYearController = TextEditingController();

  String _selectedGender = 'Male'; // Default value
  List<String> _selectedGenres = [];
  String _selectedFreeTime = 'Morning';
  bool _isAuthenticating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(top: kToolbarHeight + 16.0), // Adjust top padding
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Please enter a name.' : null,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.trim().isEmpty || !value.contains('@')
                          ? 'Please enter a valid email address.'
                          : null,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) => value!.trim().length < 6
                          ? 'Password must be at least 6 characters long.'
                          : null,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Select Gender:',
                      style: TextStyle(color: Colors.white),
                    ),
                    DropdownButton<String>(
                      value: _selectedGender,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGender = newValue!;
                        });
                      },
                      items: ['Male', 'Female', 'Other'].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Select Genres:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Wrap(
                      children: [
                        _buildGenreChip('Fiction'),
                        _buildGenreChip('Self-help'),
                        _buildGenreChip('Thriller'),
                        _buildGenreChip('Romance'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _booksPerYearController,
                      decoration: InputDecoration(
                        labelText: 'Number of Books Per Year',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.trim().isEmpty ? 'Please enter a number.' : null,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Free Time to Read Book:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFreeTimeButton('Morning'),
                        _buildFreeTimeButton('Evening'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    if (_isAuthenticating)
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (!_isAuthenticating)
                      ElevatedButton(
                        onPressed: _submit,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return states.contains(MaterialState.disabled)
                                  ? Colors.grey
                                  : Colors.lightBlue;
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                          ),
                        ),
                        child: Text('Create User'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreChip(String genre) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(genre),
        selected: _selectedGenres.contains(genre),
        onSelected: (selected) {
          setState(() {
            selected ? _selectedGenres.add(genre) : _selectedGenres.remove(genre);
          });
        },
        selectedColor: Colors.blue.shade300,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildFreeTimeButton(String time) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFreeTime = time;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return _selectedFreeTime == time ? Colors.green : Colors.white;
          },
        ),
      ),
      child: Text(time),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return; // Exit function if form is not valid
    }

    _formKey.currentState!.save(); // Save current form state

    setState(() {
      _isAuthenticating = true; // Start authentication process
    });

    try {
      final userCredentials = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'gender': _selectedGender,
        'genres': _selectedGenres,
        'booksPerYear': int.tryParse(_booksPerYearController.text) ?? 0,
        'freeTime': _selectedFreeTime,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User created successfully!')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      print("FirebaseAuthException: ${error.code} - ${error.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed!')),
      );
    } catch (error) {
      print("General Exception: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $error')),
      );
    } finally {
      setState(() {
        _isAuthenticating = false; // Stop authentication process
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _booksPerYearController.dispose();
    super.dispose();
  }
}
