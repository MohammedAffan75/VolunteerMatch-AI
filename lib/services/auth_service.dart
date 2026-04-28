import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:volunteer_match_ai/models/user_model.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  static User? get currentUser => _auth.currentUser;

  static Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = cred.user!.uid;
    final user = UserModel(uid: uid, role: role, name: name, email: email);
    await _db.collection('users').doc(uid).set(user.toJson());
    return cred;
  }

  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? account = await GoogleSignIn().signIn();
    if (account == null) return null;
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user != null) {
      final doc = _db.collection('users').doc(user.uid);
      if (!(await doc.get()).exists) {
        await doc.set(
          UserModel(
            uid: user.uid,
            role: 'volunteer',
            name: user.displayName ?? 'Volunteer',
            email: user.email ?? '',
          ).toJson(),
        );
      }
    }
    return userCredential;
  }

  static Future<UserModel?> getCurrentProfile() async {
    final uid = currentUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromJson(doc.data()!, id: doc.id);
  }

  static Future<void> updateProfile(UserModel model) {
    return _db.collection('users').doc(model.uid).set(model.toJson());
  }

  static Future<void> signOut() => _auth.signOut();
}
