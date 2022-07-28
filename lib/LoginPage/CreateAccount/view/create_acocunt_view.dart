import 'dart:developer';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/LoginPage/CreateAccount/controller/create_account_controller.dart';
import 'package:unnayan/LoginPage/view/loginpage_view.dart';
import 'package:unnayan/my_color.dart';

class CreateAcountSTF extends StatefulWidget {
  const CreateAcountSTF({Key? key}) : super(key: key);

  @override
  State<CreateAcountSTF> createState() => _CreateAcountSTFState();
}

class _CreateAcountSTFState extends State<CreateAcountSTF> {
  final createAccountKey = GlobalKey<FormState>();
  late String userDropdownValue;
  late String orgDropdownValue;

  final List<String> orgItems = [
    'Hospital',
    'Shopping Center',
    'Education',
    'Company',
    'Industry',
    'Dhaka Metro Poline'
  ];
  bool ifOrg = false;
  List<int>? fileBytes;
  String? fileName;
  late bool fileAttached;
  String? FullName,
      Email,
      Password,
      Location,
      Username,
      CellNumber,
      UserType,
      InstituteName;
  int? orgType;
  final CreateAccountController createAccountController =
      CreateAccountController();
  final usernameTextController = TextEditingController();
  bool validUserName = false;
  bool showPictureWarning = false;
  @override
  void initState() {
    // TODO: implement initState
    userDropdownValue = 'User';
    orgDropdownValue = orgItems.first;
    UserType = userDropdownValue.toLowerCase();
    orgType = orgItems.indexOf(orgItems.first) + 1;
    fileAttached = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColor.newLightTeal,
        body: SingleChildScrollView(
          child: Form(
            key: createAccountKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: AddPhoto,
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipOval(
                              child: Container(
                                color: MyColor.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: (fileAttached == true)
                                      ? ClipOval(
                                          child: Image(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(
                                            Uint8List.fromList(fileBytes!),
                                          ),
                                        ))
                                      : ClipOval(
                                          child: Container(
                                            color: MyColor.ash,
                                            child: const Icon(Icons.camera_alt),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(left: 75),
                                child: Icon(
                                  Icons.add,
                                  size: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    (showPictureWarning)
                        ? SizedBox(
                            height: 10,
                          )
                        : Container(),
                    (showPictureWarning)
                        ? Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: MyColor.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "*Required Picture!!",
                              style: CustomTextStyle.RubiktextStyle(
                                  MyColor.red, 10),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: Text("Select User Type: ")),
                            Flexible(
                              child: DropdownButton<String>(
                                focusColor: MyColor.newDarkTeal,
                                value: userDropdownValue,
                                icon: const Icon(
                                  Icons.arrow_downward,
                                  color: MyColor.newDarkBrown,
                                ),
                                elevation: 16,
                                style: CustomTextStyle.RubiktextStyle(
                                    MyColor.newDarkTeal, 12),
                                underline: Container(
                                  height: 2,
                                  color: MyColor.newDarkTeal,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    userDropdownValue = newValue!;
                                    UserType = newValue.toLowerCase();
                                    log(newValue.toString());
                                    if (newValue == "User") {
                                      ifOrg = false;
                                    } else {
                                      ifOrg = true;
                                      InstituteName = null;
                                    }
                                  });
                                },
                                items: <String>[
                                  'User',
                                  'Organization'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        (ifOrg == true)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(
                                      child:
                                          Text("Select Organization Type: ")),
                                  Flexible(
                                    child: DropdownButton<String>(
                                      value: orgDropdownValue,
                                      icon: const Icon(
                                        Icons.arrow_downward,
                                        color: MyColor.newDarkBrown,
                                      ),
                                      elevation: 16,
                                      style: CustomTextStyle.RubiktextStyle(
                                          MyColor.newDarkTeal, 12),
                                      underline: Container(
                                        height: 2,
                                        color: MyColor.newDarkTeal,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          orgDropdownValue = newValue!;
                                          orgType =
                                              orgItems.indexOf(newValue) + 1;
                                          log(orgType.toString());
                                        });
                                      },
                                      items: orgItems
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: MyColor.newDarkTeal,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColor.white,
                        labelStyle: CustomTextStyle.RubiktextStyle(
                            MyColor.newDarkTeal, 14),
                        hintText: 'Full Name',
                        labelText: 'Full Name',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Name';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          FullName = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: MyColor.newDarkTeal,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColor.white,
                        labelStyle: CustomTextStyle.RubiktextStyle(
                            MyColor.newDarkTeal, 14),
                        hintText: 'Email',
                        labelText: 'Email',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "Please enter a valid email address";
                        }

                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          Email = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      cursorColor: MyColor.newDarkTeal,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColor.white,
                        labelStyle: CustomTextStyle.RubiktextStyle(
                            MyColor.newDarkTeal, 14),
                        hintText: 'Password',
                        labelText: 'Password',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Password';
                        } else if (value.length < 6) {
                          return 'Password Is Short';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          Password = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: MyColor.newDarkTeal,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColor.white,
                        labelStyle: CustomTextStyle.RubiktextStyle(
                            MyColor.newDarkTeal, 14),
                        hintText: 'Cell No.',
                        labelText: 'Cell No.',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Cell No.';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          CellNumber = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      cursorColor: MyColor.newDarkTeal,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColor.white,
                        labelStyle: CustomTextStyle.RubiktextStyle(
                            MyColor.newDarkTeal, 14),
                        hintText: 'Location',
                        labelText: 'Location',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: MyColor.newDarkTeal, width: 0.0),
                        ),
                      ),
                      keyboardType: TextInputType.streetAddress,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Your Location';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          Location = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (ifOrg == false)
                        ? TextFormField(
                            cursorColor: MyColor.newDarkTeal,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MyColor.white,
                              labelStyle: CustomTextStyle.RubiktextStyle(
                                  MyColor.newDarkTeal, 14),
                              hintText: 'Institution Name',
                              labelText: 'Institution Name',
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColor.newDarkTeal, width: 0.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MyColor.newDarkTeal, width: 0.0),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Your Institution Name';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setState(() {
                                InstituteName = val;
                              });
                            },
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                              color: MyColor.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Container(
                            width: 300,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Submit',
                              style: CustomTextStyle.RubiktextStyle(
                                  MyColor.newDarkTeal, 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (createAccountKey.currentState!.validate()) {
                            // Process data.

                            onSubmit();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit() async {
    if (fileAttached) {
      if (UserType == 'user') {
        await createAccountController
            .createAccountForUser(FullName, Email, Password, Location,
                fileBytes, fileName, CellNumber, UserType, InstituteName)
            .whenComplete(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
        });
      } else {
        await createAccountController
            .createAccountForOrg(FullName, Email, Password, Location, fileBytes,
                fileName, CellNumber, UserType, orgType)
            .whenComplete(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
        });
      }
    } else {
      setState(() {
        showPictureWarning = true;
      });
    }
  }

  Future<void> AddPhoto() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);

    if (result != null) {
      PlatformFile file = result.files.first;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("File Attachment"),
      ));

      setState(() {
        fileBytes = file.bytes;
        fileName = file.name;

        fileAttached = true;
        showPictureWarning = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed To Upload Attachment"),
      ));
      fileAttached = false;
    }
  }
}
