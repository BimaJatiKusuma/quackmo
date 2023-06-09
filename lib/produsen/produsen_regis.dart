import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/produsen/produsen_login.dart';


class ProdusenRegis extends StatefulWidget {
  const ProdusenRegis({super.key});

  @override
  State<ProdusenRegis> createState() => _ProdusenRegisState();
}

class _ProdusenRegisState extends State<ProdusenRegis> {
  String username = "";
  String email= "";
  String password= "";
  // bool _obscureText = true;
  bool _isObscure = true;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController usernameController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController konfirmasipasswordController =  TextEditingController();

  var role = 'produsen';
  
  // void _toggle(){
  //   setState(() {
  //     _obscureText = !_obscureText;
  //   });
  // }

  _eyePass(_obscureText){
    if (_obscureText == true ){
      return Icon(Icons.remove_red_eye_outlined);
    }
    else{
      return Icon(Icons.remove_red_eye);
    }
  }

  String alertTextRegis='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child:
              Center(child: Image(image: AssetImage('images/regis_01.png'), height: 100,)),
            ),
            Flexible(
              flex: 6,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(225,202,167,1)
                      ),
                child: ListView(
                  children: [
                    Text('Daftar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 36),),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              hintText: 'Nama',
                            ),
                            validator: (value) {
                              if (value!.isEmpty){
                                return "Username tidak boleh kosong";
                              }
                              else {
                                return null;
                              }
                            },
                          ),

                          SizedBox(height: 20,),

                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value!.length == 0){
                                return "Email tidak boleh kosong";
                              }
                              if (!RegExp("^[1-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                                return ("Masukkan email secara benar");
                              }
                              else {
                                return null;
                              }
                            },
                          ),

                          SizedBox(height: 20,),

                          Container(
                            height: 60,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                hintText: 'Kata sandi',
                                // contentPadding: EdgeInsets.all(5),
                                suffix: IconButton(
                                    icon: Icon(_isObscure ? Icons.visibility:Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  )
                              ),
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty){
                                  return "Kata sandi tidak boleh kosong";
                                }
                                if (!regex.hasMatch(value)){
                                  return ("Masukkan kata sandi minimal 6 karakter");
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                          ),

                          SizedBox(height: 20,),
                          
                          Container(
                            height: 60,
                            child: TextFormField(
                              controller: konfirmasipasswordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                hintText: 'Konfirmasi kata sandi',
                                // contentPadding: EdgeInsets.all(5),
                                suffix: IconButton(
                                    icon: Icon(_isObscure ? Icons.visibility:Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                  )
                              ),
                              validator: (value) {
                                if (konfirmasipasswordController.text != passwordController.text){
                                  return "Kata sandi tidak sama";
                                }
                                else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text(alertTextRegis),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),  
                            onPressed: (){
                            signUp(usernameController.text, emailController.text, passwordController.text, role);
                          }, child: Text("Daftar")),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sudah punya akun ?"),
                            TextButton(onPressed: (){
                                  setState(() {
                                    alertText = '';
                                  });
                              Navigator.pop(context);
                            }, child: Text("Masuk"))
                          ],
                        ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void signUp(String nama, String email, String password, String role) async {
    CircularProgressIndicator();
    if(_formkey.currentState!.validate()){
      try{
        //fix this
      await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {postDetailsToFirestore(nama, email, role)});
        // .catchError((e){});
      }
      on FirebaseAuthException catch (e){
        if(e.code == 'email-already-in-use'){
            setState(() {
              alertTextRegis ='email sudah digunakan';
            });
            
          }
      }
    }
  }

  postDetailsToFirestore(String nama, String email, String role) async {
    CircularProgressIndicator();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'nama':usernameController.text, 'email':emailController.text, 'role': role, 'no_hp':'', 'alamat':'', 'kota':'', 'kode_pos':'', 'usia':'', 'gender':'', 'premium':'n','deleted_at':''});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return ProdusenSplashScreenRegis();
    }));
  }



}

class ProdusenSplashScreenRegis extends StatefulWidget {
  const ProdusenSplashScreenRegis({super.key});

  @override
  State<ProdusenSplashScreenRegis> createState() => _ProdusenSplashScreenRegisState();
}

class _ProdusenSplashScreenRegisState extends State<ProdusenSplashScreenRegis> {
  @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return ProdusenLogin();
      }), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 202, 167, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 200, color: Colors.white,),
              Text("AKUN BERHASIL DIBUAT", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}