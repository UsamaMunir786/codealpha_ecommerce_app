import 'package:ecomarce_store/consts/my_validator.dart';
import 'package:ecomarce_store/root_screen.dart';
import 'package:ecomarce_store/screen/auth/signup.dart';
import 'package:ecomarce_store/screen/loading_manager.dart';
import 'package:ecomarce_store/services/my_app_method.dart';
import 'package:ecomarce_store/widget/app_name_text.dart';
import 'package:ecomarce_store/widget/auth/google_button.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/main.dart';


class Login extends StatefulWidget {
  const Login({super.key});
  
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
   final _formkey = GlobalKey<FormState>();
   bool obscuretext = true;
   bool isLoading = false;

   final auth = FirebaseAuth.instance;

    @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

   @override
     void dispose(){
    emailController.dispose();
    passwordController.dispose();
    // FocuseNode
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
   }

   Future<void> _loginfun() async{
    // final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // if (isValid){}
    try {
        setState(() {
          isLoading = true;
        });
        await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Fluttertoast.showToast(
        msg: "login successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => RootScreen()));
      } on FirebaseAuthException catch (error) {
        await MyAppMethod.showErrorORWarningDialog(
          context: context,
          subtitle: 'An error has been occured $error',
          fct: () {},
        );
        
      } finally {
        setState(() {
          isLoading = false;
        });
      }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          
          child: Column(
            children: [
              SizedBox(height: 15,),
              AppNameText(),
              SizedBox(height: 15,),
        
              Align(
                alignment: Alignment.topLeft,
                child: SubtitleText(label: 'Welcome back', fontsize: 22,)),
        
                Form(
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      TextFormField(
                        controller: emailController,
                        focusNode: _emailFocusNode,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      
                        decoration: InputDecoration(
                          hintText: 'Enter email',
                          prefixIcon: Icon(IconlyLight.message),
                        ),
                        validator: (value) {
                          return MyValidator.emailValidator(value);
                        },
                        onFieldSubmitted: (value){
                          FocusScope.of(context).requestFocus(_passwordFocusNode);
                        },
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                    controller: passwordController,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obscuretext,
        
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      prefixIcon: Icon(IconlyLight.lock),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            obscuretext = !obscuretext;
                          });
                        }, 
                        icon: Icon(
                        obscuretext ? Icons.visibility_off : Icons.visibility)),
                    ),
                    validator: (value) {
                      return MyValidator.passwordValidator(value);
                    },
                    onFieldSubmitted: (value){
                      _loginfun();
                    },
                  ),
                  SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){}, 
                      child: SubtitleText(
                        label: 'Forgot Password',
                        textdecoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                      )),
                  ),
                  SizedBox(height: 25,),
        
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      onPressed: (){
                        _loginfun();
                      },
                      icon: Icon(Icons.login),
                      label: Text('Login', style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                  
                  SizedBox(height: 10,),
                  SubtitleText(label: 'or connect using'.toUpperCase()),
        
                  SizedBox(height: 15,),
        
                  SizedBox(
                    height: kBottomNavigationBarHeight + 10,
                    child: Row(
                      children: [
                        Expanded(child: SizedBox(
                          height: kBottomNavigationBarHeight,
                          child: GoogleButton(),
                        ))
                      ],
                    ),
                  ),
        
                  SizedBox(
                    height: 15,
                  ),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubtitleText(label: "Don't have an account. Please!"),
                      SizedBox(width: 8,),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                    }, 
                    child: SubtitleText(
                      label: 'SignUp',
                      textdecoration: TextDecoration.underline,
                    
                    ))
                    ],
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
}