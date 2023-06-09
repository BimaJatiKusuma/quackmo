import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_homepage.dart';
import 'package:quackmo/produsen/produsen_regis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdusenLogin extends StatefulWidget {
  const ProdusenLogin({super.key});

  @override
  State<ProdusenLogin> createState() => _ProdusenLoginState();
}

String userProdusenID = '';
String alertText = ' ';
String premiumProdusen = '';

class _ProdusenLoginState extends State<ProdusenLogin> {
  bool _isObscure = true;
  bool visible = false;
  bool isChecked = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 40,),
                    Column(
                      children: [
                        Container(
                          width: 75,
                          child: Image(image: AssetImage('images/produsen_01.png'))),
                          SizedBox(height: 20,),
                        Text("Produsen Telur Asin"),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(225,202,167,1)
                      ),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Container(width: double.infinity,child: Text("Masuk", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),)),
                            SizedBox(height: 20,),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                hintText: 'Email'
                              ),
                              validator: (value) {
                                if (value!.length == 0){
                                    setState(() {
                                      visible = false;
                                    });
                                    return "Email tidak boleh kosong";
                                  }
                                  if (!RegExp("^[1-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                                    setState(() {
                                      visible = false;
                                    });
                                    return ("Masukkan email secara benar");
                                  }
                                  else {
                                    return null;
                                  }
                              },
                              onSaved: (newValue) {
                                emailController.text = newValue!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),

                            SizedBox(height: 20,),
                            
                            TextFormField(
                              controller: passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                hintText: 'Kata sandi',
                                suffixIcon: IconButton(
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
                                  setState(() {
                                    visible = false;
                                  });
                                  return "Kata sandi tidak boleh kosong";
                                }
                                if (!regex.hasMatch(value)){
                                  setState(() {
                                    visible = false;
                                  });
                                  return ("Masukkan kata sandi minimal 6 karakter");
                                }
                                else {
                                  return null;
                                }
                              },
                              onSaved: (newValue) {
                                passwordController.text = newValue!;
                              },
                            ),
                            
                            Text("${alertText}", style: TextStyle(color: Colors.red),),
                    
                    
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(onPressed: (){
                                setState(() {
                                  visible = true;
                                });
                                // CircularProgressIndicator();
                                signIn(emailController.text, passwordController.text);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                              child: Text("Masuk")),
                            ),
                      
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Belum Punya Akun?"),
                                TextButton(onPressed: (){
                                      setState(() {
                                        alertText = '';
                                      });
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return ProdusenRegis();
                                  }));
                                }, child: Text("daftar"))
                              ],
                            ),
                      
                            
                    
                            Visibility(
                                    visible: visible,
                                    child: Container(
                                        child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))),
                    
                    
                    
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }






  void route(){
    User? user = FirebaseAuth.instance.currentUser;
    var user_role = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists){
                        if(documentSnapshot.get('deleted_at')==''){
                          if(documentSnapshot.get('role')=='produsen'){
                            userProdusenID = user.uid;
                                setState(() {
                                  alertText = '';
                                });
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                              return ProdusenHomepage();
                            }), (route) => false);
                          }
                          else{
                            setState(() {
                              visible = false;
                              alertText = 'User Belum mendaftar sebagai produsen';
                            });
                            return print('User Belum mendaftar sebagai produsen');
                          }
                        }
                        else{
                          setState(() {
                            visible = false;
                            alertText = 'Akun telah dihapus/dinonaktifkan';
                          });
                          return print('Akun telah dihapus/dinonaktifkan');
                        }

                      }
                      else{
                        setState(() {
                          visible = false;
                          alertText = 'Email tidak terdaftar';
                        });
                        print('Email tidak terdaftar');
                      }
                    });
  }





  void signIn(String email, String password) async {
    if(_formkey.currentState!.validate()){
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        route();
      }
      on FirebaseAuthException catch (e){
        if (e.code == 'user-not-found'){
          setState(() {
            visible = false;
            alertText = 'Email tidak terdaftar';
          });
          print('Email tidak terdaftar');
        }
        else if (e.code == 'wrong-password'){
          setState(() {
            visible = false;
            alertText = 'Kata sandi salah';
          });
          print('Kata sandi salah');
        }
      }
    }
  }














}