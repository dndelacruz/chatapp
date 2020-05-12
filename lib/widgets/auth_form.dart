import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.isLoading, this.submitHandler);

  final Function submitHandler;
  bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  var _formData = {
    'email': '',
    'username': '',
    'password': '',
    'isLoginMode': true,
    'context': null
  };

  var _isLoginMode = true;

  var _formKey = GlobalKey<FormState>();

  void _submitFormData(){
    
    final _valid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(_valid) {
      _formKey.currentState.save();
      _formData['isLoginMode'] = _isLoginMode;
      _formData['context'] = context;
      widget.submitHandler(
        {..._formData}
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // email address
                  TextFormField(
                    
                    key: ValueKey('email'),
                    validator: (val) {
                      if(val.isEmpty || !val.contains('@')) return 'Please input a valid email address';
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'email address'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (val) => _formData['email'] = val.trim(),
                  ),
                  // username
                  if(!_isLoginMode)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (val) {
                      if(val.isEmpty || val.length < 7) return 'Username must be at least 6 characters';
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'username'),
                    onSaved: (val) => _formData['username'] = val.trim(),
                  ),
                  // password
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (val) {
                      if(val.isEmpty || val.length < 4) return 'Password must be at least 4 characters';
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'password'),
                    onSaved: (val) => _formData['password'] = val.trim(),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  widget.isLoading ? CircularProgressIndicator() : RaisedButton(
                    child: Text(_isLoginMode ? 'Login' : 'Signup'),
                    onPressed: _submitFormData,
                  ),
                  FlatButton(
                    child: Text(
                      _isLoginMode ? 'Create new account' : 'I already have an account',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () => setState(() { 
                      _isLoginMode = !_isLoginMode;
                      _formData['isLoginMode'] = _isLoginMode;
                      
                      }),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
