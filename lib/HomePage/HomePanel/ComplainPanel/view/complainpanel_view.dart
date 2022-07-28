import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/HomePage/HomePanel/ComplainPanel/controller/complainpanel_controller.dart';
import 'package:unnayan/HomePage/HomePanel/ComplainPanel/model/complainpanel_model.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';
import 'package:unnayan/my_color.dart';
import 'package:unnayan/my_vars.dart';

class ComplainPage extends StatefulWidget {
  final int? organizationID;
  const ComplainPage(this.organizationID, {Key? key}) : super(key: key);

  @override
  State<ComplainPage> createState() => _ComplainPageState();
}

class _ComplainPageState extends State<ComplainPage> {
  String? filename = "";
  bool fileAttached = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  List<int>? fileBytes;
  String? name, email, phone, detail;
  bool _userTaped = false;
  final controller = ComplainPanelController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [
              MyColor.newLightTeal,
              MyColor.whiteBG,
            ],
          ),
        ),
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Image(
                            image: AssetImage(
                                'assets/images/unnayan_logo_circle.png'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.all(10),
                          height: 120,
                          decoration: BoxDecoration(
                            color: MyColor.newLightBrown,
                            borderRadius: BorderRadius.all(
                              Radius.circular(borderRadius),
                            ),
                          ),
                          child: const Center(
                            child: FittedBox(
                              child: Text(
                                "Please give your authenticcomplain\ngiven the box bellow.If you have \nto need upload any type of photos \nor pdf you can share.Give us some\ninformation about you for contact\nafter solution ",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Align(
                      child: Text(
                        "Please give some Information.",
                        style: CustomTextStyle.RubiktextStyle(
                            MyColor.blackFont, 14),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: const Divider(
                      color: MyColor.blackFont,
                      endIndent: 150,
                    ),
                  ),
                  getInfoPanel(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget getInfoPanel() {
    return Form(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: TextField(
            controller: nameController,
            onChanged: (val) {
              name = val;
            },
            cursorColor: MyColor.newDarkTeal,
            decoration: InputDecoration(
              filled: true,
              fillColor: MyColor.white,
              labelStyle:
                  CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14),
              hintText: 'Name',
              errorText: _userTaped ? errorNameText : null,
              labelText: 'Name',
              focusedBorder: const UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
              ),
            ),
            keyboardType: TextInputType.text,
            style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 14),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: TextField(
            controller: emailController,
            onChanged: (val) {
              email = val;
            },
            cursorColor: MyColor.newDarkTeal,
            decoration: InputDecoration(
              filled: true,
              fillColor: MyColor.white,
              labelStyle:
                  CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14),
              hintText: 'Email Address',
              errorText: _userTaped ? errorEmailText : null,
              labelText: 'Email Address',
              focusedBorder: const UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 14),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: TextField(
            controller: phoneController,
            onChanged: (val) {
              phone = val;
            },
            cursorColor: MyColor.newDarkTeal,
            decoration: InputDecoration(
              filled: true,
              fillColor: MyColor.white,
              labelStyle:
                  CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14),
              errorText: _userTaped ? errorPhoneText : null,
              hintText: 'Phone',
              labelText: 'Phone',
              focusedBorder: const UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
              ),
            ),
            keyboardType: TextInputType.phone,
            style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 14),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Align(
            child: Text(
              "Please give your complaint here.",
              style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 14),
            ),
            alignment: Alignment.centerLeft,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: MyColor.white,
          ),
          child: TextField(
            controller: detailController,
            onChanged: (val) {
              detail = val;
            },
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide:
                    const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
              ),
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 14),
          ),
        ),
        ElevatedButton(
          onPressed: uploadAttachment,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Ink(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    colors: [MyColor.tealBackground, MyColor.newLightTeal]),
                borderRadius: BorderRadius.circular(50)),
            child: Container(
              width: 300,
              height: 50,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Upload Attachment',
                    style: CustomTextStyle.RubiktextStyle(MyColor.white, 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    // <-- Icon
                    Icons.upload,
                    size: 24.0,
                    color: MyColor.newDarkTeal,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        (fileAttached)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  filename!,
                  style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 8),
                ),
              )
            : Container(),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Ink(
            decoration: BoxDecoration(
                color: MyColor.newDarkTeal,
                borderRadius: BorderRadius.circular(50)),
            child: Container(
              width: 300,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                'Submit',
                style: CustomTextStyle.RubiktextStyle(MyColor.white, 14,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ));
  }

  Future uploadAttachment() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);

    if (result != null) {
      PlatformFile file = result.files.first;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("File Attachment"),
      ));

      setState(() {
        fileBytes = file.bytes;
        filename = file.name;
        fileAttached = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed To Upload Attachment"),
      ));
      filename = null;
      fileAttached = false;
    }
  }

  void onSubmit() {
    setState(() {
      _userTaped = true;
    });

    if (nameController.value.text.isNotEmpty &&
        emailController.value.text.isNotEmpty &&
        phoneController.value.text.isNotEmpty &&
        detailController.value.text.isNotEmpty) {
      ComplainPanelModel model = ComplainPanelModel(
        name: name,
        email: email,
        phone: phone,
        detailsByUser: detail,
        status: "pending",
        showNotiftoOrg: "true",
        showNotiftoUser: "false",
        iduser: Provider.of<LoginpageModel>(context, listen: false).iduser,
        organizationsId: widget.organizationID,
        image: fileBytes,
        repliedToOrg: "true",
        repliedToUser: "false",
      );
      controller.submitComplain(model, filename!, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill The Form."),
        ),
      );
    }
  }

  String? get errorNameText {
    final text = nameController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  String? get errorEmailText {
    final text = emailController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

  String? get errorPhoneText {
    final text = phoneController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }
}
