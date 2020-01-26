import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhealth/class/User.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  final CollectionReference consultaCollection =
      Firestore.instance.collection("pacientes");

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? new User(
            uid: user.uid,
            userName: user.displayName,
            photoUrl: user.photoUrl,
            userEmail: user.email)
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  Future<User> signInWithGmail() async {
    try {
      GoogleSignInAccount _user = _googleSignIn.currentUser;

      FirebaseUser _userDetails;

      if (_user == null) _user = await _googleSignIn.signIn();

      if (await _auth.currentUser() == null) {
        GoogleSignInAuthentication credentials =
            await _googleSignIn.currentUser.authentication;

        AuthResult _authResult = await _auth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: credentials.idToken,
                accessToken: credentials.accessToken));

        _userDetails = _authResult.user;
      } else {
        _userDetails = await _auth.currentUser();
      }

      return _userFromFirebaseUser(_userDetails);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registrarPaciente(
      String nome, String idade, String cpf, String email, String senha) async {
    try {
      User user = await _registrarEmailESenha(email, senha);
      if (user != null) {
        consultaCollection.document().setData({
          'uid': user.uid,
          'nome': nome,
          'idade': idade ?? '',
          'cpf': cpf,
          'email': email,
          'senha': senha,
          'dataDeCadastro': DateTime.now().toString(),
        });

        return user;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logarComEmailESenha(String email, String senha) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future _registrarEmailESenha(String email, String senha) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
