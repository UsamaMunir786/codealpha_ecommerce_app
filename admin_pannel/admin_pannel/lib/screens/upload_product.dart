import 'dart:io';

import 'package:admin_pannel/consts/app_constant.dart';
import 'package:admin_pannel/consts/my_validator.dart';
import 'package:admin_pannel/models/product_model.dart';
import 'package:admin_pannel/services/my_method.dart';
import 'package:admin_pannel/services/my_method.dart';
import 'package:admin_pannel/widget/loading_manager.dart';
import 'package:admin_pannel/widget/subtitle_text.dart';
import 'package:admin_pannel/widget/title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class UploadProduct extends StatefulWidget {
  final ProductModel? productModel;
  const UploadProduct({super.key, this.productModel});

  @override
  State<UploadProduct> createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  final _formKey = GlobalKey<FormState>();
  XFile? pickedImage;
  bool isEditing = false;
  String? productImageNetwork;
  String? categoryValue;
  late TextEditingController titleController,
      priceController,
      quentityController,
      descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      isEditing = true;
      productImageNetwork = widget.productModel!.productImage;
      categoryValue = widget.productModel!.productCategory;
    }
    titleController = TextEditingController(
      text: widget.productModel?.productTitle,
    );
    priceController = TextEditingController(
      text: widget.productModel?.productPrice,
    );
    quentityController = TextEditingController(
      text: widget.productModel?.productQuantity,
    );
    descriptionController = TextEditingController(
      text: widget.productModel?.productDescription,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    quentityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void clearForm() {
    titleController.clear();
    priceController.clear();
    quentityController.clear();
    descriptionController.clear();
    removePickedImage();
  }

  Future<void> uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (pickedImage == null) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: 'Make sure to pick an image',
        fct: () {},
      );
      return;
    }
    if (categoryValue == null) {
      await MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: 'Category is required',
        fct: () {},
      );
      return;
    }
    if (isValid) {
      setState(() => isLoading = true);
      try {
        final imageFile = File(pickedImage!.path);
        final exists = await imageFile.exists();

        print("Image path: ${pickedImage!.path}");
        print("Image exists: $exists");

        if (!exists) {
          Fluttertoast.showToast(
            msg: "Selected image no longer exists. Please pick again.",
          );
          return;
        }

        print("Image exists: ${File(pickedImage!.path).existsSync()}");

        // Upload image to Cloudinary or Firebase Storage
        final productImageUrl = await MyAppMethods.uploadImageToCloud(
          imageFile,
        );
        if (productImageUrl == null) {
          Fluttertoast.showToast(msg: "Image upload failed.");
          return;
        }

        final docRef = FirebaseFirestore.instance.collection('products').doc();
        await docRef.set({
          'productId': docRef.id,
          'productTitle': titleController.text.trim(),
          'productPrice': priceController.text.trim(),
          'productQuantity': quentityController.text.trim(),
          'productDescription': descriptionController.text.trim(),
          'productCategory': categoryValue,
          'productImage': productImageUrl,
          'createdAt': Timestamp.now(),
        });

        Fluttertoast.showToast(
          msg: "Product uploaded successfully",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
        clearForm();
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() => isLoading = true);
      try {
        String? imageUrl = productImageNetwork;
        if (pickedImage != null) {
          final imageFile = File(pickedImage!.path);
          imageUrl = await MyAppMethods.uploadImageToCloud(imageFile);
        }

        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.productModel!.productId)
            .update({
              'productTitle': titleController.text.trim(),
              'productPrice': priceController.text.trim(),
              'productQuantity': quentityController.text.trim(),
              'productDescription': descriptionController.text.trim(),
              'productCategory': categoryValue,
              'productImage': imageUrl,
            });

        Fluttertoast.showToast(msg: "Product updated successfully");
        Navigator.pop(context);
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void removePickedImage() {
    setState(() {
      pickedImage = null;
      productImageNetwork = null;
    });
  }

  //     final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  // if (pickedImage != null) {
  //   File imageFile = File(pickedImage.path);
  //   final imageUrl = await uploadImageToCloud(imageFile);
  //   print('Uploaded image URL: $imageUrl');
  // } else {
  //   print('No image selected');
  //}

  final ImagePicker imagePicker = ImagePicker();
  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();

    await MyAppMethods.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        final picked = await imagePicker.pickImage(source: ImageSource.camera);
        if (picked != null) {
          final saved = await _saveImageLocally(picked);
          setState(() => pickedImage = saved);
        }
      },
      galleryFCT: () async {
        final picked = await imagePicker.pickImage(source: ImageSource.gallery);
        if (picked != null) {
          final saved = await _saveImageLocally(picked);
          setState(() => pickedImage = saved);
        }
      },
      removeFCT: () {
        removePickedImage();
      },
    );
  }

  Future<XFile> _saveImageLocally(XFile original) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = original.name;
    final localPath = '${directory.path}/$fileName';
    final localFile = await File(original.path).copy(localPath);
    return XFile(localFile.path);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.clear),
                    label: Text('cancle'),
                  ),

                  SizedBox(width: 25),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (isEditing) {
                        editProduct();
                      } else {
                        uploadProduct();
                      }
                    },
                    icon: Icon(Icons.upload),
                    label: Text(isEditing ? 'edit product' : 'upload product'),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            centerTitle: true,
            title: TitleText(
              label: isEditing ? 'edit product' : 'Upload a new Product',
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  // imagepicker code
                  if (isEditing && productImageNetwork != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productImageNetwork!,
                        height: size.width * 0.3,
                        width: size.width * 0.4,
                        alignment: Alignment.center,
                      ),
                    ),
                  ] else if (pickedImage == null) ...[
                    SizedBox(
                      width: size.width * 0.4 + 10,
                      height: size.width * 0.4,
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 80,
                            color: Colors.blue,
                          ),
                          TextButton(
                            onPressed: () {
                              localImagePicker();
                            },
                            child: Text(
                              'Pick Product Image',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(pickedImage!.path),
                          height: size.width * 0.3,
                          //  width: size.width*0.6,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                  if (pickedImage != null && productImageNetwork != null) ...[
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            localImagePicker();
                          },
                          child: Text('pick another image'),
                        ),
                        TextButton(
                          onPressed: () {
                            removePickedImage();
                          },
                          child: Text('remove image'),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 20),
                  // toselect category dropdown
                  DropdownButton<String>(
                    hint: Text('Select Category'),
                    value: categoryValue,
                    items: AppConstant.categoriesDropDownList,
                    onChanged: (value) {
                      setState(() {
                        categoryValue = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),

                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            key: ValueKey('Title'),
                            maxLength: 60,
                            minLines: 1,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'Product Title',
                            ),
                            validator: (value) {
                              return MyValidator.uploadProdTexts(
                                value: value,
                                toBeReturneddString:
                                    'Please enter a valid title',
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: priceController,
                                  key: ValueKey('Price \$'),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^[-+]?\d+(\.\d+)?$'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'price',
                                    prefix: SubtitleText(
                                      label: '\$ ',
                                      color: Colors.blueAccent,
                                      fontsize: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    return MyValidator.uploadProdTexts(
                                      value: value,
                                      toBeReturneddString: 'Price is missing',
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),

                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: quentityController,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  decoration: InputDecoration(hintText: 'Qty'),
                                  validator: (value) {
                                    return MyValidator.uploadProdTexts(
                                      value: value,
                                      toBeReturneddString: 'Quntity is missing',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            key: ValueKey('Description'),
                            controller: descriptionController,
                            minLines: 5,
                            maxLines: 8,
                            maxLength: 1000,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'product description',
                            ),
                            validator: (value) {
                              return MyValidator.uploadProdTexts(
                                value: value,
                                toBeReturneddString: 'Description is missing',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: kBottomNavigationBarHeight + 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
