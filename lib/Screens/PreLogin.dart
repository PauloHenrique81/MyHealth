import 'package:flutter/material.dart';

import 'SignInOne.dart';

class PreLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('Assets/login5.jpg'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('LoginMedico');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Paciente',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'SFUIDisplay'),
                      )
                    ],
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  minWidth: 350,
                  height: 60,
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.black)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('HomePage');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        'Médico',
                        style:
                            TextStyle(fontSize: 20, fontFamily: 'SFUIDisplay'),
                      )
                    ],
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  minWidth: 350,
                  height: 60,
                  textColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: Colors.blueAccent)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
