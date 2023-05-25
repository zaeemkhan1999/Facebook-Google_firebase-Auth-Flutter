import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double defaultPadding = 16.0;

var brightness = SchedulerBinding.instance.window.platformBrightness;
bool isDarkMode = brightness == Brightness.dark;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const colorIcon = Color.fromARGB(255, 245, 95, 90);
    const primaryColor = Color.fromARGB(255, 245, 95, 90);
    var bgColor = Colors.white;
    if (isDarkMode) {
      bgColor = Colors.black;
    }
    final emailController = TextEditingController();
    final pwdController = TextEditingController();
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: defaultPadding * 3),
              Row(
                children: const [
                  Spacer(),
                  Expanded(
                      flex: 5,
                      child: Icon(
                        Icons.shopping_bag,
                        color: colorIcon,
                        size: 60,
                      )),
                  Spacer()
                ],
              ),
              const SizedBox(height: defaultPadding * 4),
              Form(
                  child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: defaultPadding * 2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                        text: "EMAIL",
                        primaryColor: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2),
                    child: LogInTextField(
                      primaryColor: primaryColor,
                      hintText: "user@live.com",
                      type: "email",
                      myController: emailController,
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  const Padding(
                    padding: EdgeInsets.only(left: defaultPadding * 2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                        text: "PASSWORD",
                        primaryColor: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding * 2),
                    child: LogInTextField(
                      primaryColor: primaryColor,
                      hintText: "*********",
                      type: "password",
                      myController: pwdController,
                    ),
                  )
                ],
              )),
              const SizedBox(height: defaultPadding * 2),
              const Padding(
                padding: EdgeInsets.only(right: defaultPadding * 2),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CustomText(
                    text: "Forgot Password?",
                    primaryColor: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(300, 60)),
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: pwdController.text);
                      log(credential.toString());
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text(
                                      'No user found for that email.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Ok'),
                                    ),
                                  ]);
                            });
                      } else if (e.code == 'wrong-password') {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text('Wrong email or password'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Ok'),
                                    ),
                                  ]);
                            });
                      } else {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text("Wrong Email or password"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Ok'),
                                    ),
                                  ]);
                            });
                      }
                    }
                  },
                  child: const CustomText(
                    primaryColor: Colors.white,
                    text: "LOGIN",
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: defaultPadding * 1),
              const CustomDivider(),
              const SizedBox(height: defaultPadding * 1),
              const SocialSignUp(),
              const SizedBox(height: defaultPadding * 1),
              GestureDetector(
                onTap: () async {
                  await signInWithTwitter();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    border: Border.all(
                      width: 1,
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(40),
                    shape: BoxShape.rectangle,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/twitter.svg',
                        height: 20,
                        width: 20,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomText(
                            primaryColor: Colors.white,
                            text: "TWITTER",
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding * 1),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: defaultPadding * 1),
              IconButton(
                  splashRadius: 1,
                  onPressed: () {
                    isDarkMode = !isDarkMode;
                    RestartWidget.restartApp(context);
                  },
                  icon: const Icon(
                    Icons.dark_mode,
                    color: colorIcon,
                    size: 30,
                  ))
            ],
          ),
        )),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Expanded(
          child: Divider(
            color: Color.fromARGB(207, 158, 158, 158),
            height: 25,
            thickness: 2,
            indent: defaultPadding * 2,
            endIndent: 9.5,
          ),
        ),
        CustomText(
          primaryColor: Color.fromARGB(207, 158, 158, 158),
          text: "OR CONNECT WITH",
          fontWeight: FontWeight.bold,
        ),
        Expanded(
          child: Divider(
            color: Color.fromARGB(207, 158, 158, 158),
            height: 25,
            thickness: 2,
            indent: 9.5,
            endIndent: defaultPadding * 2,
          ),
        )
      ],
    );
  }
}

class LogInTextField extends StatelessWidget {
  const LogInTextField(
      {Key? key,
      required this.primaryColor,
      required this.hintText,
      required this.myController,
      required this.type})
      : super(key: key);

  final Color primaryColor;
  final String hintText;
  final String type;
  final TextEditingController myController;

  @override
  Widget build(BuildContext context) {
    var keyboardType = TextInputType.emailAddress;
    var obsucre = false;
    var textInputAction = TextInputAction.next;
    var maxLength = 50;
    var textColor = Colors.black;
    var hintTextColor = const Color.fromARGB(120, 0, 0, 0);

    if (type == "password") {
      obsucre = true;
      keyboardType = TextInputType.text;
      textInputAction = TextInputAction.done;
      maxLength = 20;
    }

    if (isDarkMode) {
      textColor = primaryColor;
      hintTextColor = primaryColor;
    }

    return TextField(
        style: TextStyle(color: textColor),
        controller: myController,
        maxLength: maxLength,
        obscureText: obsucre,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor.withOpacity(0.5))),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          hintText: hintText,
          hintStyle: TextStyle(color: hintTextColor.withOpacity(0.5)),
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction);
  }
}

class CustomText extends StatelessWidget {
  const CustomText(
      {Key? key,
      required this.primaryColor,
      required this.text,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  final Color primaryColor;
  final String text;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: primaryColor, fontWeight: fontWeight),
    );
  }
}

