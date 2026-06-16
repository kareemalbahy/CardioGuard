import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cardiogaurd/core/enums/user_role.dart';
import 'package:cardiogaurd/core/error/exceptions.dart';
import 'package:cardiogaurd/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:cardiogaurd/features/auth/domain/entities/app_user.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<AppUser> signIn(String email, String password, UserRole? forceRole) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
      
      if (!userDoc.exists) {
        throw const AuthException('User profile not found in database.');
      }

      final data = userDoc.data()!;
      final roleStr = data['role'] as String;
      final role = UserRole.values.firstWhere(
        (e) => e.name == roleStr,
        orElse: () => UserRole.patient,
      );

      return AppUser(
        id: credential.user!.uid,
        email: email,
        displayName: data['name'] ?? email.split('@').first,
        role: role,
        profileImageUrl: data['profileImageUrl'] ?? '',
        specialty: data['specialty'],
        hospital: data['hospital'],
        phone: data['phone'],
        gender: data['sex'],
        dob: data['dob'],
      );
    } on FirebaseAuthException catch (e) {
      print("FIREBASE AUTH ERROR: ${e.message}");
      throw AuthException(e.message ?? 'Authentication failed');
    } catch (e) {
      print("UNKNOWN AUTH ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? specialty,
    String? hospital,
    String? phone,
    String? gender,
    String? dob,
    File? profileImage,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String profileImageUrl = '';
      if (profileImage != null && profileImage.existsSync()) {
        final ref = _storage.ref().child('profile_pictures').child('${credential.user!.uid}.jpg');
        await ref.putFile(profileImage);
        profileImageUrl = await ref.getDownloadURL();
      }

      final Map<String, dynamic> userData = {
        'name': name,
        'email': email,
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
        'profileImageUrl': profileImageUrl,
        'phone': phone ?? '',
        'sex': gender ?? '',
        'dob': dob ?? '',
      };

      if (role == UserRole.doctor) {
        userData['specialty'] = specialty ?? 'General Cardiologist';
        userData['hospital'] = hospital ?? 'Private Clinic';
      }

      await _firestore.collection('users').doc(credential.user!.uid).set(userData);

      return AppUser(
        id: credential.user!.uid,
        email: email,
        displayName: name,
        role: role,
        profileImageUrl: profileImageUrl,
        specialty: userData['specialty'],
        hospital: userData['hospital'],
        phone: phone,
        gender: gender,
        dob: dob,
      );
    } on FirebaseAuthException catch (e) {
      print("FIREBASE REG ERROR: ${e.message}");
      throw AuthException(e.message ?? 'Registration failed');
    } catch (e) {
      print("UNKNOWN REG ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<AppUser> updateProfile({
    required String uid,
    String? name,
    String? phone,
    String? gender,
    String? dob,
    File? imageFile,
    String? specialty,
    String? hospital,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (gender != null) updates['sex'] = gender;
      if (dob != null) updates['dob'] = dob;
      if (specialty != null) updates['specialty'] = specialty;
      if (hospital != null) updates['hospital'] = hospital;

      if (imageFile != null && imageFile.existsSync()) {
        final ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
        await ref.putFile(imageFile);
        final url = await ref.getDownloadURL();
        updates['profileImageUrl'] = url;
      }

      await _firestore.collection('users').doc(uid).update(updates);

      final userDoc = await _firestore.collection('users').doc(uid).get();
      final data = userDoc.data()!;
      final roleStr = data['role'] as String;
      final role = UserRole.values.firstWhere((e) => e.name == roleStr);

      return AppUser(
        id: uid,
        email: data['email'] ?? '',
        displayName: data['name'] ?? '',
        role: role,
        profileImageUrl: data['profileImageUrl'] ?? '',
        specialty: data['specialty'],
        hospital: data['hospital'],
        phone: data['phone'],
        gender: data['sex'],
        dob: data['dob'],
      );
    } catch (e) {
      print("UPDATE PROFILE ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Failed to send reset email');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser == null) return null;

      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) return null;

      final data = userDoc.data()!;
      final roleStr = data['role'] as String;
      final role = UserRole.values.firstWhere(
        (e) => e.name == roleStr,
        orElse: () => UserRole.patient,
      );

      return AppUser(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: data['name'] ?? firebaseUser.email?.split('@').first ?? '',
        role: role,
        profileImageUrl: data['profileImageUrl'] ?? '',
        specialty: data['specialty'],
        hospital: data['hospital'],
        phone: data['phone'],
        gender: data['sex'],
        dob: data['dob'],
      );
    } catch (e) {
      print("GET CURRENT USER ERROR: $e");
      return null;
    }
  }
}
