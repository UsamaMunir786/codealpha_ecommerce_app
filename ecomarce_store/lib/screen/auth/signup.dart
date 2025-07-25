import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomarce_store/consts/my_validator.dart';
import 'package:ecomarce_store/screen/loading_manager.dart';
import 'package:ecomarce_store/services/my_app_method.dart';
import 'package:ecomarce_store/widget/app_name_text.dart';
import 'package:ecomarce_store/widget/auth/google_button.dart';
import 'package:ecomarce_store/widget/auth/pick_image.dart';
import 'package:ecomarce_store/widget/subtitle_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController conformPasswordController = new TextEditingController();
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _conformPasswordFocusNode;
  final _formkey = GlobalKey<FormState>();

  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  String? userImagesUrl;
  bool obscurePassword = true;
  bool obscureConformPassword = true;
  bool isLoading = false;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _conformPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    // FocuseNode
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _conformPasswordFocusNode.dispose();
    super.dispose();
  }

  // upliad image to cludnery
  Future<String?> uploadImageToCloudinary() async {
  final cloudName = 'dcuxllwmz';
  final uploadPreset = 'flutter_unsigned';

  final imageUploadRequest = http.MultipartRequest(
    'POST',
    Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
  );

  // Add upload preset
  imageUploadRequest.fields['upload_preset'] = uploadPreset;

  if (kIsWeb) {
    if (_pickedImageBytes == null) return null;
    // mime type guess
    final mimeTypeData = lookupMimeType('file.jpg')?.split('/') ?? ['image', 'jpeg'];

    // multipart from bytes
    final multipartFile = http.MultipartFile.fromBytes(
      'file',
      _pickedImageBytes!,
      filename: 'upload.jpg',
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );

    imageUploadRequest.files.add(multipartFile);
  } else {
    if (_pickedImage == null) return null;
    final imageFile = File(_pickedImage!.path);
    if (!imageFile.existsSync()) return null;

    final mimeTypeData = lookupMimeType(imageFile.path)!.split('/');

    final multipartFile = await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );

    imageUploadRequest.files.add(multipartFile);
  }

  try {
    final response = await imageUploadRequest.send();
    final responseData = await response.stream.toBytes();
    final result = json.decode(utf8.decode(responseData));

    if (response.statusCode == 200) {
      return result['secure_url'];
    } else {
      print('Cloudinary upload failed: ${result['error']['message']}');
      return null;
    }
  } catch (e) {
    print('Upload error: $e');
    return null;
  }
}


  Future<void> _signUpfun() async {
  final isValid = _formkey.currentState!.validate();
  FocusScope.of(context).unfocus();

  if (_pickedImage == null) {
    await MyAppMethod.showErrorORWarningDialog(
      context: context,
      subtitle: 'Make sure to pick an image',
      fct: () {},
    );
    return;
  } else {
    print("Picked image path: ${_pickedImage?.path}");
  }

  if (isValid) {
    _formkey.currentState!.save();
    print('Creating account...');

    try {
      setState(() {
        isLoading = true;
      });

      // Validate image file exists
      final imageFile = File(_pickedImage!.path);
      if (!imageFile.existsSync()) {
        Fluttertoast.showToast(msg: "Image file not found. Please try again.");
        setState(() => isLoading = false);
        return;
      }

      // *** Use Cloudinary upload here instead of Firebase Storage ***
      userImagesUrl = await uploadImageToCloudinary();
      if (userImagesUrl == null) {
        Fluttertoast.showToast(msg: "Image upload failed. Please try again.");
        setState(() => isLoading = false);
        return;
      }
      print('Image uploaded to Cloudinary: $userImagesUrl');

      // Create user
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception("User creation failed");

      // Add user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userId': uid,
        'userName': nameController.text.trim(),
        'userImage': userImagesUrl,
        'userEmail': emailController.text.trim(),
        'createdAt': Timestamp.now(),
        'userWish': [],
        'userCart': [],
      });

      Fluttertoast.showToast(
        msg: "Account created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      await MyAppMethod.showErrorORWarningDialog(
        context: context,
        subtitle: 'Firebase error: \$error',
        fct: () {},
      );
    } catch (e) {
      print('Unexpected error: \$e');
      Fluttertoast.showToast(msg: "Error: \$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}


  Future<void> localImagePicker() async {
  print("Opening image picker...");
  if (kIsWeb) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _pickedImageBytes = result.files.single.bytes;
      });
      print("Picked image bytes length: ${_pickedImageBytes!.length}");
    }
    return;
  }
  final ImagePicker picker = ImagePicker();

  await MyAppMethod.imagePickerDialog(
    context: context,
    camraFun: () async {
      _pickedImage = await picker.pickImage(source: ImageSource.camera);
      setState(() {});
      print("Picked image from camera: ${_pickedImage?.path}");
    },
    gelleryFun: () async {
      _pickedImage = await picker.pickImage(source: ImageSource.gallery);
      setState(() {});
      print("Picked image from gallery: ${_pickedImage?.path}");
    },
    removeFun: () {
      setState(() {
        _pickedImage = null;
        _pickedImageBytes = null;
      });
      print("Removed picked image");
    },
  );
}


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
        
          child: Column(
            children: [
              SizedBox(height: 15),
              AppNameText(),
              SizedBox(height: 15),
        
              Align(
                alignment: Alignment.topLeft,
                child: SubtitleText(label: 'Welcome ', fontsize: 22),
              ),
              SizedBox(height: 5),
        
              SizedBox(
                height: size.width * 0.3,
                width: size.width * 0.3,
        
                child: PickImage(
                  pickedImage: _pickedImage,
                  function: () async {
                    await localImagePicker();
                  },
                ),
              ),
        
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    TextFormField(
                      controller: nameController,
                      focusNode: _nameFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
        
                      decoration: InputDecoration(
                        hintText: 'Enter name',
                        prefixIcon: Icon(IconlyLight.profile),
                      ),
                      validator: (value) {
                        return MyValidator.displayNameValidator(value);
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                    ),
        
                    SizedBox(height: 15),
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
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      focusNode: _passwordFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscurePassword,
        
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        prefixIcon: Icon(IconlyLight.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (value) {
                        return MyValidator.passwordValidator(value);
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: conformPasswordController,
                      focusNode: _conformPasswordFocusNode,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureConformPassword,
        
                      decoration: InputDecoration(
                        hintText: 'Conform password',
                        prefixIcon: Icon(IconlyLight.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConformPassword = !obscureConformPassword;
                            });
                          },
                          icon: Icon(
                            obscureConformPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter confirm password';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) async{
                       await _signUpfun();
                      },
                    ),
                    SizedBox(height: 15),
        
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async{
                        await  _signUpfun();
                        },
                        icon: Icon(Icons.login),
                        label: Text(
                          'SignUp',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