class SocialSignUp extends StatelessWidget {
  const SocialSignUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            await signInWithFacebook();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              border: Border.all(
                width: 1,
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(40),
              shape: BoxShape.rectangle,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/facebook.svg',
                  height: 20,
                  width: 20,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(
                      primaryColor: Colors.white,
                      text: "FACEBOOK",
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await signInWithGoogle();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[700],
              border: Border.all(
                width: 1,
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(40),
              shape: BoxShape.rectangle,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/google-plus.svg',
                  height: 20,
                  width: 20,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomText(
                    primaryColor: Colors.white,
                    text: "GOOGLE",
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<UserCredential> signInWithTwitter() async {
  // Create a TwitterLogin instance
  final twitterLogin = TwitterLogin(
    apiKey: 'cYZiHgIaZ7OkcQGnyRnKzHONw',
    apiSecretKey: 'AQS0nDvZOzchtsq9r8JNbvMgzOlgYilyUMbUc6V5wohsGrOsUi',
    redirectURI: 'https://assignment4-30736.firebaseapp.com/__/auth/handler',
  );

  // Trigger the sign-in flow
  final authResult = await twitterLogin.login();

  // Create a credential from the access token
  final twitterAuthCredential = TwitterAuthProvider.credential(
    accessToken: authResult.authToken!,
    secret: authResult.authTokenSecret!,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance
      .signInWithCredential(twitterAuthCredential);
}

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, this.child});

  final Widget? child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<StatefulWidget> createState() {
    return _RestartWidgetState();
  }
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child ?? Container(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          Navigator.pop(context);
        },
        child: const Text('Logout'),
      )),
    ));
  }
}

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 245, 95, 90);
    final emailController = TextEditingController();
    final pwdController = TextEditingController();
    final firstName = TextEditingController();
    final lastName = TextEditingController();

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: defaultPadding * 3),
            Form(
                child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: defaultPadding * 2),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "FIRST NAME",
                      primaryColor: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2),
                  child: LogInTextField(
                    primaryColor: primaryColor,
                    hintText: "John",
                    type: "name",
                    myController: firstName,
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                const Padding(
                  padding: EdgeInsets.only(left: defaultPadding * 2),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "LAST NAME",
                      primaryColor: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2),
                  child: LogInTextField(
                    primaryColor: primaryColor,
                    hintText: "Smith",
                    type: "name",
                    myController: lastName,
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                const Padding(
                  padding: EdgeInsets.only(left: defaultPadding * 2),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "GENDER",
                      primaryColor: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const RadioList(),
                const SizedBox(height: defaultPadding * 2),
                const Padding(
                  padding: EdgeInsets.only(left: defaultPadding * 2),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "EMAIL",
                      primaryColor: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2),
                  child: LogInTextField(
                    primaryColor: primaryColor,
                    hintText: "user@live.com",
                    type: "email",
                    myController: emailController,
                  ),
                ),
                const SizedBox(height: defaultPadding * 2),
                const Padding(
                  padding: EdgeInsets.only(left: defaultPadding * 2),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "PASSWORD",
                      primaryColor: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2),
                  child: LogInTextField(
                    primaryColor: primaryColor,
                    hintText: "*********",
                    type: "password",
                    myController: pwdController,
                  ),
                )
              ],
            )),
            const SizedBox(height: defaultPadding * 2),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(300, 60)),
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: pwdController.text);
                    log(userCredential.toString());
                    FirebaseFirestore db = FirebaseFirestore.instance;

                    db.collection("users").doc(emailController.text).set(Nadra(
                          firstName: firstName.text,
                          lastName: lastName.text,
                          email: emailController.text,
                          gender: gender,
                        ).toJson());

                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text(
                                    'The password provided is too weak.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Ok'),
                                  ),
                                ]);
                          });
                    } else if (e.code == 'email-already-in-use') {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text(
                                    'The account already exists for that email.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Ok'),
                                  ),
                                ]);
                          });
                    }
                  }
                },
                child: const CustomText(
                  primaryColor: Colors.white,
                  text: "Sign Up",
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(height: defaultPadding * 1),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      )),
    ));
  }
}

String gender = "male";

class RadioList extends StatefulWidget {
  const RadioList({super.key});

  @override
  State<RadioList> createState() => _RadioListState();
}

class _RadioListState extends State<RadioList> {
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 245, 95, 90);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RadioListTile(
          activeColor: primaryColor,
          visualDensity: const VisualDensity(vertical: -3),
          title: const Text("Male"),
          value: "male",
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = 'male';
            });
          },
        ),
        RadioListTile(
          activeColor: primaryColor,
          visualDensity: const VisualDensity(vertical: -3),
          title: const Text("Female"),
          value: "female",
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = 'female';
            });
          },
        ),
        RadioListTile(
          activeColor: primaryColor,
          visualDensity: const VisualDensity(vertical: -3),
          title: const Text("Other"),
          value: "other",
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value.toString();
            });
          },
        )
      ],
    );
  }
}

class Nadra {
  String firstName;
  String lastName;
  String email;
  String gender;

  Nadra({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "gender": gender,
    };
  }

  factory Nadra.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'] as String;
    final lastName = json['lastName'] as String;
    final email = json['email'] as String;
    final gender = json['gender'] as String;

    return Nadra(
      firstName: firstName,
      lastName: lastName,
      email: email,
      gender: gender,
    );
  }
}
