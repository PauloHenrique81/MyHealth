import 'package:flutter/material.dart';
import 'package:myhealth/Service/auth.dart';
import 'package:myhealth/class/user.dart';

import '../Loading.dart';

class Wrapper extends StatefulWidget {
  @override
  State createState() => new _Wrapper();
}

class _Wrapper extends State<Wrapper> {
  final AuthService _auth = AuthService();
  User user;

  dynamic _result;

  @override
  void initState() {
    _signInAnon(_auth).then((result) {
      setState(() {
        _result = result;

        if (_result == "") {
          Navigator.pushReplacementNamed(context, 'PreLogin');
        } else {
          Navigator.pushReplacementNamed(context, 'HomePage', arguments: user);
        }
      });
    });
  }

  Future _signInAnon(AuthService _auth) async {
    final result = await _auth.signInAnon();
    if (result != "" && result != null) user = result;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: LoadingAnimation(),
      ),
    ));
  }
}
