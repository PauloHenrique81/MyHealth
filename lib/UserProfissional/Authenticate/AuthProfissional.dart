import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhealth/Persistencia/P_Profissional.dart';
import 'package:myhealth/class/user.dart';

class AuthProfissional {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  P_Profissional profissionalBD = new P_Profissional();

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
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
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

//----------------------------------------------------------------------
  Future<FirebaseUser> signInWithGmail() async {
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

      return _userDetails;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> cadastraUserProfissional(FirebaseUser _userDetails) async {
    var userX = _userFromFirebaseUser(_userDetails);

    var usuarioJaCadastrado =
        await profissionalBD.existeProfissional(userX.uid);

    if (!usuarioJaCadastrado)
      profissionalBD.cadastraProfissional(userX.uid, "", userX.userName, "",
          email: userX.userEmail, imagemUrl: userX.photoUrl, tipoUser: "sim");
    return userX;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//-------------------------------------------------------------------------------

  Future cadastroPorEmaileSenha(String nome, String cpf, String identificacao,
      String profissao, String email, String senha) async {
    try {
      User user = await _registrarEmailESenha(email, senha);
      if (user != null) {
        profissionalBD.cadastraProfissional(user.uid, profissao, nome, '',
            cpf: cpf,
            identificacao: identificacao,
            email: email,
            tipoUser: "sim");
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
