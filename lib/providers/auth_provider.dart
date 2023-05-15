import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moqefapp/database/database.dart';
import 'package:moqefapp/models/client.dart';
import 'package:moqefapp/preferences/prefs.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'base_provider.dart';

class AuthProvider extends BaseProvider {
  Client? _client;
  Client? get authClient => _client;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Client?> getAuthClient(String uid) async {
    if (_client == null) {
      _client = await Database.instance.getUser(uid);
      notifyListeners();
    }
    return _client;
  }

  Future<bool> login(String email, String password) async {
    try {
      Prefs.instance.setPlatform("email");
      var value = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (value.user != null) {
        _client = await Database.instance.getUser(value.user!.uid);
        Prefs.instance.setClient(value.user!.uid);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          dev.log('User not found');
          setError("Utilisateur non trouvé");
          break;
        case 'wrong-password':
          dev.log('Wrong password');
          setError("Mot de passe incorrect");
          break;
        default:
          dev.log('Unknown error $e');
          setError("Erreur inconnue");
      }
      return false;
    }
  }

  Future<bool> register(
      String name, String email, String password, String phone) async {
    try {
      Prefs.instance.setPlatform("email");
      UserCredential value = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (value.user != null) {
        _auth.currentUser?.sendEmailVerification();
        _client = Client(
          fullname: name,
          uid: value.user!.uid,
          email: email,
          phone: phone,
        );
        Prefs.instance.setClient(value.user!.uid);
        await Database.instance.addUser(_client as Client);
        notifyListeners();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          dev.log('Email already in use');
          setError('Address email a ete deja utilise');
          break;
        case 'invalid-email':
          dev.log('Address email invalide');
          setError('Address email invalide');
          break;
        case 'weak-password':
          dev.log('mot de passe faible');
          setError('mot de passe faible');
          break;
        default:
          dev.log('Unknown error $e');
          setError('Erreur inconnue , reessayer');
          break;
      }
      return false;
    }
  }

  Future<bool> changePassword(String password) async {
    try {
      if (_auth.currentUser != null) {
        _auth.currentUser!.updatePassword(password);
        return true;
      }
      return false;
    } catch (e) {
      dev.log(e.toString());
      return false;
    }
  }

  googleAuth() async {
    try {
      GoogleSignInAccount? account =
          await GoogleSignIn().signIn().catchError((err) {
        dev.log("google error $err");
        setError("Erreur de connexion");
      });
      Prefs.instance.setPlatform("google");
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;

        UserCredential? value = await _auth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: auth.idToken, accessToken: auth.accessToken));
        if (value.user != null) {
          var exist = await Database.instance.checkUser(value.user!.uid);
          if (exist) {
            Prefs.instance.setClient(value.user!.uid);
            _client = await Database.instance.getUser(value.user!.uid);
            notifyListeners();
            return true;
          } else {
            Client client = Client(
              fullname: account.displayName ?? '',
              uid: value.user!.uid,
              email: account.email,
              phone: value.user?.phoneNumber ?? '',
              imageUrl: account.photoUrl ??
                  "https://firebasestorage.googleapis.com/v0/b/mo9ef/o/avatar.png?alt=media&token=4fe982e6-37b4-4fe7-b036-d5dfa11f56a3",
            );
            await Database.instance.addUser(client);
            _client = client;
            Prefs.instance.setClient(value.user!.uid);
            notifyListeners();
            return true;
          }
        }
        return false;
      }
    } on FirebaseAuthException catch (e) {
      dev.log("Firebase exeption google auth  ${e.message}");
      setError('Erreur de connexion');
    } on Exception catch (e) {
      dev.log("Google auth error $e");
      setError('Erreur de connexion');
    }
    setBusy(false);
    return false;
  }

  facebookAuth() async {
    try {
      LoginResult result = await FacebookAuth.i.login().catchError((err) {
        dev.log("facebook error $err");
        setError("Erreur de connexion");
      });
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(
          accessToken.token,
        );
        UserCredential value = await _auth.signInWithCredential(credential);
        if (value.user != null) {
          var exist = await Database.instance.checkUser(value.user!.uid);
          if (exist) {
            Prefs.instance.setClient(value.user!.uid);
            _client = await Database.instance.getUser(value.user!.uid);
            notifyListeners();
            return true;
          } else {
            Client client = Client(
              fullname: value.user?.displayName ?? '',
              uid: value.user!.uid,
              email: value.user?.email ?? 'mail@mo9ef.ma',
              phone: value.user?.phoneNumber ?? '',
              imageUrl: value.user?.photoURL ??
                  "https://firebasestorage.googleapis.com/v0/b/mo9ef/o/avatar.png?alt=media&token=4fe982e6-37b4-4fe7-b036-d5dfa11f56a3",
            );
            await Database.instance.addUser(client);
            _client = client;
            Prefs.instance.setClient(value.user!.uid);
            notifyListeners();
            return true;
          }
        }
        return false;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      dev.log("Firebase exeption google auth  ${e.message}");
      setError('Error de connection.');
    } on Exception catch (e) {
      dev.log("Exception google auth  $e");
      setError('Error de connection.');
    }
    setBusy(false);
    return false;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      UserCredential value =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      if (value.user != null) {
        var exist = await Database.instance.checkUser(value.user!.uid);
        if (exist) {
          Prefs.instance.setClient(value.user!.uid);
          _client = await Database.instance.getUser(value.user!.uid);
          notifyListeners();
          return true;
        } else {
          Client client = Client(
            fullname: value.user?.displayName ?? '',
            uid: value.user!.uid,
            email: value.user?.email ?? 'mail@mo9ef.ma',
            phone: value.user?.phoneNumber ?? '',
            imageUrl: value.user?.photoURL ??
                "https://firebasestorage.googleapis.com/v0/b/mo9ef/o/avatar.png?alt=media&token=4fe982e6-37b4-4fe7-b036-d5dfa11f56a3",
          );
          await Database.instance.addUser(client);
          _client = client;
          Prefs.instance.setClient(value.user!.uid);
          notifyListeners();
          return true;
        }
      }
      return false;
      // ignore: empty_catches
    } on FirebaseAuthException catch (e) {
      dev.log("Firebase exeption google auth  ${e.message}");
      setError('Erreur de connection.');
    } on SignInWithAppleException catch (e) {
      dev.log("Apple exeption google auth  $e");
      setError('Erreur de connection.');
    }
    setBusy(false);
    return false;
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      _client = null;
      Prefs.instance.clearClient();
      notifyListeners();
      return true;
    } catch (e) {
      dev.log(e.toString());
      return false;
    }
  }
}
