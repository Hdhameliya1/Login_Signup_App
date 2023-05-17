import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_signup/view/login_signup_screens/ragistar_screen.dart';

import '../../res/common/textfeild_container.dart';

class LoginScreenTwo extends StatefulWidget {
  const LoginScreenTwo({Key? key}) : super(key: key);

  @override
  State<LoginScreenTwo> createState() => _LoginScreenTwoState();
}

class _LoginScreenTwoState extends State<LoginScreenTwo> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  dynamic value;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF192396),
        centerTitle: true,
        title: const Text("Registrarse"),
        leading: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 21,
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 160, right: 20),
            child: Column(
              children: [
                const Image(
                  image: AssetImage("assets/images/Frame.png"),
                ),
                const SizedBox(height: 40),
                TextFieldContainer(
                  controller: emailController,
                  hintText: "Correo electrónico",
                ),
                const SizedBox(height: 10),
                TextFieldContainer(
                  obscureText: !passwordVisible,
                  controller: passwordController,
                  suffixIcon: GestureDetector(
                    child: ImageIcon(
                      passwordVisible
                          ? const AssetImage("assets/images/faceidtwo.png")
                          : const AssetImage("assets/images/faceid.png"),
                    ),
                    onTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  hintText: "Contraseña",
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF192396),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    if (validator()) {
                      debugPrint("succesfully login");
                    } else {
                      userLogin();
                    }
                    //formKey.currentState!.validate();
                    setState(() {});
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD1D3EA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Iniciar sesión",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFBFBFB),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿No tienes una cuenta? ",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF656565),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RagisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Registrate",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "SF-Pro",
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF192396),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: googleSignin,
                  child: const Text("Sign In with Google"),
                ),
                ElevatedButton(
                  onPressed: githubSignin,
                  child: const Text("Sign In with Git Hub"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showToastMessage(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      // timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.black26,
      fontSize: 16.0,
    );
  }

  bool validator() {
    if (emailController.text.isEmpty) {
      showToastMessage("Please enter email");
      return false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      showToastMessage("Please enter valid email");
      return false;
    } else if (passwordController.text.isEmpty) {
      showToastMessage("Please enter password");
      return false;
    } else if (!RegExp(
            "^(?=.*[A-Z].*[A-Z])(?=.*[!@#\$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}")
        .hasMatch(passwordController.text)) {
      showToastMessage("Please enter valid password");
      return false;
    } else {
      return false;
    }
  }

  userLogin() async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        debugPrint("User Data --> ${value.user}");
        user = value.user;
        if (value.user!.emailVerified) {
          value.user!.sendEmailVerification();
          debugPrint("User has Login --> ");
        } else {
          dialog();
        }
        setState(() {});
      });
    } on FirebaseAuthException catch (error) {
      showToastMessage("Error Code --->>>${error.code}");
    }
  }

  dialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 150,
          width: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "your email hasn't verified\n if you want to verified your email then press re-send button",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        user!.sendEmailVerification();
                        setState(() {});
                      },
                      child: const Text("Re-Send"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  googleSignin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  githubSignin() async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: "416017eeac76d3bc2b03",
        clientSecret: "9e4c294ecd89c26073ecf80d64585faf0c1adee6",
        redirectUrl:
            'https://login-signup-app-6de15.firebaseapp.com/__/auth/handler');
    final result = await gitHubSignIn.signIn(context);
    final githubAuthCredential = GithubAuthProvider.credential(result.token!);
    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }
}
