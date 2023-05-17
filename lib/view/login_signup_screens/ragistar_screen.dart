import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../res/common/textfeild_container.dart';
import 'login_screen.dart';

class RagisterScreen extends StatefulWidget {
  const RagisterScreen({Key? key}) : super(key: key);

  @override
  State<RagisterScreen> createState() => _RagisterScreenState();
}

class _RagisterScreenState extends State<RagisterScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool passwordVisible = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? userCredential;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF192396),
        centerTitle: true,
        title: const Text("Registrarse"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 21,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 160, right: 20),
          child: Column(
            children: [
              TextFieldContainer(
                controller: namecontroller,
                hintText: "Nombre y Apellido",
              ),
              const SizedBox(height: 10),
              TextFieldContainer(
                controller: emailcontroller,
                hintText: "Correo electrónico",
              ),
              const SizedBox(height: 10),
              TextFieldContainer(
                obscureText: !passwordVisible,
                controller: passwordcontroller,
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF8C91CB),
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
                hintText: "Contraseña",
              ),
              const SizedBox(height: 10),
              RichText(
                text: const TextSpan(
                  text: 'Tip: La contraseña debe contener al menos   ',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "SF-Pro",
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF48527D),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '8 caracteres,',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF48527D),
                      ),
                    ),
                    TextSpan(
                      text: "\npara hacerla más fuerte usa números y símbolos.",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "SF-Pro",
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF48527D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  if (validator()) {
                    debugPrint("succesfully login");
                  } else {
                    userSignup();
                  }
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
                    "Registrar",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "SF-Pro",
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFBFBFB),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Si ya tienes una cuenta ",
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
                          builder: (context) => LoginScreenTwo(),
                        ),
                      );
                    },
                    child: const Text(
                      "inicia sesión",
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
            ],
          ),
        ),
      ),
    );
  }

  showToastMessage(message) {
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
    if (namecontroller.text.isEmpty) {
      showToastMessage("Please enter name");
      return false;
    } else if (emailcontroller.text.isEmpty) {
      showToastMessage("Please enter email");
      return false;
    } else if (!RegExp(
            r"^[a-zA-Z0-9,a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailcontroller.text)) {
      showToastMessage("Please enter valid email");
      return false;
    } else if (passwordcontroller.text.isEmpty) {
      showToastMessage("Please enter password");
      return false;
    } else if (!RegExp(
            "^(?=.*[A-Z].*[A-Z])(?=.*[!@#\$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}")
        .hasMatch(passwordcontroller.text)) {
      showToastMessage("Please enter valid password");
      return false;
    } else {
      return false;
    }
  }

  userSignup() async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      )
          .then((value) {
        debugPrint("User Data --> ${value.user}");
        userCredential = value.user;
        value.user!.sendEmailVerification();
        setState(() {});
      });
    } on FirebaseAuthException catch (error) {
      showToastMessage(error.message);
      showToastMessage(error.code);
    }
  }
}
