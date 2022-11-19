// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shorts/model/user.dart';
import 'package:shorts/view/screens/auth/login_screen.dart';
import 'package:shorts/view/screens/home_screen.dart';
import 'package:shorts/view/screens/splash_screen.dart';
import 'package:shorts/view/widgets/progress_dailog.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  File? profileImg;
  late Rx<User?> _user;

  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());

    ever(_user, _setInitialView);
  }

  _setInitialView(User? user) {
    if (user == null) {
      Get.offAll(() => const SplashScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }

    final img = File(pickedImage!.path);
    profileImg = img;
  }

  Future<String> _uploadProPic(File image) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String imageDwnUrl = await snapshot.ref.getDownloadURL();
    return imageDwnUrl;
  }

  // Register
  void signUp(
      String username, String email, String password, File? image) async {
    try {
      print("IMAGE HERE");
      print(image.toString() == '');
      print("IMAGE HERE");
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        UserCredential credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadProPic(image);

        MyUser user = MyUser(
          name: username,
          email: email,
          profilePhoto: downloadUrl,
          uid: credential.user!.uid,
        );

        const ProgressDialog(
          status: "Registering...",
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error Occurred", e.toString());
    }
  }

  // Login
  void login(
    String email,
    String password,
  ) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {

        const ProgressDialog(
          status: "Logging in...",
        );

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        Get.snackbar("Error Logging In", "Please enter all the fields");
      }
    } catch (e) {
      Get.snackbar("Error Logging In", e.toString());
    }
  }

  // logout
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(LoginScreen());
  }
}



// Changing models and controllers